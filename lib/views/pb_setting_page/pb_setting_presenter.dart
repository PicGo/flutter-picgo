import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_picgo/model/pb_setting.dart';
import 'package:flutter_picgo/resources/table_name_keys.dart';
import 'package:flutter_picgo/utils/image_upload.dart';
import 'package:flutter_picgo/utils/sql.dart';
import 'package:flutter_picgo/utils/strings.dart';

abstract class PBSettingPageContract {
  void loadPb(List<PBSetting> settings);

  void loadError(String errorMsg);

  void transferError(String e);

  void transferSuccess();

  void exportConfigSuccess(String config);

  void exportConfigError(String message);
}

class PBSettingPagePresenter {
  PBSettingPageContract _view;

  PBSettingPagePresenter(this._view);

  doLoadPb() async {
    try {
      var sql = Sql.setTable('pb_setting');
      var list = await sql.get();
      var realList = list.map((map) {
        return PBSetting.fromMap(map);
      }).toList();
      _view.loadPb(realList);
    } catch (e) {
      _view.loadError('${e.toString()}');
    }
  }

  /// transfer picgo json config to flutter-picgo
  doTransferJson(String jsonStr) async {
    try {
      Map<String, dynamic> map = json.decode(jsonStr);
      map.forEach((key, value) async {
        var config = json.encode(value);
        await ImageUploadUtils.savePBConfig(key, config);
      });
      // success
      _view.transferSuccess();
    } catch (e) {
      _view.transferError('转换失败，请确认配置无误');
    }
  }

  /// 导出所有配置
  doExportConfig() async {
    try {
      var sql = Sql.setTable(TABLE_NAME_PBSETTING);
      var list = await sql.get();
      Map<String, dynamic> map = {};
      list.forEach((element) {
        var pbItem = PBSetting.fromMap(element);
        if (!isBlank(pbItem.config)) {
          map[pbItem.type] = json.decode(pbItem.config);
        }
      });
      _view.exportConfigSuccess(json.encode(map));
    } catch (e) {
      _view.exportConfigError('$e');
    }
  }
}
