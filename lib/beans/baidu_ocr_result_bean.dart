import 'ocr_result_bean.dart';

//百度ocr识别结果实体
class BaiDuOcrResultBean {
  int logId;
  int errorCode;
  String errorMsg;
  List<OcrResultBean> wordsResult;

  BaiDuOcrResultBean(
      {this.logId, this.errorCode, this.errorMsg, this.wordsResult});

  factory BaiDuOcrResultBean.fromJson(Map<String, dynamic> map) {
    var words = map["words_result"] as List;

    return BaiDuOcrResultBean(
        logId: map["log_id"],
        errorCode: map["error_code"] == null ? 0 : map["error_code"],
        errorMsg: map["error_msg"],
        wordsResult: words?.map((value) {
          return OcrResultBean.fromJson(value);
        })?.toList());
  }
}
