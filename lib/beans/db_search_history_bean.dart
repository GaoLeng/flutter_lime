import 'package:flutter_lime/utils/const.dart';

class DBSearchHistoryBean {
  int id;
  String text;
  String time;

  DBSearchHistoryBean({this.id, this.text, this.time});

  factory DBSearchHistoryBean.fromDB(Map<String, dynamic> data) {
    return DBSearchHistoryBean(
        id: data[ID], text: data[TEXT], time: data[DATE_TIME]);
  }
}
