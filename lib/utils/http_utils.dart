import 'package:dio/dio.dart';

class HttpUtils {
  static String accessToken;

  static Dio _dio;

  static Dio getInstance() {
    if (_dio == null) {
      _dio = Dio();
    }
    return _dio;
  }
}
