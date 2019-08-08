import 'package:flutter_lime/beans/db_ocr_history_bean.dart';
import 'package:flutter_lime/utils/const.dart';
import 'package:flutter_lime/utils/file_utils.dart';
import 'package:flutter_lime/utils/log_utils.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseHelper {
  static const int version = 1;
  static const String table_ocr_history = "OCR_HISTORY";
  static DataBaseHelper _helper;

  static void init() {
    if (_helper == null) {
      _helper = DataBaseHelper();
    }
  }

  static DataBaseHelper getInstance() {
    return _helper;
  }

  Database _db;

  DataBaseHelper() {
    Future initDataBase() async {
      _db = await openDatabase('lime_db.db', version: version,
          onCreate: (db, version) {
        LogUtils.i("currVersion: $version");
        db.execute("""CREATE TABLE $table_ocr_history (
                     $ID integer PRIMARY KEY AUTOINCREMENT,
                     $IMG_PATH text,
                     $RESULT text,
                     $JSON_TYPE integer,
                     $JSON_RESULT text,
                     $SIZE_FOR_OCR text,
                     $DATE_TIME text
                      );""");
      });
    }

    initDataBase();
  }

  Database getDatabase() {
    return _db;
  }

  queryHistory() async {
    return await DataBaseHelper.getInstance()
        .getDatabase()
        .query(DataBaseHelper.table_ocr_history, orderBy: "ID desc");
  }

  insertHistory(DBOcrHistoryBean bean) {
    DataBaseHelper.getInstance()
        .getDatabase()
        .insert(DataBaseHelper.table_ocr_history, {
      IMG_PATH: convertPath(true, bean.imgPath),
      RESULT: bean.result,
      JSON_RESULT: bean.jsonResult,
      JSON_TYPE: bean.jsonType,
      SIZE_FOR_OCR: "${bean.widthForOcr},${bean.heightForOcr}",
      DATE_TIME: bean.dateTime
    });
  }

  void close() {
    if (_db == null || !_db.isOpen) return;
    _db.close();
  }
}
