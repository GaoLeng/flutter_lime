import 'package:flutter/material.dart';

//状态页面，包括加载中、加载失败、空数据
class StatusView extends StatelessWidget {
  final Status _status;

  StatusView(this._status);

  @override
  Widget build(BuildContext context) {
    return Container(child: Center(child: _getChild()));
  }

  Widget _getChild() {
    switch (_status) {
      case Status.EMPTY:
        return _generateEmpty();
      case Status.LOADING:
        return _generateLoading();
      case Status.ERROR:
        return _generateError();
    }
    return Container();
  }

  //空页
  _generateEmpty() {
    return Text("暂无数据");
  }

  //错误页
  _generateError() {
    return Text("加载失败");
  }

  //加载页
  _generateLoading() {
    return CircularProgressIndicator();
  }
}

enum Status { EMPTY, LOADING, ERROR }
