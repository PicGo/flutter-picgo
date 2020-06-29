import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_picgo/model/github_config.dart';
import 'package:flutter_picgo/model/pb_setting.dart';
import 'package:flutter_picgo/model/smms_config.dart';
import 'package:flutter_picgo/resources/pb_type_keys.dart';
import 'package:flutter_picgo/utils/image_upload.dart';
import 'package:flutter_picgo/utils/sql.dart';

abstract class PBSettingPageContract {
  void loadPb(List<PBSetting> settings);

  void loadError(String errorMsg);

  void transferError(String e);

  void transferSuccess();
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
      debugPrint('Error >>>> $e');
      _view.loadError('${e.toString()}');
    }
  }

  /// transfer picgo json config to flutter-picgo
  doTransferJson(String jsonStr) async {
    try {
      var map = json.decode(jsonStr);
      // decode github
      if (map[PBTypeKeys.github] != null) {
        var githubConfig =
            json.encode(GithubConfig.fromJson(map[PBTypeKeys.github]));
        await ImageUploadUtils.savePBConfig(PBTypeKeys.github, githubConfig);
      }
      // decode smms
      if (map[PBTypeKeys.smms] != null) {
        var smmsConfig = json.encode(SMMSConfig.fromJson(map[PBTypeKeys.smms]));
        await ImageUploadUtils.savePBConfig(PBTypeKeys.smms, smmsConfig);
      }
      // success
      _view.transferSuccess();
    } catch (e) {
      _view.transferError('转换失败，请确认配置无误');
    }
  }
}
