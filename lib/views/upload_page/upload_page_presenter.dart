import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_picgo/model/github_config.dart';
import 'package:flutter_picgo/resources/table_name_keys.dart';
import 'package:flutter_picgo/utils/encrypt.dart';
import 'package:flutter_picgo/utils/github_net.dart';
import 'package:flutter_picgo/utils/shared_preferences.dart';
import 'package:flutter_picgo/utils/sql.dart';
import 'package:path/path.dart' as path;

abstract class UploadPageContract {
  loadCurrentPB(String pbname);
  uploadSuccess(String url);
  uploadFaild(String errorMsg);
}

class UploadPagePresenter {
  UploadPageContract _view;

  UploadPagePresenter(this._view);

  /// 读取当前默认图床
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

  /// 根据配置上传图片
  doUploadImage(File file, String renameImage) async {
    // 读取配置
    try {
      var sp = await SpUtil.getInstance();
      String pbType = sp.getDefaultPB();
      var sql = Sql.setTable(TABLE_NAME_PBSETTING);
      var pbsettingRow = (await sql.getBySql('type = ?', [pbType]))?.first;
      if (pbsettingRow != null &&
          pbsettingRow["config"] != null &&
          pbsettingRow["config"] != '') {
        GithubConfig config =
            GithubConfig.fromJson(json.decode(pbsettingRow["config"]));
        String realUrl = path.joinAll([
          'repos',
          config.repositoryName,
          'contents',
          config.storagePath,
          renameImage
        ]);
        var result = await GithubNetUtils.put(realUrl, {
          "message": "Upload by Flutter-PicGo",
          "content": await EncryptUtils.image2Base64(file.path),
          "branch": config.branchName
        });
        String imagePath = result["content"]["path"];
        String downloadUrl = result["content"]["download_url"];
        _view.uploadSuccess(
            config.customDomain == null || config.customDomain == ''
                ? downloadUrl
                : '${path.joinAll([config.customDomain, imagePath])}');
      } else {
        _view.uploadFaild('读取配置错误，请重试!');
      }
    } on DioError catch (e) {
      debugPrint(e.message);
      _view.uploadFaild('${e.message}');
    } catch (e) {
      _view.uploadFaild('未知异常');
    }
  }
}
