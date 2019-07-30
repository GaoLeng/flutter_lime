import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lime/beans/trans_result_bean.dart';
import 'package:flutter_lime/utils/const.dart';
import 'package:flutter_lime/utils/http_utils.dart';
import 'package:flutter_lime/utils/log_utils.dart';
import 'package:flutter_lime/utils/utils.dart';
import 'package:crypto/crypto.dart';

class TranslatePage extends StatefulWidget {
  String _text;

  TranslatePage(this._text);

  @override
  _TranslatePageState createState() => _TranslatePageState();
}

class _TranslatePageState extends State<TranslatePage> {
  TextEditingController _editingController;

  @override
  void initState() {
    super.initState();
    _editingController = TextEditingController(text: widget._text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("翻译")),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              DropdownButton(
                  items: generateLanguageItems(), onChanged: (value) {}),
              IconButton(
                icon: Icon(Icons.cached),
              ),
              DropdownButton(
                  items: generateLanguageItems(), onChanged: (value) {})
            ],
          ),
          Expanded(
            flex: 1,
            child: TextField(controller: _editingController),
          ),
          Expanded(
            flex: 1,
            child: TextField(controller: _editingController),
          ),
          OutlineButton(
            onPressed: translate,
            child: Text("翻译"),
          )
        ],
      ),
    );
  }

  List<DropdownMenuItem> generateLanguageItems() {
    return [
      DropdownMenuItem(child: Text("中文")),
      DropdownMenuItem(child: Text("中文")),
      DropdownMenuItem(child: Text("中文")),
      DropdownMenuItem(child: Text("中文"))
    ];
  }

  void translate() {
    int currTime = Utils.getTimestamp() ~/ 1000;
    LogUtils.i("currTime: $currTime");
    HttpUtils.getInstance()
        .post(youdao_translate,
            data: {
              "q": _editingController.text,
              "from": "auto",
              "to": "auto",
              "appKey": youdao_app_key,
              "salt": currTime,
              "sign": _getYouDaoSign(
                  "$youdao_app_key${_getInputText()}$currTime$currTime$youdao_app_secret"),
              "ext": "mp3",
              "voice": "0",
              "signType": "v3",
              "curtime": currTime,
            },
            options: Options(
                contentType:
                    ContentType.parse("application/x-www-form-urlencoded")))
        .then((value) {
      LogUtils.i("youdao result: $value");
      TransResultBean bean =
          TransResultBean.fromDb(jsonDecode(value.toString()));
      if (bean.errorCode != "0") {
        Utils.showMsg("翻译失败，错误码： ${bean.errorCode}");
        return;
      }
      Utils.showMsg("翻译结果: ${bean.translation.toString()}");
    });
  }

  //根据有道要求生成签名信息
  String _getYouDaoSign(String text) {
    return sha256.convert(utf8.encode(text)).toString();
  }

  //根据有道要求截取字符串
  String _getInputText() {
    var text = _editingController.text;
    var len = text.length;
    return len <= 20
        ? text
        : (text.substring(0, 10) +
            len.toString() +
            text.substring(len - 10, len));
  }
}
