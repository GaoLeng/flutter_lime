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

//翻译页面
class TranslatePage extends StatefulWidget {
  String _text;

  TranslatePage(this._text);

  @override
  _TranslatePageState createState() => _TranslatePageState();
}

class _TranslatePageState extends State<TranslatePage> {
  TextEditingController _textEditingController;
  TextEditingController _translatedEditingController;
  static const Map<String, String> _languageItemMaps = {
    "检测语言": "检测语言",
    "中文": "中文",
    "英语": "英语",
    "日语": "日语"
  };
  String transFrom = _languageItemMaps["检测语言"];
  String transTo = _languageItemMaps["检测语言"];

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: widget._text);
    _translatedEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("翻译")),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(padding: EdgeInsets.only(left: 8)),
              generateDropDownBtnWithExpanded(true),
              Padding(padding: EdgeInsets.only(left: 8)),
              IconButton(
                icon: Icon(Icons.cached),
                onPressed: () {},
              ),
              Padding(padding: EdgeInsets.only(left: 8)),
              generateDropDownBtnWithExpanded(false),
              Padding(padding: EdgeInsets.only(left: 8)),
            ],
          ),
          Expanded(
            flex: 1,
            child: TextField(
              controller: _textEditingController,
              maxLines: null,
              decoration: InputDecoration(
                  hintText: "请输入文本",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(8)),
            ),
          ),
          Divider(height: 1),
          Expanded(
            flex: 1,
            child: TextField(
              controller: _translatedEditingController,
              maxLines: null,
              decoration: InputDecoration(
                  border: InputBorder.none, contentPadding: EdgeInsets.all(8)),
            ),
          ),
          Row(
            children: <Widget>[
              Padding(padding: EdgeInsets.only(left: 8)),
              Expanded(
                  child: OutlineButton(
                      onPressed: translate,
                      color: Colors.green,
                      hoverColor: Colors.green,
                      child: Text("翻译", style: TextStyle(fontSize: 18)),
                      padding: EdgeInsets.all(12))),
              Padding(padding: EdgeInsets.only(left: 8)),
            ],
          ),
          Padding(padding: EdgeInsets.only(bottom: 16))
        ],
      ),
    );
  }

  Widget generateDropDownBtnWithExpanded(bool isTransFrom) {
    return Expanded(
      child: DropdownButton(
          isExpanded: true,
          style: TextStyle(fontSize: 18, color: Colors.grey[800]),
          items: generateLanguageItems(),
          value: isTransFrom ? transFrom : transTo,
          onChanged: (value) {
            if (isTransFrom)
              transFrom = value;
            else
              transTo = value;
            setState(() {});
            LogUtils.i("translate value: $value");
          }),
    );
  }

  List<DropdownMenuItem> generateLanguageItems() {
    List<DropdownMenuItem> items = List();
    _languageItemMaps.forEach((key, value) {
      items.add(DropdownMenuItem(child: Text(key), value: value));
    });
    return items;
  }

  void translate() {
    int currTime = Utils.getTimestamp() ~/ 1000;
    LogUtils.i("currTime: $currTime");
    HttpUtils.getInstance()
        .post(youdao_translate,
            data: {
              "q": _textEditingController.text,
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

      StringBuffer buffer = StringBuffer();
      bean.translation.forEach((item) {
        buffer.writeln(item);
      });
      String result = buffer.toString();
      if (result.endsWith("\n")) {
        result = result.substring(0, result.length - 1);
      }
      _translatedEditingController.text = result;
    });
  }

  //根据有道要求生成签名信息
  String _getYouDaoSign(String text) {
    return sha256.convert(utf8.encode(text)).toString();
  }

  //根据有道要求截取字符串
  String _getInputText() {
    var text = _textEditingController.text;
    var len = text.length;
    return len <= 20
        ? text
        : (text.substring(0, 10) +
            len.toString() +
            text.substring(len - 10, len));
  }
}
