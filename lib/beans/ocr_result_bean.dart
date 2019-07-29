class OcrResultBean {
  int log_id;
  int error_code;
  String error_msg;
  List<WordsResult> words_result;

  OcrResultBean(
      {this.log_id, this.error_code, this.error_msg, this.words_result});

  factory OcrResultBean.fromJson(Map<String, dynamic> map) {
    var words = map["words_result"] as List;

    return OcrResultBean(
        log_id: map["log_id"],
        error_code: map["error_code"] == null ? 0 : map["error_code"],
        error_msg: map["error_msg"],
        words_result: words?.map((i) {
          return WordsResult.fromJson(i);
        })?.toList());
  }
}

class WordsResult {
  String words;

  WordsResult({this.words});

  factory WordsResult.fromJson(Map<String, dynamic> map) {
    return WordsResult(words: map["words"]);
  }
}
