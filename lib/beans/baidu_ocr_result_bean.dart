import 'ocr_result_bean.dart';

//百度ocr识别结果实体
class BaiDuOcrResultBean {
  int log_id;
  int error_code;
  String error_msg;
  List<OcrResultBean> words_result;

  BaiDuOcrResultBean(
      {this.log_id, this.error_code, this.error_msg, this.words_result});

  factory BaiDuOcrResultBean.fromJson(Map<String, dynamic> map) {
    var words = map["words_result"] as List;

    return BaiDuOcrResultBean(
        log_id: map["log_id"],
        error_code: map["error_code"] == null ? 0 : map["error_code"],
        error_msg: map["error_msg"],
        words_result: words?.map((value) {
          return OcrResultBean.fromJson(value);
        })?.toList());
  }
}
