import 'package:flutter_picgo/model/uploaded.dart';
import 'package:flutter_picgo/resources/table_name_keys.dart';
import 'package:flutter_picgo/utils/image_upload.dart';
import 'package:flutter_picgo/utils/sql.dart';
import 'package:flutter_picgo/utils/strategy/upload_strategy_factory.dart';

abstract class AlbumPageContract {
  void loadUploadedImages(List<Uploaded> uploadeds);
  void loadError();

  void loadItemCount(int count);

  void deleteSuccess(Uploaded uploaded);
  void deleteError(String msg);
}

class AlbumPagePresenter {
  AlbumPageContract _view;

  AlbumPagePresenter(this._view);

  doLoadUploadedImages(int limit, int offest) async {
    try {
      var sql = Sql.setTable(TABLE_NAME_UPLOADED);
      var result = await sql.getBySql(null, null,
          limit: limit, offset: offest * limit, orderBy: 'id DESC');
      List<Uploaded> uploadeds = result.map((v) {
        return Uploaded.fromMap(v);
      }).toList();
      _view.loadUploadedImages(uploadeds);
    } catch (e) {
      print(e);
      _view.loadError();
    }
  }

  doGetItemCount() async {
    try {
      var sql = Sql.setTable(TABLE_NAME_UPLOADED);
      var result = await sql.get();
      _view.loadItemCount(result.length ?? 0);
    } catch (e) {}
  }

  doDeleteImage(Uploaded uploaded) async {
    try {
      ImageUploadUtils uploader = ImageUploadUtils(
          UploadStrategyFactory.getUploadStrategy(uploaded.type));
      Uploaded up = await uploader.delete(uploaded);
      if (up != null) {
        _view.deleteSuccess(uploaded);
      } else {
        _view.deleteError('删除出错，请重试');
      }
    } catch (e) {
      print(e);
      _view.deleteError('删除出错，请重试 Error >>> $e');
    }
  }
}
