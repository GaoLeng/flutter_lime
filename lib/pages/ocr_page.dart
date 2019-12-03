import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lime/beans/db_ocr_history_bean.dart';
import 'package:flutter_lime/beans/baidu_ocr_result_bean.dart';
import 'package:flutter_lime/beans/ocr_result_bean.dart';
import 'package:flutter_lime/db/database_helper.dart';
import 'package:flutter_lime/utils/const.dart';
import 'package:flutter_lime/utils/dialog_utils.dart';
import 'package:flutter_lime/utils/file_utils.dart';
import 'package:flutter_lime/utils/http_utils.dart';
import 'package:flutter_lime/utils/image_utils.dart';
import 'dart:io';
import 'package:flutter_lime/utils/log_utils.dart';
import 'package:flutter_lime/utils/utils.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
          highlightColor: themeColors[currThemeColorIndex],
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

  Future onDoneClicked() async {
    if (HttpUtils.accessToken == null) {
      showMsg("no accessToken");
      return;
    }

    DialogUtils.showLoading(context, content: "正在识别...");
    ocr();
  }

  //识别
  void ocr() {
    final widthForOcr = sizeForOcr.width.toInt();
    final heightForOcr = sizeForOcr.height.toInt();
    HttpUtils.ocrByBaidu(widget._imgPath, widthForOcr, heightForOcr)
        .then((response) {
      LogUtils.i("ocr result: $response");
      LogUtils.i("ocr result: ${HttpUtils.accessToken}");
      var resStr = response.toString();
      BaiDuOcrResultBean ocrResultBean =
          BaiDuOcrResultBean.fromJson(jsonDecode(resStr));
      if (ocrResultBean.errorCode != 0) {
        DialogUtils.dismiss(context);
        showMsg("识别失败，${ocrResultBean.errorMsg}");
        return;
      }
      StringBuffer buffer = StringBuffer();
      for (OcrResultBean words in ocrResultBean.wordsResult) {
        buffer.writeln(words.words);
      }
      DialogUtils.dismiss(context);

      var bean = DBOcrHistoryBean(
          imgPath: widget._imgPath,
          jsonResult: resStr,
          result: buffer.toString(),
          jsonType: 1,
          widthForOcr: widthForOcr,
          heightForOcr: heightForOcr,
          dateTime: getDateTime());

      saveOcrResult(bean);

      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return OcrResultPage([bean]);
      }));
    });
  }

  //存储结果（包括图片、识别结果）
  Future saveOcrResult(DBOcrHistoryBean bean) async {
    var fileBytes = File(bean.imgPath).readAsBytesSync();
    //如果是ios的tmp文件夹，则要复制图片到rootDir下
    if (isIOSTmpDir(bean.imgPath)) {
      String path = '$rootDir/${getTimestamp()}.jpg';
      await saveFile(path, fileBytes);
      bean.imgPath = path;
    }

    //存储缩略图
    Future.delayed(Duration(seconds: 1), () async {
      ImageUtils.compressImage(bean.imgPath, minWidth: 150).then((file) {
        saveFile("${bean.imgPath}$image_thumb_suffix", file);
      });
    });

    DataBaseHelper.getInstance().insertHistory(bean);
  }
}
