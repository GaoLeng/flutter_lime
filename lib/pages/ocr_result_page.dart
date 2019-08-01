import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lime/beans/db_ocr_history_bean.dart';
import 'package:flutter_lime/pages/translate_page.dart';
import 'package:flutter_lime/utils/const.dart';
import 'package:flutter_lime/utils/utils.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

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
    widget._beans.forEach((bean) {
      results += bean.result + "\n\n";
    });
    _controller = TextEditingController(text: results);
    BackButtonInterceptor.add(onBackInterceptor);
  }

  @override
  void dispose() {
    super.dispose();
    BackButtonInterceptor.remove(onBackInterceptor);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    Icons.content_copy, "复制", _onCopyClicked,
                    onLongPress: _onShareClicked),
                generateIconButtonWithExpanded(
                    Icons.headset, "朗读", _onSpeakClicked),
                generateIconButtonWithExpanded(
                    Icons.print, "导出", _onExportClicked),
                generateIconButtonWithExpanded(
                    Icons.g_translate, "翻译", _onTranslateClicked),
                generateIconButtonWithExpanded(
                    Icons.spellcheck, "校对", _onCheckClicked,
                    color: _isChecking
                        ? materialColors[currThemeColorIndex]
                        : null),
                Padding(padding: EdgeInsets.only(left: 4)),
              ],
            ))
          ],
        ));
  }

  //生成底部按钮
  Widget generateIconButtonWithExpanded(
      IconData icon, String text, VoidCallback onTap,
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
                return Image(
                  image: FileImage(File(widget._beans[index].imgPath)),
                );
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
    // _onCopyClicked();
    //TODO 分享文本
    //  weixin://
    //  mqqzone://
    shareText(_controller.text);
    // const shareScheme = 'mqqzone://';
    // if (await canLaunch(shareScheme)) {
    //   await launch(shareScheme);
    // } else {
    //   showMsg("Could not launch $shareScheme");
    // }
  }

  void _onSpeakClicked() {}

  void _onExportClicked() {}

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

  //拦截返回按钮 true为拦截
  bool onBackInterceptor(bool stopDefaultButtonEvent) {
    if (_isChecking) {
      _onCheckClicked();
      return true;
    }
    return false;
  }
}
