import 'dart:convert';
import 'package:flutter_picgo/model/github_config.dart';
import 'package:flutter_picgo/utils/sql.dart';

abstract class GithubPageContract {
  loadConfig(GithubConfig config);

  saveConfigSuccess();

  showError(String errorMsg);
}

class GithubPagePresenter {
  GithubPageContract _view;

  GithubPagePresenter(this._view);

  doLoadConfig() async {
    try {
      var sql = Sql.setTable('pb_setting');
      var pbsettingRow = (await sql.getBySql('type = ?', ['github']))?.first;
      if (pbsettingRow != null &&
          (pbsettingRow["config"] != null || pbsettingRow["config"] != '')) {
        GithubConfig config = GithubConfig.fromJson(json.decode(pbsettingRow["config"]));
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
        var sql = Sql.setTable('pb_setting');
        int raw = await sql
            .rawUpdate('config = ? WHERE type = ?', [jsondata, 'github']);
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
}
