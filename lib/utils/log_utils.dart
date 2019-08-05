import 'package:flutter_lime/utils/const.dart';

class LogUtils {
  static void i(msg) => _log("i", msg);

  static void e(msg) => _log("e", msg);

  static void _log(String tag, msg) {
    if (is_debug) print("$tag:--------> $msg");
  }
}
