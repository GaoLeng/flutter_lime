import 'package:flutter/material.dart';
import 'package:flutter_lime/utils/const.dart';
import 'dart:async';
import 'package:flutter_lime/utils/http_utils.dart';
import 'dart:convert';
import 'package:flutter_lime/utils/log_utils.dart';

//欢迎页
class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  int time = 3;
  Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      time--;
      print("time:$time");
      if (time <= 0) {
        Navigator.pushNamedAndRemoveUntil(
            context, page_main, (route) => route == null);
        timer?.cancel();
      }
    });
    getToken();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("images/splash_bg.png"), fit: BoxFit.fill),
      ),
      child: Column(
        children: <Widget>[
          Expanded(flex: 1, child: Text("")),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                image: AssetImage("images/logo.png"),
                width: 80,
                height: 80,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    app_name,
                    style: TextStyle(fontSize: 22),
                  ),
                  Text("文字识别")
                ],
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 40),
          )
        ],
      ),
    ));
  }

  void getToken() {
    Future getToken() async {
      return await HttpUtils.getInstance()
          .post(baidu_access_token, queryParameters: baidu_access_token_params);
    }

    getToken().then((value) {
      Map<String, dynamic> map = jsonDecode(value.toString());
      HttpUtils.accessToken = map["access_token"];
      LogUtils.i("accessToken: ${HttpUtils.accessToken}");
    });
  }
}
