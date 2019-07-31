import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_lime/utils/log_utils.dart';
import 'package:flutter_lime/utils/utils.dart';

const MethodChannel _channel = const MethodChannel('plugins.flutter.io/camera');

//拍照页面
class CameraPage extends StatefulWidget {
  List<CameraDescription> cameras;

  CameraPage(this.cameras);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  String imagePath;

  //闪光灯是否开启
  bool _isFlashOff = true;

  //是否为后置摄像头
  bool _isBackgroundCamera = true;
  CameraController _cameraController;

  Future initCamera(CameraDescription desc) async {
    _cameraController = CameraController(desc, ResolutionPreset.medium);
    _cameraController.addListener(() {
      if (mounted) setState(() {});
      if (_cameraController.value.hasError) {
        print('Camera Error: ${_cameraController.value.errorDescription}');
      }
    });

    try {
      await _cameraController.initialize();
    } on CameraException catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.cameras.length == 0) {
      showMsg("没有找到相机！");
      Navigator.pop(context);
      return;
    }
    initCamera(widget.cameras[0]);
  }

  @override
  void dispose() {
    super.dispose();
    _cameraController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = 0.0;
    var height = 0.0;
    if (_cameraController.value.previewSize != null) {
      width = _cameraController.value.previewSize.width;
      height = _cameraController.value.previewSize.height - 80;
    }

    return Material(
        color: Colors.black,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: Container(
                width: width,
                height: height,
                child: CameraPreview(_cameraController),
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  generateIconButtonWithExpanded(
                      Icons.close, 28, onCloseClicked),
                  generateIconButtonWithExpanded(
                      Icons.camera, 56, onTakeClicked),
                  generateIconButtonWithExpanded(
                      _isFlashOff ? Icons.flash_off : Icons.flash_on,
                      28,
                      onLightClicked)
                ],
              ),
            )
          ],
        ));
  }

  //生成底部按钮
  Widget generateIconButtonWithExpanded(
      IconData icon, double iconSize, VoidCallback function) {
    return Expanded(
      flex: 1,
      child: IconButton(
        onPressed: function,
        iconSize: iconSize,
        highlightColor: Colors.green,
        color: Colors.white,
        icon: Icon(icon),
      ),
    );
  }

  void onCloseClicked() {
    Navigator.pop(context, imagePath);
  }

  void onTakeClicked() {
    takePicture().then((String filePath) {
      if (mounted) {
        setState(() {
          imagePath = filePath;
        });
        if (filePath != null) {
          LogUtils.i('Picture saved to $filePath');
          onCloseClicked();
        }
      }
    });
  }

  Future onLightClicked() async {
    //TODO ios flash on/off
    await _channel.invokeMethod(_isFlashOff ? "turnOnFlash" : "turnOffFlash");
    setState(() {
      _isFlashOff = !_isFlashOff;
    });
  }

  Future<String> takePicture() async {
    if (!_cameraController.value.isInitialized) {
      LogUtils.i('Error: select a camera first.');
      return null;
    }
    var dirPath = await getRootDir();
    final String filePath = '$dirPath/${getTimestamp()}.jpg';

    if (_cameraController.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      await _cameraController.takePicture(filePath);
    } on CameraException catch (e) {
      LogUtils.e(e.toString());
      return null;
    }
    return filePath;
  }
}
