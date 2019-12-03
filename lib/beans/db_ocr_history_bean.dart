//OCR_HISTORY 表model
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_lime/utils/const.dart';
import 'package:flutter_lime/utils/file_utils.dart';
import 'package:flutter_lime/utils/log_utils.dart';

import 'baidu_ocr_result_bean.dart';
import 'ocr_result_bean.dart';

class DBOcrHistoryBean {
  int id;
  String imgPath;
  String result;
  String jsonResult;
  int jsonType; //json类型，1百度 2阿里 3腾讯
  String dateTime;
  int widthForOcr; //ocr识别时指定图片尺寸，下同
  int heightForOcr;
  List<OcrResultBean> _resultBeans;

  List<OcrResultBean> get resultBeans {
    LogUtils.i("jsonType: $jsonType, jsonResult:$jsonResult");
    if (_resultBeans == null) {
      _resultBeans = [];
      switch (jsonType) {
        case 1:
          _resultBeans =
              BaiDuOcrResultBean.fromJson(jsonDecode(jsonResult)).wordsResult;
          break;
        case 2:
          break;
        case 3:
          break;
      }
    }
    return _resultBeans;
  }

  DBOcrHistoryBean(
      {this.id,
      this.imgPath,
      this.result,
      this.jsonResult,
      this.jsonType,
      this.widthForOcr,
      this.heightForOcr,
      this.dateTime});

  factory DBOcrHistoryBean.fromDb(Map<String, dynamic> data) {
    var sizeForOcr = data[SIZE_FOR_OCR]?.toString()?.split(",");
    sizeForOcr ??= ["0", "0"];

    return DBOcrHistoryBean(
      id: data[ID],
      imgPath: convertPath(false, data[IMG_PATH]),
      jsonResult: data[JSON_RESULT],
      result: data[RESULT],
      jsonType: data[JSON_TYPE],
      widthForOcr: int.parse(sizeForOcr[0]),
      heightForOcr: int.parse(sizeForOcr[1]),
      dateTime: data[DATE_TIME],
    );
  }
}
