import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lime/beans/db_ocr_history_bean.dart';
import 'package:flutter_lime/beans/ocr_result_bean.dart';
import 'package:flutter_lime/db/database_helper.dart';
import 'package:flutter_lime/utils/const.dart';
import 'package:flutter_lime/utils/http_utils.dart';
import 'dart:io';
import 'package:flutter_lime/utils/log_utils.dart';
import 'package:flutter_lime/utils/utils.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'ocr_result_page.dart';
import 'package:image/image.dart' as ImageUtils;

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

    showLoading();
    var response = await _ocrRequest();
    LogUtils.i("ocr result: $response");
    LogUtils.i("ocr result: ${HttpUtils.accessToken}");

    OcrResultBean ocrResultBean =
        OcrResultBean.fromJson(jsonDecode(response.toString()));
    if (ocrResultBean.error_code != 0) {
      dismiss();
      Utils.showMsg("识别失败，${ocrResultBean.error_msg}");
      return;
    }
    StringBuffer buffer = StringBuffer();
    for (WordsResult words in ocrResultBean.words_result) {
      buffer.writeln(words.words);
    }
    dismiss();

    var bean = DBOcrHistoryBean(
        imgPath: widget._imgPath,
        result: buffer.toString(),
        dateTime: Utils.getDateTime());
    storeOcrResult(bean);

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return OcrResultPage(bean);
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
    ImageUtils.Image image =
        ImageUtils.decodeImage(File(path).readAsBytesSync());
    ImageUtils.Image thumbnail = ImageUtils.copyResize(image, width: 400);
    List<int> imageBytes = ImageUtils.encodePng(thumbnail);
    LogUtils.i(
        "image before length: ${image.length}, after length: ${thumbnail.length}");

    // File file = new File(path);
    // List<int> imageBytes = await file.readAsBytes();
    return base64Encode(imageBytes);
  }

  Future storeOcrResult(DBOcrHistoryBean bean) async {
    DataBaseHelper.getInstance().getDatabase().insert(
        DataBaseHelper.table_ocr_history, {
      IMG_PATH: bean.imgPath,
      RESULT: bean.result,
      DATE_TIME: bean.dateTime
    });
  }

  void showLoading() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
              child: Container(
            padding: EdgeInsets.only(left: 20),
            width: 180,
            height: 80,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SpinKitCircle(
                  color: Colors.grey,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                ),
                Text(
                  "加载中...",
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ));
        });
  }

  void dismiss() {
    Navigator.pop(context);
  }
}
