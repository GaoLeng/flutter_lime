import 'package:flutter/material.dart';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

//工具类
class Utils {
  static var keys = GlobalKey<ScaffoldState>();

  static void showBottomMsg(String msg) {
    SnackBar snackBar = SnackBar(
      content: Text(msg),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 2),
    );
    keys.currentState.showSnackBar(snackBar);
  }

  static int getTimestamp() =>
      new DateTime.now().millisecondsSinceEpoch;

  static Future<String> getRootDir() async {
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Ocr_Images';
    await new Directory(dirPath).create(recursive: true);

    return dirPath;
  }

  static void showMsg(String msg) {
    Fluttertoast.showToast(msg: msg);
  }

  static String getDateTime() {
    String dateTime = new DateTime.now().toString();
    return dateTime.substring(0, dateTime.lastIndexOf("."));
  }
}
