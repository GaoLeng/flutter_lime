import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_drag_scale/flutter_drag_scale.dart';
import 'package:flutter_lime/beans/db_ocr_history_bean.dart';
import 'package:flutter_lime/beans/ocr_result_bean.dart';
import 'package:flutter_lime/utils/const.dart';
import 'package:flutter_lime/utils/image_utils.dart';
import 'package:flutter_lime/utils/log_utils.dart';
import 'package:flutter_lime/widgets/painter.dart';
import 'dart:math' as math;

//图片查看器
class ImageView extends StatefulWidget {
  DBOcrHistoryBean _bean;

  ImageView(this._bean);

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  var _size;
  var _scale;

  @override
  Widget build(BuildContext context) {
    var imgFile = File(widget._bean.imgPath);
    return Stack(
      children: <Widget>[
        Image.file(imgFile),
        _generateLineRect(imgFile),
      ],
    );
  }

  _generateLineRect(File imgFile) {
    if (_size == null) {
      getRectSize(imgFile);
      return Container(width: 0, height: 0);
    }
    return CustomPaint(
      size: _size,
      painter: Painter(widget._bean.resultBeans, _scale),
    );
  }

  getRectSize(File imgFile) async {
    ImageUtils.getImagePropertiesNative(imgFile.path).then((size) {
      LogUtils.i("getImagePropertiesNative size: $size");
      LogUtils.i(
          "getImagePropertiesNative widget._bean.sizeForOcr: ${widget._bean.widthForOcr},${widget._bean.heightForOcr}");
      //计算出ocr识别时的缩放比率，然后根据比率算出ocr的图片尺寸
      var ocrScale = calcScale(
          srcWidth: size.width,
          srcHeight: size.height,
          minWidth: widget._bean.widthForOcr.toDouble(),
          minHeight: widget._bean.heightForOcr.toDouble());
      var resultSize = Size(size.width / ocrScale, size.height / ocrScale);
      _scale = screenSize.width / resultSize.width;
      var scaleHeight = size.height * _scale;
//      LogUtils.i("getImagePropertiesNative scaleHeight: $scaleHeight");
      _size = Size(screenSize.width, scaleHeight);
      setState(() {});
    });
  }

  double calcScale({
    double srcWidth,
    double srcHeight,
    double minWidth,
    double minHeight,
  }) {
    var scaleW = srcWidth / minWidth;
    var scaleH = srcHeight / minHeight;

    var scale = math.max(1.0, math.min(scaleW, scaleH));

    return scale;
  }
}
