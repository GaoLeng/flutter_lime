import 'package:flutter/material.dart';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

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

//是否有新版本
bool checkVersionIsUpdate(String currVersion, String newVersion) {
  var currVersionArray = currVersion.split(".").map((v) => toInt(v)).toList();
  var newVersionArray = newVersion.split(".").map((v) => toInt(v)).toList();

  return checkSubVersion(0, currVersionArray, newVersionArray);
}

//检查子版本
bool checkSubVersion(index, currVersionArray, newVersionArray) {
  if (index >= 2) return false;

  if (currVersionArray[index] > newVersionArray[index]) {
    return false;
  } else if (currVersionArray[index] == newVersionArray[index]) {
    return checkSubVersion(++index, currVersionArray, newVersionArray);
  } else {
    return true;
  }
}

int toInt(String num) {
  return int.parse(num);
}
