import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_picgo/api/smms_api.dart';
import 'package:flutter_picgo/model/smms_config.dart';
import 'package:flutter_picgo/resources/pb_type_keys.dart';
import 'package:flutter_picgo/utils/image_upload.dart';
import 'package:flutter_picgo/utils/smms_net.dart';

abstract class SMMSPageContract {
  loadConfigSuccess(SMMSConfig config);

  loadConfigFail(String msg);

  saveConfigSuccess();

  saveConfigFail(String msg);

  testConfigSuccess(String username);

  testConfigFail(String msg);
}

class SMMSPagePresenter {
  SMMSPageContract _view;

  SMMSPagePresenter(this._view);

  doLoadConfig() async {
    try {
      var configStr = await ImageUploadUtils.getPBConfig(PBTypeKeys.smms);
      var config = SMMSConfig.fromJson(json.decode(configStr));
      _view.loadConfigSuccess(config);
    } catch (e) {
      debugPrint(e);
      _view.loadConfigFail('$e');
    }
  }

  doSaveConfig(SMMSConfig config) async {
    try {
      var raw =
          await ImageUploadUtils.savePBConfig(PBTypeKeys.smms, json.encode(config));
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

  doTestConfig() async {
    try {
      var result = json.decode((await SMMSNetUtils.post(SMMSApi.GET_PROFILE, null)));
      if (result["success"]) {
        _view.testConfigSuccess(result["data"]["username"]);
      } else {
        _view.testConfigFail(result["message"] ?? '未知异常');
      }
    } on Error catch (e) {
      print(e.stackTrace);
      _view.testConfigFail('$e');
    }
  }
}
