//有道翻译结果
class YouDaoTransResultBean {
  String errorCode;
  String query;
  List<String> translation;
  BasicBean basic;
  List<WebBean> web;
  List<DictBean> dict;
  String l;
  String tSpeakUrl;
  String speakUrl;

  YouDaoTransResultBean(
      {this.errorCode,
      this.query,
      this.translation,
      this.basic,
      this.web,
      this.dict,
      this.l,
      this.tSpeakUrl,
      this.speakUrl});

  factory YouDaoTransResultBean.fromJson(Map<String, dynamic> data) {
    return YouDaoTransResultBean(
        errorCode: data["errorCode"],
        query: data["query"],
        translation: List.from(data["translation"]),
        basic: null,
        web: null,
        dict: null,
        l: data["l"],
        tSpeakUrl: data["tSpeakUrl"],
        speakUrl: data["speakUrl"]);
  }
}

class BasicBean {
  String phonetic;
  String uk_phonetic;
  String us_phonetic;
  String uk_speech;
  String us_speech;
  List<String> explains;
}

class WebBean {
  String key;
  List<String> value;
}

class DictBean {
  String url;
}

class WebDictBean {
  String url;
}
