import 'package:flutter/material.dart';

//OCR识别结果页
class OcrResultPage extends StatefulWidget {
  String _result;

  OcrResultPage(this._result);

  @override
  _OcrResultPageState createState() => _OcrResultPageState();
}

class _OcrResultPageState extends State<OcrResultPage> {
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget._result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("识别结果"),
        ),
        body: Container(
          padding: EdgeInsets.all(8),
          child: TextField(
            decoration: null,
            keyboardType: TextInputType.text,
            style: TextStyle(letterSpacing: 1.2,),
            maxLines: null,
            controller: _controller,
          ),
        ));
  }
}
