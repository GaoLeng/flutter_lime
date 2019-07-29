import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lime/beans/ocr_result_bean.dart';
import 'package:flutter_lime/utils/const.dart';
import 'package:flutter_lime/utils/http_utils.dart';
import 'dart:io';
import 'package:flutter_lime/utils/log_utils.dart';
import 'package:flutter_lime/utils/utils.dart';

import 'ocr_result_page.dart';

//OCR识别页面
class OcrPage extends StatefulWidget {
  String _imgPath;

  OcrPage(this._imgPath);

  @override
  _OcrPageState createState() => _OcrPageState();
}

class _OcrPageState extends State<OcrPage> {
  //当前旋转角度
  double _currRadians = 0;

  //0 90 180 270
  double _calcRadiansAfterRotate(double offset) {
    var result = _currRadians + offset;
    if (result < 0) {
      result += 360;
    } else if (result > 270) {
      result -= 360;
    }

    LogUtils.e("_calcRadiansAfterRotate: $result");
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(child: Image.file(File(widget._imgPath))),
          Container(
            padding: EdgeInsets.only(bottom: 32),
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                generateIconButtonWithExpanded(Icons.close, onCloseClicked),
                generateIconButtonWithExpanded(
                    Icons.rotate_left, onRotateLeftClick),
                generateIconButtonWithExpanded(
                    Icons.rotate_right, onRotateRightClick),
                generateIconButtonWithExpanded(Icons.done, onDoneClicked)
              ],
            ),
          )
        ],
      ),
    );
  }

  //生成底部按钮
  Widget generateIconButtonWithExpanded(IconData icon, VoidCallback function) {
    return Expanded(
        flex: 1,
        child: IconButton(
          onPressed: function,
          iconSize: 28,
          highlightColor: Colors.green,
          color: Colors.white,
          icon: Icon(icon),
        ));
  }

  void onCloseClicked() {
    Navigator.pop(context);
  }

  void onRotateLeftClick() {
    setState(() {
      _currRadians = _calcRadiansAfterRotate(-90);
    });
  }

  void onRotateRightClick() {
//    setState(() {
//      _currRadians = _calcRadiansAfterRotate(90);
//    });
  }

  void onDoneClicked() {
    ocr();
  }

  //识别
  Future ocr() async {
    if (HttpUtils.accessToken == null) {
      Utils.showMsg("no accessToken");
      return;
    }

    var response = await _ocrRequest();
    LogUtils.i("ocr result: $response");
    LogUtils.i("ocr result: ${HttpUtils.accessToken}");

    OcrResultBean ocrResultBean =
        OcrResultBean.fromJson(jsonDecode(response.toString()));
    if (ocrResultBean.error_code != 0) {
      Utils.showMsg("识别失败，${ocrResultBean.error_msg}");
      return;
    }
    StringBuffer buffer = StringBuffer();
    for (WordsResult words in ocrResultBean.words_result) {
      buffer.writeln(words.words);
    }

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return OcrResultPage(buffer.toString());
    }));
  }

  Future _ocrRequest() async {
    return await HttpUtils.getInstance().post(badiu_ocr_url_basic,
        data: {
          'access_token': HttpUtils.accessToken,
          'image': await img2Base64(widget._imgPath)
//          'url':
//              'https://cn.bing.com/th?id=OIP.eY74-PmsXafwG2VJ9Qv8qQHaHU&pid=Api&rs=1'
        },
        options: Options(
            contentType:
                ContentType.parse("application/x-www-form-urlencoded")));
  }

  Future img2Base64(String path) async {
    File file = new File(path);
    List<int> imageBytes = await file.readAsBytes();
    return base64Encode(imageBytes);
  }
}
