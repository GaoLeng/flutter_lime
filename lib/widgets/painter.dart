import 'package:flutter/material.dart';
import 'package:flutter_lime/beans/ocr_result_bean.dart';
import 'package:flutter_lime/utils/const.dart';
import 'package:flutter_lime/utils/log_utils.dart';

class Painter extends CustomPainter {
  Paint _paint;
  List<OcrResultBean> _ocrResultBean;
  double _scale = 1.0;

  Painter(ocrResultBean, this._scale) {
    _paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 1;

    _ocrResultBean = [];
    ocrResultBean.forEach((originOcrResult) {
      var ocrResult = OcrResultBean.clone(originOcrResult);
      ocrResult.vertexes_location = convertOffsets(ocrResult.vertexes_location);
      _ocrResultBean.add(ocrResult);
    });
    LogUtils.i("Painter: init");
  }

  @override
  void paint(Canvas canvas, Size size) {
    _ocrResultBean.forEach((ocrResult) {
      setColorByProbAvg(ocrResult.probability.average);
      var offsets = ocrResult.vertexes_location;
      LogUtils.i("paint: ${ocrResult.vertexes_location}");

      canvas.drawLine(offsets.topLeft, offsets.topRight, _paint);
      canvas.drawLine(offsets.topRight, offsets.bottomRight, _paint);
      canvas.drawLine(offsets.bottomRight, offsets.bottomLeft, _paint);
      canvas.drawLine(offsets.bottomLeft, offsets.topLeft, _paint);
    });
  }

  //根据_scale来计算新的offset
  VertexesOffsetBean convertOffsets(VertexesOffsetBean offsets) {
    return VertexesOffsetBean(
      topLeft: convertOffset(offsets.topLeft),
      topRight: convertOffset(offsets.topRight),
      bottomLeft: convertOffset(offsets.bottomLeft),
      bottomRight: convertOffset(offsets.bottomRight),
    );
  }

  Offset convertOffset(Offset offset) {
    return Offset(offset.dx * _scale, offset.dy * _scale);
  }

  //根据 置信度值 来设置画笔颜色
  setColorByProbAvg(double average) {
    var colors = themeColors[currThemeColorIndex];
    if (average >= 0.98) {
      _paint.color = colors[400];
    } else if (average >= 0.96) {
      _paint.color = colors[500];
    } else if (average >= 0.94) {
      _paint.color = colors[600];
    } else if (average >= 0.92) {
      _paint.color = colors[700];
    } else if (average >= 0.9) {
      _paint.color = colors[800];
    } else {
      _paint.color = colors[900];
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return null;
  }
}
