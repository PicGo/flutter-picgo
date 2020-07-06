import 'package:flutter/material.dart';
import 'package:flutter_picgo/resources/pb_type_keys.dart';
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

  /// 检查数据库中, 表是否存在
  Future checkTableIsRight(String expectTables) async {
    List<String> tables = await getTables();
    return tables.contains(expectTables);
  }

  /// 初始化数据库
  Future init({bool isCreate = false}) async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'picgo.db');
    try {
      db = await openDatabase(
        path,
        version: 4,
        onCreate: (db, version) async {
          // 创建pb_setting表
          _initPb(db);
          // 创建uploaded表
          await db.execute('''
          CREATE TABLE $TABLE_NAME_UPLOADED (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            path varchar(255) NOT NULL,
            type varchar(20) NOT NULL,
            info varchar(255) NOT NULL
          )''');
        },
        onUpgrade: (db, oldVersion, newVersion) {
          _initPb(db);
          _upgradeDbV1ToV2(db);
        },
      );
    } catch (e) {
      debugPrint('DataBase init Error >>>>>> $e');
    }
  }

  /// 初始化图床设置表
  _initPb(Database db) async {
    // await db.execute('DROP TABLE IF EXISTS $TABLE_NAME_PBSETTING');
    bool isExists = await checkTableIsRight(TABLE_NAME_PBSETTING);
    // backup data
    if (isExists) {
      await db.execute('ALTER TABLE $TABLE_NAME_PBSETTING RENAME TO ${TABLE_NAME_PBSETTING + "_backup"}');
    }
    // 创建pb_setting表
    await db.execute('''
          CREATE TABLE $TABLE_NAME_PBSETTING (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            type varchar(20) NOT NULL UNIQUE,
            path varchar(20) NOT NULL UNIQUE,
            name varchar(50) DEFAULT NULL,
            config varchar(255) DEFAULT NULL,
            visible INTEGER DEFAULT 1
          )''');
    await db.transaction((txn) async {
      // github图床
      await txn.rawInsert('INSERT INTO $TABLE_NAME_PBSETTING(type, path, name, config, visible) VALUES("${PBTypeKeys.github}", "/setting/pb/github", "Github图床", NULL, 1)');
      // SM.MS图床
      await txn.rawInsert('INSERT INTO $TABLE_NAME_PBSETTING(type, path, name, config, visible) VALUES("${PBTypeKeys.smms}", "/setting/pb/smms", "SM.MS图床", NULL, 1)');
      // Gitee图床
      await txn.rawInsert('INSERT INTO $TABLE_NAME_PBSETTING(type, path, name, config, visible) VALUES("${PBTypeKeys.gitee}", "/setting/pb/gitee", "Gitee图床", NULL, 1)');
      // Qiniu图床
      await txn.rawInsert('INSERT INTO $TABLE_NAME_PBSETTING(type, path, name, config, visible) VALUES("${PBTypeKeys.qiniu}", "/setting/pb/qiniu", "七牛图床", NULL, 1)');
      // copy data
      if (isExists) {
        await txn.execute('INSERT INTO $TABLE_NAME_PBSETTING SELECT config FROM ${TABLE_NAME_PBSETTING + "_backup"} WHERE $TABLE_NAME_PBSETTING.type = ${TABLE_NAME_PBSETTING + "_backup"}.type');
      }
    });
  }

  /// db版本升级
  _upgradeDbV1ToV2(Database db) async {
    await db.execute(
        'ALTER TABLE $TABLE_NAME_UPLOADED ADD COLUMN info varchar(255)');
  }
}
