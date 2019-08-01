import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_lime/beans/db_ocr_history_bean.dart';

//图片预览界面
class ImageViewPage extends StatefulWidget {
  DBOcrHistoryBean _bean;
  ImageViewPage(this._bean);
  @override
  _ImageViewPageState createState() => _ImageViewPageState();
}

class _ImageViewPageState extends State<ImageViewPage> {
  @override
  Widget build(BuildContext context) {
    return new ConstrainedBox(
      constraints: BoxConstraints.expand(),
      child: new Image.file(
        File(widget._bean.imgPath),
        fit: BoxFit.fill,
      ),
    );
  }
}
