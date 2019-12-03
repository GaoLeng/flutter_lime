import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_lime/beans/db_ocr_history_bean.dart';
import 'package:flutter_lime/db/database_helper.dart';
import 'package:flutter_lime/utils/const.dart';
import 'package:flutter_lime/utils/log_utils.dart';
import 'package:flutter_lime/widgets/history_item.dart';
import 'package:flutter_lime/widgets/status_view.dart';

//历史识别页面
class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<DBOcrHistoryBean> histories;
  EasyRefreshController _refreshController;
  bool _firstRefresh = true;
  Status status = Status.LOADING;

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
    return StatusView(
      status,
      generateContent: _generateContent,
      reload: queryHistory,
    );
  }

  Widget _generateContent() {
    return EasyRefresh(
      header: _generateRefreshHeader(),
      footer: _generateRefreshFooter(),
      controller: _refreshController,
      onRefresh: _onRefresh,
      child: ListView.separated(
        itemCount: histories == null ? 0 : histories.length,
        itemBuilder: ((context, index) {
          return HistoryItem(
            bean: histories[index],
            context: context,
            onItemRemoved: (bean) {
              DataBaseHelper.getInstance().deleteOcrHistoryById(bean.id);
              histories.remove(bean);
              _calcStatus();
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

  void queryHistory() {
    DataBaseHelper.getInstance().queryOcrHistory(null).then((value) {
      LogUtils.i("queryHistory: $value");
      _refreshController.resetLoadState();
      _refreshController.finishRefresh(success: true);
      histories = value;

      _calcStatus();

      _firstRefresh = false;
    });
  }

  _calcStatus() {
    if (histories == null || histories.length == 0) {
      status = Status.EMPTY;
    } else {
      status = Status.NORMAL;
    }

    setState(() {});
  }

  Future<void> _onRefresh() async {
    LogUtils.i("_onRefresh: ");

    queryHistory();
  }
}
