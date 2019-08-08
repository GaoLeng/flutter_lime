import 'package:flutter/material.dart';

class MyIcons {
  static const IconData fullscreen = const _MyIconData(0xe758);
  static const IconData fullscreen_exit = const _MyIconData(0xe757);
  static const IconData exchange = const _MyIconData(0xe61e);

}

class _MyIconData extends IconData {
  const _MyIconData(int codePoint) : super(codePoint, fontFamily: "iconfont");
}
