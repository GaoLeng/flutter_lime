import 'package:flutter/material.dart';
import 'package:flutter_lime/pages/main_page.dart';
import 'package:flutter_lime/pages/splash_page.dart';
import 'package:flutter_lime/pages/home/settings_page.dart';
import 'package:flutter_lime/utils/const.dart';
import 'package:flutter_lime/pages/camera_page.dart';
import 'package:camera/camera.dart';

Future main() async {
  var cameras;
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print(e.description);
  }
  runApp(MyApp(cameras));
}

class MyApp extends StatelessWidget {
  List<CameraDescription> cameras;

  MyApp(this.cameras);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      routes: {
        page_main: (context) => MainPage(),
        page_settings: (context) => SettingsPage(),
        page_camera: (context) => CameraPage(cameras)
      },
      home: SplashPage(),
    );
  }
}
