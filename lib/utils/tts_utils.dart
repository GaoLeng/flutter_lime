import 'package:flutter_tts/flutter_tts.dart';

class TTSUtils {
  FlutterTts _tts;

  static TTSUtils _instance;

  static TTSUtils getInstance() {
    if (_instance == null) _instance = TTSUtils();
    return _instance;
  }

  TTSUtils() {
    _tts = FlutterTts();
  }

  speak(text) {
    _tts.speak(text);
  }

  stop() {
    _tts.stop();
  }

  //设置语言 默认中文 en-US
  setLanguage(language) {
    _tts.setLanguage(language);
  }

  //语速
  //from 0.0 (silent) to 1.0 (loudest)
  setSpeechRate(rate) {
    _tts.setSpeechRate(rate);
  }
}
