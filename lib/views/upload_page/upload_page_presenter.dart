import 'package:flutter_picgo/resources/table_name_keys.dart';
import 'package:flutter_picgo/utils/shared_preferences.dart';
import 'package:flutter_picgo/utils/sql.dart';

abstract class UploadPageContract {
  loadCurrentPB(String pbname);
}

class UploadPagePresenter {
  UploadPageContract _view;

  UploadPagePresenter(this._view);

  doLoadCurrentPB() async {
    try {
      var sp = await SpUtil.getInstance();
      String pbType = sp.getDefaultPB();
      var sql = Sql.setTable(TABLE_NAME_PBSETTING);
      var pbsettingRow = (await sql.getBySql('type = ?', [pbType]))?.first;
      if (pbsettingRow != null &&
          pbsettingRow["name"] != null &&
          pbsettingRow["name"] != '') {
        _view.loadCurrentPB(pbsettingRow["name"]);
      }
    } catch (e) {}
  }
}
