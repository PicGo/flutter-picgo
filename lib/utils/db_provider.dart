import 'package:flutter/material.dart';
import 'package:flutter_picgo/resources/table_name_keys.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbProvider {
  static Database db;

  /// 获取数据库中所有的表
  Future<List> getTables() async {
    if (db == null) {
      return Future.value([]);
    }
    List tables = await db
        .rawQuery('SELECT name FROM sqlite_master WHERE type = "table"');
    List<String> targetList = [];
    tables.forEach((item) {
      targetList.add(item['name']);
    });
    return targetList;
  }

  /// 检查数据库中, 表是否完整, 在部份android中, 会出现表丢失的情况
  Future checkTableIsRight() async {
    List<String> expectTables = [TABLE_NAME_UPLOADED, TABLE_NAME_PBSETTING];
    List<String> tables = await getTables();
    for (int i = 0; i < expectTables.length; i++) {
      if (!tables.contains(expectTables[i])) {
        return false;
      }
    }
    return true;
  }

  /// 初始化数据库
  Future init({bool isCreate = false}) async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'picgo.db');
    try {
      db = await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          // 创建pb_setting表
          await db.execute('''
          CREATE TABLE pb_setting (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            type varchar(20) NOT NULL UNIQUE,
            path varchar(20) NOT NULL UNIQUE,
            name varchar(50) DEFAULT NULL,
            config varchar(255) DEFAULT NULL,
            visible INTEGER DEFAULT 1
          )''');
          await db.execute('''
          CREATE TABLE uploaded (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            path varchar(255) NOT NULL,
            type varchar(20) NOT NULL
          )''');
          await db.transaction((txn) async {
            await txn.rawInsert(
                'INSERT INTO pb_setting VALUES (1, "github", "/setting/pb/github", "Github图床", NULL, 1)');
          });
        },
        onUpgrade: (db, oldVersion, newVersion) {
          
        },
      );
    } catch (e) {
      debugPrint('DataBase init Error >>>>>> $e');
    }
  }
}
