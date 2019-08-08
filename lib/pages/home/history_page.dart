import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_lime/beans/db_ocr_history_bean.dart';
import 'package:flutter_lime/db/database_helper.dart';
import 'package:flutter_lime/pages/img_view_page.dart';
import 'package:flutter_lime/utils/const.dart';
import 'package:flutter_lime/utils/dialog_utils.dart';
import 'package:flutter_lime/utils/log_utils.dart';

import '../ocr_result_page.dart';

//历史识别页面
class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<DBOcrHistoryBean> histories;
  EasyRefreshController _refreshController;
  bool _firstRefresh = true;

  var refreshText = "下拉刷新";
  var refreshReadyText = "松开刷新";
  var refreshingText = "正在刷新...";
  var refreshedText = "刷新成功";
  var refreshFailedText = "刷新失败";
  var infoText = "更新于 %T";
  var infoColor = themeColors[currThemeColorIndex];

  var loadText = "上拉加载";
  var loadReadyText = "松开加载";
  var loadingText = "正在加载...";
  var loadedText = "加载成功";
  var loadFailedText = "加载失败";
  var noMoreText = "已经到底了";

  @override
  void initState() {
    super.initState();
    queryHistory();
    LogUtils.i("history page initState.");
    _refreshController = EasyRefreshController();
  }

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
//      emptyWidget: Text("暂无数据"),
//      firstRefresh: _firstRefresh,
      header: _generateRefreshHeader(),
      footer: _generateRefreshFooter(),
      controller: _refreshController,
      onRefresh: _onRefresh,
      child: ListView.separated(
        itemCount: histories == null ? 0 : histories.length,
        itemBuilder: ((context, index) {
          return Dismissible(
            key: Key(histories[index].toString()),
            child: _generateItem(histories[index], index),
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
              return await DialogUtils.showAlertDialog(
                  context, Text("确定要删除此记录吗？"), [
                AlertDialogAction("删除", () => Navigator.pop(context, true)),
                AlertDialogAction("取消", () => Navigator.pop(context, false)),
              ]);
            },
          );
        }),
        separatorBuilder: ((context, index) {
          return Divider(height: 1);
        }),
      ),
    );
  }

  _generateRefreshHeader() {
    return ClassicalHeader(
      enableHapticFeedback: false,
      refreshText: refreshText,
      refreshReadyText: refreshReadyText,
      refreshingText: refreshingText,
      refreshedText: refreshedText,
      refreshFailedText: refreshFailedText,
      noMoreText: noMoreText,
      infoText: infoText,
      infoColor: infoColor,
    );
  }

  _generateRefreshFooter() {
    return ClassicalFooter(
      enableHapticFeedback: false,
      loadText: loadText,
      loadReadyText: loadReadyText,
      loadingText: loadingText,
      loadedText: loadedText,
      loadFailedText: loadFailedText,
      noMoreText: noMoreText,
      infoText: infoText,
      infoColor: infoColor,
    );
  }

  Widget _generateItem(DBOcrHistoryBean bean, int index) {
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
    DataBaseHelper.getInstance().queryHistory().then((value) {
      LogUtils.i("queryHistory: $value");
      _firstRefresh = false;
      _refreshController.resetLoadState();
      _refreshController.finishRefresh(success: true);
      histories = List();
      value.forEach((row) {
        var bean = DBOcrHistoryBean.fromDb(row);
        histories.add(bean);
//        LogUtils.i("queryHistory: ${bean.imgPath}");
        // precacheImage(FileImage(File(bean.imgPath)), context);
      });
      if (histories.length == 0) return;
      setState(() {});
    });
  }

  Future<void> _onRefresh() async {
    LogUtils.i("_onRefresh: ");

    queryHistory();
  }
}
