import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_lime/beans/db_ocr_history_bean.dart';
import 'package:flutter_lime/db/database_helper.dart';
import 'package:flutter_lime/utils/log_utils.dart';
import 'package:flutter_lime/utils/utils.dart';

import '../ocr_result_page.dart';

//历史识别页面
class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<DBOcrHistoryBean> histories;

  @override
  void initState() {
    super.initState();
    queryHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListView.separated(
        itemCount: histories == null ? 0 : histories.length,
        itemBuilder: ((context, index) {
          return generateItem(histories[index], index);
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
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              child: FadeInImage(
                fadeInDuration: Duration(milliseconds: 100),
                placeholder: AssetImage("images/palceholder.png"),
                image: FileImage(File(bean.imgPath)),
                width: 72,
                height: 72,
                fit: BoxFit.cover,
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
      return OcrResultPage(histories[index]);
    }));
  }

  void queryHistory() {
    DataBaseHelper.getInstance()
        .getDatabase()
        .query(DataBaseHelper.table_ocr_history)
        .then((value) {
      LogUtils.i("queryHistory: $value");
      histories = List();
      value.forEach((row) {
        histories.add(DBOcrHistoryBean.fromDb(row));
      });
      if (histories.length == 0) return;
      setState(() {});
    });
  }
}
