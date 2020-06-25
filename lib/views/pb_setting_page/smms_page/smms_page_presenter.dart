import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_picgo/model/smms_config.dart';
import 'package:flutter_picgo/resources/pb_type_keys.dart';
import 'package:flutter_picgo/utils/image_upload.dart';

abstract class SMMSPageContract {

  loadConfigSuccess(SMMSConfig config);

  loadConfigFail(String msg);

  saveConfigSuccess();

  saveConfigFail(String msg);

}

class SMMSPagePresenter {

  SMMSPageContract _view;

  SMMSPagePresenter(this._view);

  doLoadConfig() async {
    try {
      var configStr = await ImageUpload.getPBConfig(PBTypeKeys.smms);
      var config = SMMSConfig.fromJson(json.decode(configStr));
      _view.loadConfigSuccess(config);
    } catch (e) {
      debugPrint(e);
      _view.loadConfigFail('$e');
    }
  }

  doSaveConfig(SMMSConfig config) async {
    try {
      var raw = await ImageUpload.savePBConfig(PBTypeKeys.smms, json.encode(config));
      if (raw > 0) {
        _view.saveConfigSuccess();
      } else {
        _view.saveConfigFail('保存失败，请重试');
      }
    } catch (e) {
      debugPrint(e);
      _view.saveConfigFail('$e');
    }
  }

}