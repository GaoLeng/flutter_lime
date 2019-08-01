import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_lime/beans/db_ocr_history_bean.dart';
import 'package:flutter_lime/db/database_helper.dart';
import 'package:flutter_lime/pages/img_view_page.dart';
import 'package:flutter_lime/utils/const.dart';
import 'package:flutter_lime/utils/log_utils.dart';

import '../ocr_result_page.dart';

//历史识别页面
class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<DBOcrHistoryBean> histories;

  _HistoryPageState() {}

  @override
  void initState() {
    super.initState();
    queryHistory();
    LogUtils.i("history page initState.");
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListView.separated(
        itemCount: histories == null ? 0 : histories.length,
        itemBuilder: ((context, index) {
          return Dismissible(
            key: Key(histories[index].toString()),
            child: generateItem(histories[index], index),
            onDismissed: (direction) {
              histories.removeAt(index);
            },
            background: Container(
              color: Colors.red,
              child: Center(
                  child: Text(
                "删除",
                style: TextStyle(color: Colors.white),
              )),
            ),
            confirmDismiss: (DismissDirection direction) async {
              return await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("提示"),
                      content: const Text("确认要删除此记录吗？"),
                      actions: <Widget>[
                        FlatButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text("删除")),
                        FlatButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text("取消"),
                        )
                      ],
                    );
                  });
            },
          );
        }),
        separatorBuilder: ((context, index) {
          return Divider(height: 1);
        }),
      ),
    );
  }

  Widget generateItem(DBOcrHistoryBean bean, int index) {
    return InkWell(
      onTap: () => _onItemClick(index),
      child: Container(
        padding: EdgeInsets.all(8),
        child: Row(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ImageViewPage(bean);
                }));
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                child: FadeInImage(
                  key: Key(bean.imgPath),
                  fadeInDuration: Duration(milliseconds: 100),
                  placeholder: AssetImage("images/palceholder.png"),
                  image: FileImage(File(bean.imgPath + image_suffix)),
                  width: 72,
                  height: 72,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              flex: 1,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text(
                        bean.result,
                        maxLines: 3,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                    ),
                    Text(
                      bean.dateTime,
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onItemClick(int index) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return OcrResultPage([histories[index]]);
    }));
  }

  void queryHistory() {
    DataBaseHelper.getInstance()
        .getDatabase()
        .query(DataBaseHelper.table_ocr_history, orderBy: "ID desc")
        .then((value) {
      // LogUtils.i("queryHistory: $value");
      histories = List();
      value.forEach((row) {
        var bean = DBOcrHistoryBean.fromDb(row);
        histories.add(bean);
        // precacheImage(FileImage(File(bean.imgPath)), context);
      });
      if (histories.length == 0) return;
      setState(() {});
    });
  }
}
