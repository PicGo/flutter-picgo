import 'dart:io';
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
        version: 9,
        onCreate: (db, version) async {
          // 创建pb_setting表
          _initPb(db);
          // 创建uploaded表
          await db.execute('''
          CREATE TABLE $TABLE_NAME_UPLOADED (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            path varchar(255) NOT NULL,
            type varchar(20) NOT NULL,
            info varchar(255)
          )''');
        },
        onUpgrade: (db, oldVersion, newVersion) {
          _initPb(db);

          /// v1 to v2
          if (oldVersion == 1) {
            _upgradeDbV1ToV2(db);
          }
        },
      );
    } catch (e) {
      print('DataBase init Error >>>>>> $e');
      var file = File(path);
      file.deleteSync();
    }
  }

  /// 初始化图床设置表
  _initPb(Database db) async {
    List tables = await db
        .rawQuery('SELECT name FROM sqlite_master WHERE type = "table"');
    bool isExists = false;
    tables.forEach((item) {
      if (item['name'] == TABLE_NAME_PBSETTING) {
        isExists = true;
      }
    });
    if (isExists) {
      await db.execute(
          'ALTER TABLE $TABLE_NAME_PBSETTING RENAME TO ${TABLE_NAME_PBSETTING + "_backup"}');
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

    /// github图床
    await db.rawInsert(
        'INSERT INTO $TABLE_NAME_PBSETTING(type, path, name, config, visible) VALUES("${PBTypeKeys.github}", "/setting/pb/github", "Github图床", NULL, 1)');

    /// SM.MS图床
    await db.rawInsert(
        'INSERT INTO $TABLE_NAME_PBSETTING(type, path, name, config, visible) VALUES("${PBTypeKeys.smms}", "/setting/pb/smms", "SM.MS图床", NULL, 1)');

    /// Gitee图床
    await db.rawInsert(
        'INSERT INTO $TABLE_NAME_PBSETTING(type, path, name, config, visible) VALUES("${PBTypeKeys.gitee}", "/setting/pb/gitee", "Gitee图床", NULL, 1)');

    /// Qiniu图床
    await db.rawInsert(
        'INSERT INTO $TABLE_NAME_PBSETTING(type, path, name, config, visible) VALUES("${PBTypeKeys.qiniu}", "/setting/pb/qiniu", "七牛图床", NULL, 1)');

    /// 阿里云OSS
    await db.rawInsert(
        'INSERT INTO $TABLE_NAME_PBSETTING(type, path, name, config, visible) VALUES("${PBTypeKeys.aliyun}", "/setting/pb/aliyun", "阿里云OSS图床", NULL, 1)');

    /// 腾讯云COS
    await db.rawInsert(
        'INSERT INTO $TABLE_NAME_PBSETTING(type, path, name, config, visible) VALUES("${PBTypeKeys.tcyun}", "/setting/pb/tcyun", "腾讯云COS图床", NULL, 1)');

    /// 牛图网
    await db.rawInsert(
        'INSERT INTO $TABLE_NAME_PBSETTING(type, path, name, config, visible) VALUES("${PBTypeKeys.niupic}", "/setting/pb/niupic", "牛图网图床", NULL, 1)');

    /// 兰空图床
    await db.rawInsert(
        'INSERT INTO $TABLE_NAME_PBSETTING(type, path, name, config, visible) VALUES("${PBTypeKeys.lsky}", "/setting/pb/lsky", "兰空图床", NULL, 1)');

    /// 又拍云图床
    await db.rawInsert(
        'INSERT INTO $TABLE_NAME_PBSETTING(type, path, name, config, visible) VALUES("${PBTypeKeys.upyun}", "/setting/pb/upyun", "又拍云图床", NULL, 1)');
    // copy data
    // update authors set dynasty_index=(select id  from dynasties where dynasties .name=authors.dynasty) where dynasty in (select name from dynasties )
    if (isExists) {
      await db.execute('''
          UPDATE $TABLE_NAME_PBSETTING SET config = 
          (SELECT config FROM ${TABLE_NAME_PBSETTING + "_backup"} WHERE ${TABLE_NAME_PBSETTING + "_backup"}.type = $TABLE_NAME_PBSETTING.type)
          ''');
      // drop backup
      await db
          .execute('DROP TABLE IF EXISTS ${TABLE_NAME_PBSETTING + "_backup"}');
    }
  }

  /// db版本升级
  _upgradeDbV1ToV2(Database db) async {
    await db.execute(
        'ALTER TABLE $TABLE_NAME_UPLOADED ADD COLUMN info varchar(255)');
  }
}
