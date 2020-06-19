import 'dart:io';
import 'package:flutter_picgo/model/uploaded.dart';
import 'package:flutter_picgo/resources/table_name_keys.dart';
import 'package:flutter_picgo/utils/sql.dart';

abstract class AlbumPageContract {

  void loadUploadedImages(List<Uploaded> uploadeds);

}

class AlbumPagePresenter {

  AlbumPageContract _view;

  AlbumPagePresenter(this._view);

  doLoadUploadedImages() {
    var sql = Sql.setTable(TABLE_NAME_UPLOADED);

  }

}