//通用ocr识别结果实体
import 'dart:convert';

import 'package:flutter/material.dart';

class OcrResultBean {
  String words;
  VertexesOffsetBean vertexes_location;
  Probability probability;

  OcrResultBean({this.words, this.vertexes_location, this.probability});

  factory OcrResultBean.fromJson(Map<String, dynamic> map) {
    return OcrResultBean(
      words: map["words"],
      vertexes_location: VertexesOffsetBean.fromJson(map["vertexes_location"]),
      probability: Probability.fromJson(map["probability"]),
    );
  }

  factory OcrResultBean.clone(OcrResultBean bean) {
    return OcrResultBean(
        words: bean.words.toString(),
        vertexes_location: VertexesOffsetBean.clone(bean.vertexes_location),
        probability: Probability.clone(bean.probability));
  }
}

//可信度实体
class Probability {
  double variance;
  double average;
  double min;

  Probability({this.variance, this.average, this.min});

  factory Probability.fromJson(Map<String, dynamic> map) {
    return Probability(
        variance: map["variance"], average: map["average"], min: map["min"]);
  }

  factory Probability.clone(Probability bean) {
    return Probability(
        variance: bean.variance, average: bean.average, min: bean.min);
  }
}

//图片文字定位实体
class VertexesOffsetBean {
  Offset topLeft;
  Offset topRight;
  Offset bottomRight;
  Offset bottomLeft;

  VertexesOffsetBean(
      {this.topLeft, this.topRight, this.bottomRight, this.bottomLeft});

  factory VertexesOffsetBean.fromJson(List list) {
    json2Offset(Map<String, dynamic> map) {
      var x = map["x"].toDouble();
      var y = map["y"].toDouble();
      return Offset(x, y);
    }

    if (list.length != 4) return null;
    return VertexesOffsetBean(
      topLeft: json2Offset(list[0]),
      topRight: json2Offset(list[1]),
      bottomRight: json2Offset(list[2]),
      bottomLeft: json2Offset(list[3]),
    );
  }

  factory VertexesOffsetBean.clone(VertexesOffsetBean bean) {
    return VertexesOffsetBean(
        topRight: Offset(bean.topRight.dx, bean.topRight.dy),
        topLeft: Offset(bean.topLeft.dx, bean.topLeft.dy),
        bottomLeft: Offset(bean.bottomLeft.dx, bean.bottomLeft.dy),
        bottomRight: Offset(bean.bottomRight.dx, bean.bottomRight.dy));
  }

  @override
  String toString() {
    return "{topLeft:$topLeft, topRight:$topRight, bottomRight:$bottomRight, bottomLeft:$bottomLeft}";
  }
}
