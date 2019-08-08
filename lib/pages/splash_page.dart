import 'package:flutter/material.dart';
import 'package:flutter_lime/db/database_helper.dart';
import 'package:flutter_lime/utils/const.dart';
import 'dart:async';
import 'package:flutter_lime/utils/http_utils.dart';
import 'dart:convert';
import 'package:flutter_lime/utils/log_utils.dart';
import 'package:flutter_lime/utils/store.dart';
import 'package:flutter_lime/utils/utils.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:package_info/package_info.dart';

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
    init();
  }

  @override
  Widget build(BuildContext context) {
    var color = themeColors[currThemeColorIndex];
    var widget = Material(
        color: Colors.grey[100],
        child: Column(children: <Widget>[
          Padding(padding: EdgeInsets.only(top: 80)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 6,
                height: 136,
                color: color,
              ),
              Padding(padding: EdgeInsets.only(left: 18)),
              Container(
                  width: 56,
                  child: Text(
                    app_name,
                    style: TextStyle(fontSize: 56, color: color),
                    softWrap: true,
                    maxLines: app_name.length,
                  )),
              Padding(padding: EdgeInsets.only(left: 24)),
              Container(
                  width: 20,
                  padding: EdgeInsets.only(top: 180),
                  child: Text(
                    app_desc,
                    style: TextStyle(fontSize: 20, color: color),
                    softWrap: true,
                    maxLines: app_desc.length,
                  ))
            ],
          ),
          Expanded(
              child: SafeArea(
            child: Container(
              padding: EdgeInsets.only(bottom: 20),
              alignment: Alignment.bottomCenter,
              child: Text(
                "By GaoLeng.",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
          ))
        ]));
    return widget;
  }

  //参数初始化方法，由于主题比较特殊，放在main中初始化
  void init() async {
    getToken();
    DataBaseHelper.init();
    getBySP([settings_camera]).then((kv) {
      var isAutoCamera = kv[settings_camera];
      if (isAutoCamera != null) currIsAutoCamera = isAutoCamera;
    });

    Future.delayed(Duration(milliseconds: 500), () {
      screenSize = MediaQuery.of(context).size;
      sizeForOcr = screenSize;
    });

    getRootDir().then((root) {
      rootDir = root;
    });

    PackageInfo.fromPlatform().then((packageInfo) {
      currPackageInfo = packageInfo;
    });
  }

  void getToken() {
    HttpUtils.getAccessTokenOfBaidu().then((value) {
      Map<String, dynamic> map = jsonDecode(value.toString());
      HttpUtils.accessToken = map["access_token"];
      LogUtils.i("accessToken: ${HttpUtils.accessToken}");
    });
  }
}
