import 'package:flutter_lime/utils/const.dart';

class LogUtils {
  static void i(String msg) => _log("i", msg);

  static void e(String msg) => _log("e", msg);

  static void _log(String tag, String msg) {
    if (isDebug) print("$tag:--------> $msg");
  }
}
