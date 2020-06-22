import 'dart:io';
import 'package:flutter_picgo/model/uploaded.dart';
import 'package:flutter_picgo/resources/table_name_keys.dart';
import 'package:flutter_picgo/utils/shared_preferences.dart';
import 'package:flutter_picgo/utils/sql.dart';
import 'package:flutter_picgo/utils/strategy/image_upload_strategy.dart';

/// 图像上传类
class ImageUpload {
  ImageUploadStrategy _strategy;

  ImageUpload(this._strategy);

  Future<Uploaded> delete(Uploaded uploaded) {
    return _strategy.delete(uploaded);
  }

  Future<Uploaded> upload(File file, String renameImage) {
    return _strategy.upload(file, renameImage);
  }

  /// 获取默认图床类型
  Future<String> getDefaultPB() async {
    var sp = await SpUtil.getInstance();
    String pbType = sp.getDefaultPB();
    return pbType;
  }

  /// 设置默认图床
  Future setDefaultPB(String type) async {
    var sp = await SpUtil.getInstance();
    if (sp.getDefaultPB() != type) {
      sp.setDefaultPB(type);
    }
  }

  /// 保存图床配置
  Future<int> savePBConfig(String type, String config) async {
    var sql = Sql.setTable(TABLE_NAME_PBSETTING);
    int raw = await sql.rawUpdate('config = ? WHERE type = ?', [config, type]);
    return raw;
  }

  /// 获取当前图床配置
  Future<String> getPBConfig(String type) async {
    var sql = Sql.setTable(TABLE_NAME_PBSETTING);
    var pbsettingRow = await sql.getBySql('type = ?', [type]);
    if (pbsettingRow != null && pbsettingRow.length > 0) {
      return pbsettingRow.first["config"];
    }
  }
}
