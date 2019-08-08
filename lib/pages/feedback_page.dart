import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_lime/utils/const.dart';
import 'package:flutter_lime/utils/dialog_utils.dart';
import 'package:flutter_lime/utils/http_utils.dart';
import 'package:flutter_lime/utils/log_utils.dart';
import 'package:flutter_lime/utils/utils.dart';

//反馈页
class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  TextEditingController _q1Controller;
  TextEditingController _q2Controller;

  @override
  void initState() {
    super.initState();
    _q1Controller = TextEditingController();
    _q2Controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("反馈建议")),
      body: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20),
              _generateQuestion("1、您有什么想说的？", "您可以在这里写下您的意见或建议，我们会及时查看。", 5,
                  500, _q1Controller),
              _generateQuestion(
                  "2、您的联系方式？", "选填，便于我们联系您。", 2, 50, _q2Controller),
              Row(children: <Widget>[
                Expanded(
                    flex: 1,
                    child: Padding(
                        padding: EdgeInsets.all(24),
                        child: OutlineButton(
                          child: Text("提交", style: TextStyle(fontSize: 16)),
                          highlightElevation: 4,
                          onPressed: _submit,
                          padding: EdgeInsets.all(10),
                        )))
              ]),
            ],
          )),
    );
  }

  _generateQuestion(q, desc, maxLines, maxLength, controller) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(q, style: TextStyle(fontSize: 16)),
          Padding(
            padding: EdgeInsets.only(left: 22, right: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(desc,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                TextField(
                  minLines: 1,
                  maxLines: maxLines,
                  controller: controller,
                  maxLength: maxLength,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _submit() async {
    if (_q1Controller.text.length == 0) {
      showMsg("反馈内容不可为空");
      return;
    }

    DialogUtils.showLoading(context, content: "正在提交...");
    HttpUtils.getTokenOfTypeForm().then((res) {
      LogUtils.i("getTokenOfTypeForm res: $res");
      final r = jsonDecode(res.toString());
      return HttpUtils.submitFeedBackByTypeForm(
          _q1Controller.text, _q2Controller.text, r["token"], r["landed_at"]);
    }).then((res) async {
      LogUtils.i("submitFeedBackByTypeForm res: $res");
      DialogUtils.dismiss(context);
      final r = jsonDecode(res.toString());
      if (r["message"] == "success") {
        await DialogUtils.showAlertDialog(
            context, Text("提交成功！\n\n感谢您为我们提出宝贵的意见或建议，您留下的任何信息都将用来改善我们的软件。"), [
          AlertDialogAction("确定", () => Navigator.pop(context)),
        ]);
        Navigator.pop(context);
      } else {
        showMsg("提交失败");
      }
    });
  }
}
