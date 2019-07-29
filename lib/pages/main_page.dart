import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_lime/beans/ocr_result_bean.dart';
import 'package:flutter_lime/pages/home/home_page.dart';
import 'package:flutter_lime/utils/utils.dart';
import 'package:flutter_lime/utils/const.dart';
import 'package:flutter_lime/utils/http_utils.dart';
import 'package:flutter_lime/utils/log_utils.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

import 'ocr_page.dart';
import 'ocr_result_page.dart';

//首页
class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Widget> pages = [HomePage(), HomePage()];
  int currPosition = 0;
  String _imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: generateAppBar(),
        body: pages[currPosition],
        floatingActionButton: FloatingActionButton(
          onPressed: onCameraClicked,
          child: Icon(Icons.photo_camera),
          tooltip: "拍照识别",
        ),
        bottomNavigationBar: generateBottomNavBar());
  }

  //生成标题栏
  Widget generateAppBar() {
    return AppBar(
      title: Text(app_name),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: onSettingsClicked,
          tooltip: "设置",
        ),
      ],
    );
  }

  //生成底部导航
  Widget generateBottomNavBar() {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("首页")),
        BottomNavigationBarItem(icon: Icon(Icons.history), title: Text("历史")),
      ],
      currentIndex: currPosition,
      onTap: onNavTap,
    );
  }

  void onSettingsClicked() {
    Navigator.pushNamed(context, page_settings);
  }

  void onCameraClicked() {
    _openCamera();
  }

  Future _openCamera() async {
    final imgPath = await Navigator.pushNamed(context, page_camera);

    if (imgPath == null) return;
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return OcrPage(imgPath);
    }));
  }

  void onNavTap(int position) {
    setState(() {
      currPosition = position;
    });
  }
}
