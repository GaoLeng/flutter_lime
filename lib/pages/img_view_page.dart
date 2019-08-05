import 'package:flutter/material.dart';
import 'package:flutter_drag_scale/flutter_drag_scale.dart';
import 'package:flutter_lime/beans/db_ocr_history_bean.dart';
import 'package:flutter_lime/widgets/image_view.dart';

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
    return Material(
        color: Colors.black,
        child: DragScaleContainer(
          doubleTapStillScale: false,
          child: Center(
            child: ImageView(widget._bean),
          ),
        ));
  }
}
