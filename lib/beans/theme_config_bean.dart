import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:flutter/material.dart';
import 'package:flutter_lime/utils/const.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

//配置状态实体
class ThemeConfigInfoBean {
  MaterialColor theme = themeColors[currThemeColorIndex];
}

class ThemeConfigModel extends ThemeConfigInfoBean with ChangeNotifier {
  setTheme(theme) {
    this.theme = theme;
    notifyListeners();
  }
}
