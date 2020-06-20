import 'package:flutter/cupertino.dart';
import 'package:flutter_picgo/model/uploaded.dart';
import 'package:flutter_picgo/resources/table_name_keys.dart';
import 'package:flutter_picgo/utils/sql.dart';

abstract class AlbumPageContract {
  void loadUploadedImages(List<Uploaded> uploadeds);

  void loadError();
}

class AlbumPagePresenter {
  AlbumPageContract _view;

  AlbumPagePresenter(this._view);

  doLoadUploadedImages() async {
    try {
      var sql = Sql.setTable(TABLE_NAME_UPLOADED);
      var result = await sql.get();
      debugPrint(result.toString());
      List<Uploaded> uploadeds = result.map((v) {
        return Uploaded.fromMap(v);
      }).toList();
      _view.loadUploadedImages(uploadeds);
    } catch (e) {
      print(e);
      _view.loadError();
    }
  }
}
