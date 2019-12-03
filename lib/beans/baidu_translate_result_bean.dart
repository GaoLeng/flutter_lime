class BaiDuTransResultBean {
  //{"from":"en","to":"zh","trans_result":[{"src":"apple","dst":"\u82f9\u679c"}]}
  List<TransResult> trans_result;

  BaiDuTransResultBean(this.trans_result);

  factory BaiDuTransResultBean.fromJson(Map<String, dynamic> data) {
    final list = data["trans_result"] as List;
    return BaiDuTransResultBean(list.map((r) {
      return TransResult.fromJson(r);
    }).toList());
  }
}

class TransResult {
  String dst;

  TransResult(this.dst);

  factory TransResult.fromJson(Map<String, dynamic> data) {
    return TransResult(data["dst"]);
  }
}
