import 'package:dio/dio.dart';
import 'package:flutter_picgo/model/github_config.dart';
import 'package:flutter_picgo/model/uploaded.dart';
import 'package:flutter_picgo/resources/pb_type_keys.dart';
import 'package:flutter_picgo/resources/table_name_keys.dart';
import 'package:flutter_picgo/utils/encrypt.dart';
import 'package:flutter_picgo/utils/github_net.dart';
import 'package:flutter_picgo/utils/image_upload.dart';
import 'package:flutter_picgo/utils/sql.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as path;
import 'package:flutter_picgo/utils/strategy/image_upload_strategy.dart';

class GithubImageUpload implements ImageUploadStrategy {
  static const UPLOAD_COMMIT_MESSAGE = "Upload by Flutter-PicGo";
  static const DELETE_COMMIT_MESSAGE = "Delete by Flutter-PicGo";

  @override
  Future<Uploaded> delete(Uploaded uploaded) async {
    String infoStr = await ImageUploadUtils.getUploadedItemInfo(uploaded.id);
    GithubUploadedInfo info;
    try {
      info = GithubUploadedInfo.fromJson(json.decode(infoStr));
    } catch (e) {}
    if (info != null) {
      String realUrl = path.joinAll([
        'repos',
        info.ownerrepo,
        'contents',
        info.path
      ]);
      await GithubNetUtils.delete(realUrl, {
        "message": DELETE_COMMIT_MESSAGE,
        "sha": info.sha,
        "branch": info.branch
      });
    }
    return uploaded;
  }

  @override
  Future<Uploaded> upload(File file, String renameImage) async {
    try {
      var sql = Sql.setTable(TABLE_NAME_PBSETTING);
      var pbsettingRow =
          (await sql.getBySql('type = ?', [PBTypeKeys.github]))?.first;
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
          "message": UPLOAD_COMMIT_MESSAGE,
          "content": await EncryptUtils.image2Base64(file.path),
          "branch": config.branchName
        });
        String imagePath = result["content"]["path"];
        String downloadUrl = result["content"]["download_url"];
        String sha = result["content"]["sha"];
        String imageUrl =
            config.customDomain == null || config.customDomain == ''
                ? downloadUrl
                : '${path.joinAll([config.customDomain, imagePath])}';
        var uploadedItem = Uploaded(-1, imageUrl, PBTypeKeys.github,
            info: json.encode(GithubUploadedInfo(
                path: imagePath, sha: sha, branch: config.branchName, ownerrepo: config.repositoryName)));
        await ImageUploadUtils.saveUploadedItem(uploadedItem);
        return uploadedItem;
      } else {
        throw GithubError(error: '读取配置文件错误！请重试');
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.RESPONSE &&
          e.error.toString().indexOf('422') > 0) {
        throw GithubError(error: '文件已存在！');
      } else {
        throw e;
      }
    }
  }
}

/// GithubError describes the error info  when request failed.
class GithubError implements Exception {
  GithubError({
    this.error,
  });

  dynamic error;

  String get message => (error?.toString() ?? '');

  @override
  String toString() {
    var msg = 'GithubError $message';
    if (error is Error) {
      msg += '\n${error.stackTrace}';
    }
    return msg;
  }
}

class GithubUploadedInfo {
  String sha;
  String branch;
  String path;
  String ownerrepo;

  GithubUploadedInfo({this.sha, this.branch, this.path, this.ownerrepo});

  GithubUploadedInfo.fromJson(Map<String, dynamic> json) {
    sha = json['sha'];
    branch = json['branch'];
    path = json['path'];
    ownerrepo = json['ownerrepo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sha'] = this.sha;
    data['branch'] = this.branch;
    data['path'] = this.path;
    data['ownerrepo'] = this.ownerrepo;
    return data;
  }
}
