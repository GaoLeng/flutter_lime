import 'package:flutter/material.dart';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share/share.dart';

//工具类

int getTimestamp() => new DateTime.now().millisecondsSinceEpoch;

Future<String> getRootDir() async {
  final Directory extDir = await getApplicationDocumentsDirectory();
  final String dirPath = '${extDir.path}/Ocr_Images';
  await new Directory(dirPath).create(recursive: true);

  return dirPath;
}

void showMsg(String msg) {
  Fluttertoast.showToast(msg: msg, gravity: ToastGravity.CENTER);
}

String getDateTime() {
  String dateTime = new DateTime.now().toString();
  return dateTime.substring(0, dateTime.lastIndexOf("."));
}

String bool2Value(bool value) {
  return value ? "1" : "0";
}

bool value2Bool(String value) {
  return value == "1";
}

shareText(String text) {
  Share.share(text);
}
