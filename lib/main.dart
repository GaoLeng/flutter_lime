import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lime/pages/main_page.dart';
import 'package:flutter_lime/pages/splash_page.dart';
import 'package:flutter_lime/pages/home/settings_page.dart';
import 'package:flutter_lime/utils/const.dart';
import 'package:flutter_lime/pages/camera_page.dart';
import 'package:camera/camera.dart';
import 'package:flutter_lime/utils/store.dart';
import 'package:flutter_lime/utils/utils.dart';

import 'beans/theme_config_bean.dart';

Future main() async {
  try {
    availableCameras().then((cameras) {
      if (cameras != null) currAvailableCameras = cameras;
    });
  } on CameraException catch (e) {
    print(e.description);
  }

  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }

  await getBySP([settings_theme]).then((kv) {
    var index = kv[settings_theme];
    if (index != null) {
      currThemeColorIndex = index;
    }
  });

  runApp(Store.init(MyApp()));
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Store.connect<ThemeConfigModel>(builder: (context, child, value) {
      return MaterialApp(
        theme: ThemeData(
          primarySwatch: value.theme,
        ),
        routes: {
          page_main: (context) => MainPage(),
          page_settings: (context) => SettingsPage(),
          page_camera: (context) => CameraPage()
        },
        home: SplashPage(),
      );
    });
  }
}
