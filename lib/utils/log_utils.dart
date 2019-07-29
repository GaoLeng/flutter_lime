class LogUtils {
  static void i(String msg) => log("i", msg);

  static void e(String msg) => log("e", msg);

  static void log(String tag, String msg) => print("$tag:--------> $msg");
}
