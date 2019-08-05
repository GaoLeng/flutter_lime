import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lime/beans/db_ocr_history_bean.dart';
import 'package:flutter_lime/pages/translate_page.dart';
import 'package:flutter_lime/utils/const.dart';
import 'package:flutter_lime/utils/tts_utils.dart';
import 'package:flutter_lime/utils/utils.dart';
import 'package:flutter_lime/widgets/image_view.dart';
import 'package:flutter_tts/flutter_tts.dart';

//OCR识别结果页
class OcrResultPage extends StatefulWidget {
  List<DBOcrHistoryBean> _beans;

  OcrResultPage(this._beans);

  @override
  _OcrResultPageState createState() => _OcrResultPageState();
}

class _OcrResultPageState extends State<OcrResultPage> {
  TextEditingController _controller;
  bool _isChecking = false; //是否正在校对

  @override
  void initState() {
    super.initState();
    var results = "";
    var list = widget._beans;
    list.forEach((bean) {
      results += bean.result;
      if (list.indexOf(bean) < list.length - 1) {
        results += "\n\n";
      }
    });
    _controller = TextEditingController(text: results);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
            appBar: AppBar(
              title: Text("识别结果"),
            ),
            body: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(8)),
                    keyboardType: TextInputType.text,
                    style: TextStyle(),
                    maxLines: null,
                    controller: _controller,
                  ),
                ),
                _generateCheckView(),
                SafeArea(
                    child: Row(
                      children: <Widget>[
                        Padding(padding: EdgeInsets.only(left: 4)),
                        generateIconButtonWithExpanded(
                            Icons.content_copy, "复制", _onCopyClicked),
                        generateIconButtonWithExpanded(
                            Icons.share, "分享", _onShareClicked),
                        generateIconButtonWithExpanded(
                            Icons.volume_up, "朗读", _onSpeakClicked),
                        generateIconButtonWithExpanded(
                            Icons.g_translate, "翻译", _onTranslateClicked),
                        generateIconButtonWithExpanded(
                            Icons.spellcheck, "校对", _onCheckClicked,
                            color: _isChecking
                                ? themeColors[currThemeColorIndex]
                                : null),
                        Padding(padding: EdgeInsets.only(left: 4)),
                      ],
                    ))
              ],
            )),
        onWillPop: onWillPop);
  }

  //生成底部按钮
  Widget generateIconButtonWithExpanded(IconData icon, String text,
      VoidCallback onTap,
      {VoidCallback onLongPress, color}) {
    if (color == null) color = Colors.grey[700];
    return Expanded(
        flex: 1,
        child: InkWell(
            onLongPress: onLongPress,
            onTap: onTap,
            child: Container(
              padding: EdgeInsets.only(top: 8, bottom: 8),
              child: Column(
                children: <Widget>[
                  Icon(
                    icon,
                    size: 20,
                    color: color,
                  ),
                  Text(
                    text,
                    style: TextStyle(fontSize: 12, color: color),
                  )
                ],
              ),
            )));
  }

  Widget _generateCheckView() {
    return _isChecking
        ? Expanded(
      flex: 1,
      child: ListView.builder(
        itemCount: widget._beans.length,
        itemBuilder: (context, index) {
          return ImageView(widget._beans[index]);
        },
      ),
    )
        : Divider(height: 1);
  }

  void _onCopyClicked() {
    Clipboard.setData(ClipboardData(text: _controller.text));
    showMsg("已复制到剪贴板");
  }

  void _onShareClicked() {
    shareText(_controller.text);
  }

  void _onSpeakClicked() {
    TTSUtils.getInstance().speak(_controller.text);
  }

  void _onTranslateClicked() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return TranslatePage(_controller.text);
    }));
  }

  void _onCheckClicked() {
    setState(() {
      _isChecking = !_isChecking;
    });
  }

  Future<bool> onWillPop() {
    var shouldPop;
    if (_isChecking) {
      _onCheckClicked();
      shouldPop = false;
    } else {
      shouldPop = true;
    }
    return Future.value(shouldPop);
  }
}
