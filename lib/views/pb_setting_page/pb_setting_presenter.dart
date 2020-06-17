import 'package:flutter/material.dart';
import 'package:flutter_picgo/model/pb_setting.dart';
import 'package:flutter_picgo/utils/sql.dart';

abstract class PBSettingPageContract {
  void loadPb(List<PBSetting> settings);

  void loadError(String errorMsg);
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
}
