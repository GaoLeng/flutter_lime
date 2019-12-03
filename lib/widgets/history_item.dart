import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_lime/beans/db_ocr_history_bean.dart';
import 'package:flutter_lime/pages/img_view_page.dart';
import 'package:flutter_lime/pages/ocr_result_page.dart';
import 'package:flutter_lime/utils/const.dart';
import 'package:flutter_lime/utils/dialog_utils.dart';

typedef ItemRemovedCallback = void Function(DBOcrHistoryBean bean);

//历史列表item
class HistoryItem extends StatelessWidget {
  final DBOcrHistoryBean bean;
  final BuildContext context;
  final ItemRemovedCallback onItemRemoved;

  HistoryItem({Key key, this.bean, this.context, this.onItemRemoved})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(bean.toString()),
      child: _generateItem(bean),
      onDismissed: (direction) => onItemRemoved(bean),
      background: Container(
        color: Colors.red,
        child: Center(
            child: Text(
          "删除",
          style: TextStyle(color: Colors.white),
        )),
      ),
      confirmDismiss: (DismissDirection direction) async {
        return await DialogUtils.showAlertDialog(context, Text("确定要删除此记录吗？"), [
          AlertDialogAction("删除", () => Navigator.pop(context, true)),
          AlertDialogAction("取消", () => Navigator.pop(context, false)),
        ]);
      },
    );
  }

  Widget _generateItem(DBOcrHistoryBean bean) {
    return InkWell(
      onTap: () => _onItemClick(),
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
                  placeholder: AssetImage("images/placeholder.png"),
                  image: FileImage(File(bean.imgPath + image_thumb_suffix)),
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
                    Container(child: Text(bean.result, maxLines: 2)),
                    Padding(padding: EdgeInsets.only(top: 16)),
                    Text(bean.dateTime,
                        style: TextStyle(fontSize: 12, color: Colors.grey))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onItemClick() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return OcrResultPage([bean]);
    }));
  }
}
