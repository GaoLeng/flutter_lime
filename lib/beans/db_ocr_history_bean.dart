//OCR_HISTORY 表model
import 'package:flutter_lime/utils/const.dart';

class DBOcrHistoryBean {
  int id;
  String imgPath;
  String result;
  String dateTime;

  DBOcrHistoryBean({this.id, this.imgPath, this.result, this.dateTime});

  factory DBOcrHistoryBean.fromDb(Map<String, dynamic> data) {
    return DBOcrHistoryBean(
      id: data[ID],
      imgPath: data[IMG_PATH],
      result: data[RESULT],
      dateTime: data[DATE_TIME],
    );
  }
}
