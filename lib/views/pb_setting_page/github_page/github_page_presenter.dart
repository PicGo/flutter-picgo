import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_picgo/api/github_api.dart';
import 'package:flutter_picgo/model/github_config.dart';
import 'package:flutter_picgo/resources/pb_type_keys.dart';
import 'package:flutter_picgo/resources/table_name_keys.dart';
import 'package:flutter_picgo/utils/image_upload.dart';
import 'package:flutter_picgo/utils/sql.dart';
import 'package:flutter_picgo/utils/strings.dart';

abstract class GithubPageContract {
  loadConfig(GithubConfig config);

  saveConfigSuccess();

  testConfigSuccess();

  showError(String errorMsg);
}

class GithubPagePresenter {
  GithubPageContract _view;

  GithubPagePresenter(this._view);

  doLoadConfig() async {
    try {
      var configStr = await ImageUploadUtils.getPBConfig(PBTypeKeys.github);
      if (!isBlank(configStr)) {
        GithubConfig config = GithubConfig.fromJson(json.decode(configStr));
        _view.loadConfig(config);
      }
    } catch (e) {
      _view.showError('$e');
    }
  }

  doSaveConfig(GithubConfig config) async {
    if (config != null) {
      try {
        String jsondata = json.encode(config);
        var sql = Sql.setTable(TABLE_NAME_PBSETTING);
        int raw = await sql.rawUpdate(
            'config = ? WHERE type = ?', [jsondata, PBTypeKeys.github]);
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
      await GithubApi.testToken();
      _view.testConfigSuccess();
    } on DioError catch (e) {
      _view.showError('$e');
    } catch (e) {
      _view.showError('$e');
    }
  }
}
