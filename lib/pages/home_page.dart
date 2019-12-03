import 'package:flutter/material.dart';
import 'package:flutter_lime/pages/ocr_page.dart';
import 'package:flutter_lime/utils/const.dart';
import 'package:flutter_lime/utils/log_utils.dart';
import 'package:image_picker/image_picker.dart';

import 'home/search_page.dart';
//import 'package:storage_path/storage_path.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    LogUtils.i("rootDir: $rootDir");
    return Material(
        child: Column(
      children: <Widget>[
        OutlineButton(
          onPressed: _onPickClicked,
          child: Text("选择照片"),
        ),
        OutlineButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return SearchPage();
            }));
          },
          child: Text("搜索"),
        )
      ],
    ));
  }

  void _onPickClicked() {
//    MultiImagePicker.pickImages(maxImages: 20).then((imgs) {
//      LogUtils.i("_onPickClicked name: ${imgs[0].name}");
//    });
    ImagePicker.pickImage(source: ImageSource.gallery).then((value) {
      if (value == null) return;
      LogUtils.i("_onPickClicked path: $value");
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return OcrPage(value.path);
      }));
    });
  }
}
