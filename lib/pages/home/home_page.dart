import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_lime/beans/image_file_bean.dart';
import 'package:flutter_lime/pages/ocr_page.dart';
import 'package:flutter_lime/utils/log_utils.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:storage_path/storage_path.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: OutlineButton(
        onPressed: _onPickClicked,
        child: Text("选择照片"),
      ),
    );
  }

  void _onPickClicked() {
    ImagePicker.pickImage(source: ImageSource.gallery).then((value) {
      if (value == null) return;
      LogUtils.i("_onPickClicked path: $value");
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return OcrPage(value.path);
      }));
    });
  }
//  @override
//  Widget build(BuildContext context) {
//    return FutureBuilder(
////      future: StoragePath.imagesPath,
//      builder: (BuildContext context, AsyncSnapshot snapshot) {
//        if (snapshot.hasData) {
//          List<dynamic> list = jsonDecode(snapshot.data);
//
//          return Container(
//            child: GridView.builder(
//              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                crossAxisCount: 2,
//              ),
//              itemCount: list.length,
//              itemBuilder: (BuildContext context, int index) {
//                ImageFileBean imageModel = ImageFileBean.fromJson(list[index]);
//                return Container(
//                  child: Stack(
//                    alignment: Alignment.bottomCenter,
//                    children: <Widget>[
//                      FadeInImage(
//                        image: FileImage(
//                          File(imageModel.files[0]),
//                        ),
//                        placeholder: AssetImage("images/placeholder.png"),
//                        fit: BoxFit.cover,
//                        width: double.infinity,
//                        height: double.infinity,
//                      ),
//                      Container(
//                        color: Colors.black.withOpacity(0.7),
//                        height: 30,
//                        width: double.infinity,
//                        child: Center(
//                          child: Text(
//                            imageModel.folderName,
//                            maxLines: 1,
//                            overflow: TextOverflow.ellipsis,
//                            style: TextStyle(
//                                color: Colors.white,
//                                fontSize: 16,
//                                fontFamily: 'Regular'),
//                          ),
//                        ),
//                      )
//                    ],
//                  ),
//                );
//              },
//            ),
//          );
//        } else {
//          return Container();
//        }
//      },
//    );
//}
}
