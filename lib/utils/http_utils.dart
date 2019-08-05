import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter_lime/utils/image_utils.dart';
import 'package:flutter_lime/utils/utils.dart';

import 'const.dart';
import 'log_utils.dart';
import 'package:image/image.dart' as Img;

class HttpUtils {
  static String accessToken;

  static Dio _dio;

  static Dio _getInstance() {
    if (_dio == null) {
      _dio = Dio();
    }
    return _dio;
  }

  //获取accesstoken-百度
  static Future<Response> getAccessTokenOfBaidu() {
    return _getInstance()
        .post(baidu_access_token, queryParameters: baidu_access_token_params);
  }

  static Future<void> checkForUpdate(String currVersion) async {
    await _getInstance()
        .get("https://www.jianshu.com/p/47c26864e855")
        .then((value) {
      var res = value.toString();
      var version = res
          .substring(res.lastIndexOf(versionStart), res.lastIndexOf(versionEnd))
          .replaceAll(versionStart, "");
      LogUtils.i("checkForUpdate version: $version");

      if (checkVersionIsUpdate(currVersion, version)) {
        showMsg("有新的版本更新了~  v$version");
      } else {
        showMsg("已经是最新的版本了~");
      }
    });
  }

  //ocr-百度
  static Future<Response> ocrByBaidu(imgPath, width, height) async {
    return _getInstance().post(badiu_ocr_general_url,
        data: {
          'access_token': HttpUtils.accessToken,
          'vertexes_location': true,
          'probability': true,
          'image': await img2Base64(imgPath, width, height)
//          'url':
//              'https://cn.bing.com/th?id=OIP.eY74-PmsXafwG2VJ9Qv8qQHaHU&pid=Api&rs=1'
        },
        options: Options(
            contentType:
                ContentType.parse("application/x-www-form-urlencoded")));
  }

  static img2Base64(imgPath, width, height) async {
//    ImageUtils.Image image =
//        ImageUtils.decodeImage(File(imgPath).readAsBytesSync());
//    //将图片直接裁剪为屏幕的宽度，方便定位
//    ImageUtils.Image thumbnail =
//        ImageUtils.copyResize(image, width: screenSize.width.toInt());
//    List<int> imageBytes = ImageUtils.encodeJpg(thumbnail);

    final imageBytes = await ImageUtils.compressImage(imgPath,
        minWidth: width, minHeight: height);

//    var file = await ImageUtils.compressImageAndGetFile(imgPath);
//    final imageBytes = file.readAsBytesSync();
//    LogUtils.i("image after length: ${imageBytes.length}");
//    Img.decodeImage(imageBytes);

    return base64Encode(imageBytes);
  }

  //翻译-有道
  static Future<Response> translateByYouDao(text, from, to) {
    int currTime = getTimestamp() ~/ 1000;
    return _getInstance().post(youdao_translate_url,
        data: {
          "q": text,
          "from": from,
          "to": to,
          "appKey": youdao_app_key,
          "salt": currTime,
          "sign": _getYouDaoSign(
              "$youdao_app_key${_getInputText(text)}$currTime$currTime$youdao_app_secret"),
          "ext": "mp3",
          "voice": "0",
          "signType": "v3",
          "curtime": currTime,
        },
        options: Options(
            contentType:
                ContentType.parse("application/x-www-form-urlencoded")));
  }

  //根据有道要求生成签名信息
  static String _getYouDaoSign(String text) {
    return sha256.convert(utf8.encode(text)).toString();
  }

  //根据有道要求截取字符串
  static String _getInputText(text) {
    var len = text.length;
    return len <= 20
        ? text
        : (text.substring(0, 10) +
            len.toString() +
            text.substring(len - 10, len));
  }
}
