import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

//--------------------配置------------------------
const bool is_debug = true;
const String app_name = "青柠";
const String app_desc = "移动扫描仪";
const int default_theme_color_index = 8;
const List<ColorSwatch> themeColors = materialColors;
int currThemeColorIndex = default_theme_color_index;
bool currIsAutoCamera = false;
List<CameraDescription> currAvailableCameras = [];
Size screenSize; //屏幕尺寸，dp单位
String rootDir;
Size sizeForOcr; //ocr识别时的尺寸，方便后面等比例画线框

//--------------------路由------------------------
const String page_main = "page_main";
const String page_settings = "page_settings";
const String page_camera = "page_camera";

//--------------------有道翻译------------------------
const String youdao_translate_url = "https://openapi.youdao.com/api";
const String youdao_app_key = "535d76e841c7e282";
const String youdao_app_secret = "rTHl5CKyLF1aNjFbppTK3jAmAthG5WaH";

//--------------------BaiDu OCR-------------------------
//通用基础版
const String badiu_ocr_basic_url =
    "https://aip.baidubce.com/rest/2.0/ocr/v1/general_basic";
//通用含位置信息版
const String badiu_ocr_general_url =
    "https://aip.baidubce.com/rest/2.0/ocr/v1/general";
const String baidu_access_token = "https://aip.baidubce.com/oauth/2.0/token";
const Map<String, String> baidu_access_token_params = {
  'grant_type': 'client_credentials',
  'client_id': 'fN57Ocb7LfG44crItbU6wson',
  'client_secret': 'x5DH0jsbpZkf5NAF5ur0ZhnqahjCditC'
};

//----------------------DB---------------------------
const String ID = "ID";
const String IMG_PATH = "IMG_PATH";
const String RESULT = "RESULT";
const String JSON_RESULT = "JSON_RESULT";
const String JSON_TYPE = "JSON_TYPE";
const String SIZE_FOR_OCR = "SIZE_FOR_OCR";
const String DATE_TIME = "DATE_TIME";

//----------------------设置---------------------------
const String settings_about = "关于$app_name";
const String settings_camera = "自动进入拍照";
const String settings_donation = "捐赠";
const String settings_check_update = "检查更新";
const String settings_update_log = "更新日志";
const String settings_score = "评分";
const String settings_feedback = "反馈";
const String settings_theme = "主题色";
const String settings_clear_cache = "清除缓存";
const String settings_trans_option = "翻译选项";

//----------------------其他---------------------------
const String image_thumb_suffix = "_thumbnail.jpg"; //ocr缩略图文件名后缀
//lime-version-android#1.0.1#lime-version-android
final String versionStart = Platform.isAndroid ? "lime-version-android#" : "lime-version-ios#";
final String versionEnd = Platform.isAndroid ? "#lime-version-android" : "#lime-version-ios";
