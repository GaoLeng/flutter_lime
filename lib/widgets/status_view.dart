import 'package:flutter/material.dart';
import 'package:flutter_lime/utils/const.dart';
import 'package:flutter_lime/utils/log_utils.dart';

typedef GenerateChild = Widget Function();
typedef ReloadFunction = void Function();

//状态页面，包括加载中、加载失败、空数据
class StatusView extends StatelessWidget {
  final Status _status;
  final GenerateChild generateContent;
  final ReloadFunction reload;

  StatusView(this._status, {this.generateContent, this.reload});

  @override
  Widget build(BuildContext context) {
    return Container(child: _getChild());
  }

  Widget _getChild() {
    LogUtils.i("_getChild _status: $_status");
    var child;
    switch (_status) {
      case Status.NORMAL:
        child = generateContent();
        break;
      case Status.EMPTY:
        child = _generateEmpty();
        break;
      case Status.LOADING:
        child = _generateLoading();
        break;
      case Status.ERROR:
        child = _generateError();
        break;
    }
    if (_status != Status.NORMAL) {
      return Center(
          heightFactor: 3,
          child: GestureDetector(
            child: child,
            onTap: reload,
          ));
    }
    return child;
  }

  //空页
  _generateEmpty() {
    return _generateStatus("images/status_empty.png", "暂无数据");
  }

  //错误页
  _generateError() {
    return _generateStatus("images/status_errot.png", "加载失败，点击重试");
  }

  _generateStatus(img, text) {
    return Container(
      child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Image.asset(img,width: 120,),
        SizedBox(height: 16),
        Text(text, style: TextStyle(color: Colors.grey)),
      ]),
    );
  }

  //加载页
  _generateLoading() {
    return CircularProgressIndicator();
  }
}

enum Status { NORMAL, EMPTY, LOADING, ERROR }
