import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_picgo/api/github_api.dart';
import 'package:flutter_picgo/model/github_config.dart';
import 'package:flutter_picgo/resources/pb_type_keys.dart';
import 'package:flutter_picgo/resources/table_name_keys.dart';
import 'package:flutter_picgo/utils/github_net.dart';
import 'package:flutter_picgo/utils/sql.dart';

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
      var sql = Sql.setTable(TABLE_NAME_PBSETTING);
      var pbsettingRow =
          (await sql.getBySql('type = ?', [PBTypeKeys.github]))?.first;
      if (pbsettingRow != null &&
          pbsettingRow["config"] != null &&
          pbsettingRow["config"] != '') {
        GithubConfig config =
            GithubConfig.fromJson(json.decode(pbsettingRow["config"]));
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
      var result = await GithubNetUtils.get(GithubApi.BASE_URL);
      _view.testConfigSuccess();
    } on DioError catch (e) {
      _view.showError(
          'ErrorCode : ${e.response?.statusCode ?? -1}, Message : ${e.response?.statusMessage ?? '网络异常，请重试'}');
    } catch (e) {
      _view.showError('$e');
    }
  }
}
