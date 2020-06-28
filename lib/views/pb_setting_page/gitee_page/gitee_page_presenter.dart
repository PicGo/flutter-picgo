import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_picgo/api/gitee_api.dart';
import 'package:flutter_picgo/model/gitee_config.dart';
import 'package:flutter_picgo/resources/pb_type_keys.dart';
import 'package:flutter_picgo/utils/image_upload.dart';
import 'package:flutter_picgo/utils/strings.dart';

abstract class GiteePageContract {
  loadConfig(GiteeConfig config);

  saveConfigSuccess();

  testConfigSuccess();

  showError(String errorMsg);
}

class GiteePagePresenter {
  GiteePageContract _view;

  GiteePagePresenter(this._view);

  doLoadConfig() async {
    try {
      var configStr = await ImageUploadUtils.getPBConfig(PBTypeKeys.gitee);
      if (!isBlank(configStr)) {
        GiteeConfig config = GiteeConfig.fromJson(json.decode(configStr));
        _view.loadConfig(config);
      }
    } catch (e) {
      _view.showError('$e');
    }
  }

  doSaveConfig(GiteeConfig config) async {
    if (config != null) {
      try {
        String jsondata = json.encode(config);
        int raw = await ImageUploadUtils.savePBConfig(PBTypeKeys.gitee, jsondata);
        if (raw == 1) {
          _view.saveConfigSuccess();
        } else {
          _view.showError('保存失败！请重试！');
        }
      } catch (e) {
        _view.showError('$e');
      }
    }
  }

  doTestConfig() async {
    try {
      await GiteeApi.testToken();
      _view.testConfigSuccess();
    } on DioError catch (e) {
      _view.showError('$e');
    } catch (e) {
      _view.showError('$e');
    }
  }
}
