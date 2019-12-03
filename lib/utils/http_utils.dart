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

  //检查更新-简书
  static Future<void> checkForUpdate() async {
    await _getInstance().get(check_for_update_url).then((value) {
      var res = value.toString();
      var version = res
          .substring(res.lastIndexOf(versionStart), res.lastIndexOf(versionEnd))
          .replaceAll(versionStart, "");
      LogUtils.i("checkForUpdate version: $version");

      if (checkVersionIsUpdate(currPackageInfo.version, version)) {
        showMsg("有新的版本更新了~  v$version");
      } else {
        showMsg("已经是最新的版本了~");
      }
    });
  }

  //反馈建议token-TypeForm
  static Future<Response> getTokenOfTypeForm() async {
    return await _getInstance().post(type_form_token_url,
        options: Options(headers: {
          "Accept": "application/json",
          "User-Agent":
              "Mozilla/5.0 (Linux; Android 5.0; SM-G900P Build/LRX21T) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.142 Mobile Safari/537.36"
        }, contentType: ContentType.parse("application/x-www-form-urlencoded")),
        queryParameters: {
          "Origin": "https://gaoleng.typeform.com",
          "Referer": "https://gaoleng.typeform.com/to/MCxvZN",
        });
  }

  //提交反馈-TypeForm
  static Future<Response> submitFeedBackByTypeForm(
      answer1, answer2, token, landedAt) async {
    LogUtils.i(
        "answer1:$answer1, answer2: $answer2, token: $token, landedAt: $landedAt");
    return await _getInstance().post(
      type_form_submit_url,
      options: Options(
          contentType: ContentType.parse("application/x-www-form-urlencoded")),
      data: FormData.from({
        "form[textarea:FyMGD59M3dKF]": answer1,
        "form[textfield:YDxOa9qNANrx]": answer2,
        "form[token]": token,
        "form[landed_at]": landedAt,
        "form[language]": "ch",
      }),
    );
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
    final imageBytes = await ImageUtils.compressImage(imgPath,
        minWidth: width, minHeight: height);
    return base64Encode(imageBytes);
  }

  //翻译-百度
  static Future<Response> translateByBaidu(text, from, to) {
    //把当前时间作为一个salt
    int currTime = getTimestamp();
    return _getInstance().post(baidu_translate_url,
        data: FormData.from({
          "q": text,
          "from": from,
          "to": to,
          "appid": baidu_translate_app_id,
          "salt": currTime,
          "sign": _getBaiDuSign(
              "$baidu_translate_app_id$text$currTime$baidu_translate_secret")
        }));
  }

  //根据百度要求生成签名信息
  static String _getBaiDuSign(String text) {
    return md5.convert(utf8.encode(text)).toString();
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
