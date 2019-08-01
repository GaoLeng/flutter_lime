import 'package:flutter/material.dart';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

shareText(text) {
  Share.share(text);
}

saveBySP(key, value) {
  SharedPreferences.getInstance().then((sp) {
    if (value is String) {
      sp.setString(key, value);
    } else if (value is int) {
      sp.setInt(key, value);
    } else if (value is bool) {
      sp.setBool(key, value);
    } else {
      showMsg("saveBySP 失败！");
    }
  });
}

Future<Map<String, dynamic>> getBySP(List<String> keys) async {
  if (keys == null || keys.isEmpty) return null;
  return await SharedPreferences.getInstance().then((sp) {
    Map<String, dynamic> kv = Map();
    keys.forEach((key) {
      kv[key] = sp.get(key);
    });
    return kv;
  });
}
