import 'package:flutter_lime/beans/db_ocr_history_bean.dart';
import 'package:flutter_lime/beans/db_search_history_bean.dart';
import 'package:flutter_lime/utils/const.dart';
import 'package:flutter_lime/utils/file_utils.dart';
import 'package:flutter_lime/utils/log_utils.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseHelper {
  static const int version = 2;
  static const String table_ocr_history = "OCR_HISTORY";
  static const String table_search_history = "SEARCH_HISTORY";
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
        //识别历史表
        db.execute("""CREATE TABLE $table_ocr_history (
                     $ID integer PRIMARY KEY AUTOINCREMENT,
                     $IMG_PATH text,
                     $RESULT text,
                     $JSON_TYPE integer,
                     $JSON_RESULT text,
                     $SIZE_FOR_OCR text,
                     $DATE_TIME text
                      );""");
        //搜索历史表
        db.execute("""CREATE TABLE $table_search_history (
                     $ID integer PRIMARY KEY AUTOINCREMENT,
                     $TEXT text,
                     $DATE_TIME text
                      );""");
      });
    }

    initDataBase();
  }

  Database getDatabase() {
    return _db;
  }

  //查询识别结果历史
  Future<List<DBOcrHistoryBean>> queryOcrHistory(q) async {
    var where = q == null ? null : "$RESULT like '%$q%'";
    final result = await DataBaseHelper.getInstance().getDatabase().query(
        DataBaseHelper.table_ocr_history,
        where: where,
        orderBy: "ID desc");
    LogUtils.i("queryHistory: $result");

    var _histories = List<DBOcrHistoryBean>();
    result.forEach((row) {
      var bean = DBOcrHistoryBean.fromDb(row);
      _histories.add(bean);
    });
    return _histories;
  }

  //插入识别结果历史
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

  //删除指定识别记录
  deleteOcrHistoryById(int id) {
    if (id == null) return;
    getDatabase().delete(table_ocr_history, where: "$ID = $id");
  }

  //清空识别记录
  clearOcrHistory() {
    getDatabase().delete(table_ocr_history);
  }

  //查询搜索历史
  Future<List<DBSearchHistoryBean>> querySearchHistory() async {
    var res = await DataBaseHelper.getInstance()
        .getDatabase()
        .query(table_search_history, orderBy: "ID desc", limit: 15);

    return res.map((value) {
      return DBSearchHistoryBean.fromDB(value);
    }).toList();
  }

  //插入搜索历史
  Future<int> insertSearchHistory(DBSearchHistoryBean bean) async {
    return await DataBaseHelper.getInstance().getDatabase().insert(
        DataBaseHelper.table_search_history,
        {TEXT: bean.text, DATE_TIME: bean.time});
  }

  //删除指定的搜索历史
  deleteSearchHistoryByID(int id) {
    if (id == null) return;
    DataBaseHelper.getInstance()
        .getDatabase()
        .delete(table_search_history, where: "$ID = $id");
  }

  //清空搜索历史
  Future<int> clearSearchHistory() async {
    return await DataBaseHelper.getInstance()
        .getDatabase()
        .delete(table_search_history);
  }

  void close() {
    if (_db == null || !_db.isOpen) return;
    _db.close();
  }
}
