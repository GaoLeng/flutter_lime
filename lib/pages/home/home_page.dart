import 'package:flutter/material.dart';
import 'package:flutter_lime/pages/ocr_page.dart';
import 'package:image_picker/image_picker.dart';

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
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return OcrPage(value.path);
      }));
    });
  }
}
