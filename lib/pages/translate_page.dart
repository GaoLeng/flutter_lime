import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lime/beans/trans_result_bean.dart';
import 'package:flutter_lime/utils/const.dart';
import 'package:flutter_lime/utils/http_utils.dart';
import 'package:flutter_lime/utils/log_utils.dart';
import 'package:flutter_lime/utils/utils.dart';
import 'package:flutter_lime/widgets/my_icons.dart';

//翻译页面
class TranslatePage extends StatefulWidget {
  final String _text;

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

  //是否已经点击过翻译按钮，判断是否显示译文区域
  bool _hasTranslated = false;

  //是否处于全屏模式
  bool _isFullscreen = false;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: widget._text);
    _translatedEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    var body = Column(children: <Widget>[]);

    if (!_isFullscreen) {
      //非全屏状态下，也就是正常情况下
      body.children.add(Row(
        children: <Widget>[
          Expanded(child: Center(child: _generateDropDownBtn(true))),
          IconButton(
            icon: Icon(MyIcons.exchange, color: Colors.grey[700]),
            onPressed: () {},
          ),
          Expanded(child: Center(child: _generateDropDownBtn(false))),
        ],
      ));
      body.children.add(Divider(height: 1));
      body.children
          .add(Expanded(flex: 1, child: _generateToBeTranslatedWidget()));
    }
    if (_hasTranslated) {
      body.children.add(Expanded(flex: 2, child: _generateTranslatedWidget()));
    } else {
      body.children.add(Expanded(flex: 1, child: _generateTranslatedWidget()));
    }

    return Scaffold(appBar: AppBar(title: Text("翻译")), body: body);
  }

  //生成翻译语言选择按钮
  Widget _generateDropDownBtn(bool isTransFrom) {
    return DropdownButton(
        underline: Container(),
        isExpanded: false,
        style: TextStyle(fontSize: 16, color: Colors.grey[800]),
        items: _generateLanguageItems(),
        value: isTransFrom ? transFrom : transTo,
        onChanged: (value) {
          if (isTransFrom)
            transFrom = value;
          else
            transTo = value;
          setState(() {});
          LogUtils.i("translate value: $value");
        });
  }

  //生成语言选项
  List<DropdownMenuItem> _generateLanguageItems() {
    List<DropdownMenuItem> items = List();
    _languageItemMaps.forEach((key, value) {
      items.add(DropdownMenuItem(child: Text(key), value: value));
    });
    return items;
  }

  //生成待翻译区域
  Widget _generateToBeTranslatedWidget() {
    return Stack(
      children: <Widget>[
        TextField(
          controller: _textEditingController,
          maxLines: null,
          scrollPadding: EdgeInsets.all(0),
          decoration: InputDecoration(
              hintText: "请输入文本",
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(8)),
        ),
        Positioned(
          right: 6,
          bottom: 6,
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: _translate,
            child: Container(
              margin: EdgeInsets.all(12),
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: themeColors[currThemeColorIndex],
              ),
              child: Icon(Icons.arrow_forward, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  //生成译文区域
  Widget _generateTranslatedWidget() {
    //译文头部
    final translatedHead = Row(
      children: <Widget>[
        Padding(padding: EdgeInsets.only(left: 8)),
        Expanded(
            flex: 1,
            child: Text("译文", style: TextStyle(color: Colors.grey[600]))),
        _generateTranslatedOptions(
            _isFullscreen ? MyIcons.fullscreen_exit : MyIcons.fullscreen,
            _onFullscreenClicked),
        Padding(padding: EdgeInsets.only(left: 8)),
        _generateTranslatedOptions(Icons.content_copy, _onCopyClicked),
        Padding(padding: EdgeInsets.only(left: 8)),
        _generateTranslatedOptions(Icons.share, _onShareClicked),
      ],
    );

    //译文区域
    final translatedBody = Expanded(
        child: TextField(
      controller: _translatedEditingController,
      maxLines: null,
      decoration: InputDecoration(
          border: InputBorder.none, contentPadding: EdgeInsets.all(8)),
    ));
    return Container(
        color: Colors.grey[300],
        padding: EdgeInsets.all(8),
        child: _hasTranslated
            ? Material(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    children: <Widget>[translatedHead, translatedBody],
                  ),
                ),
              )
            : null);
  }

  //生成译文区域的选项按钮
  Widget _generateTranslatedOptions(icon, onPressed) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(8),
        child: Icon(icon, size: 22, color: Colors.grey[700]),
      ),
    );
  }

  _translate() {
//    _translatedEditingController.text = _textEditingController.text;
//    setState(() {
//      _hasTranslated = true;
//    });
//    return;
    int currTime = getTimestamp() ~/ 1000;
    LogUtils.i("currTime: $currTime");
    HttpUtils.translateByYouDao(_textEditingController.text, "auto", "auto")
        .then((value) {
      LogUtils.i("youdao result: $value");
      TransResultBean bean =
          TransResultBean.fromDb(jsonDecode(value.toString()));
      if (bean.errorCode != "0") {
        showMsg("翻译失败，错误码： ${bean.errorCode}");
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
      setState(() {
        _hasTranslated = true;
      });
    });
  }

  _onFullscreenClicked() {
    setState(() {
      _isFullscreen = !_isFullscreen;
    });
  }

  _onCopyClicked() {
    Clipboard.setData(ClipboardData(text: _translatedEditingController.text));
    showMsg("已复制到剪贴板");
  }

  _onShareClicked() => shareText(_translatedEditingController.text);
}
