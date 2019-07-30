import 'package:flutter_lime/utils/log_utils.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseHelper {
  static const int version = 2;
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
                     "ID" integer PRIMARY KEY AUTOINCREMENT,
                     "IMG_PATH" text(500,2),
                     "RESULT" text,
                     "DATE_TIME" text
                      );""");
      });
    }

    initDataBase();
  }

  Database getDatabase() {
    return _db;
  }

  void close() {
    if (_db == null || !_db.isOpen) return;
    _db.close();
  }
}
