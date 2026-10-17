import 'package:dio/dio.dart';
import 'package:flutter_picgo/api/codeberg_api.dart';
import 'package:flutter_picgo/model/codeberg_config.dart';
import 'package:flutter_picgo/model/uploaded.dart';
import 'package:flutter_picgo/resources/pb_type_keys.dart';
import 'package:flutter_picgo/utils/encrypt.dart';
import 'package:flutter_picgo/utils/image_upload.dart';
import 'package:flutter_picgo/utils/strings.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as path;
import 'package:flutter_picgo/utils/strategy/image_upload_strategy.dart';

class CodebergImageUpload implements ImageUploadStrategy {
  static const UPLOAD_COMMIT_MESSAGE = "Upload by Flutter-PicGo";
  static const DELETE_COMMIT_MESSAGE = "Delete by Flutter-PicGo";

  @override
  Future<Uploaded> delete(Uploaded uploaded) async {
    CodebergUploadedInfo info;
    try {
      info = CodebergUploadedInfo.fromJson(json.decode(uploaded.info));
    } catch (e) {}
    if (info != null) {
      String realUrl =
          path.joinAll(['repos', info.ownerrepo, 'contents', info.path]);
      await CodebergApi.deleteContent(realUrl, {
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
      String configStr =
          await ImageUploadUtils.getPBConfig(PBTypeKeys.codeberg);
      if (!isBlank(configStr)) {
        CodebergConfig config = CodebergConfig.fromJson(json.decode(configStr));
        String realUrl = path.joinAll(
            ['repos', config.repo, 'contents', config.path, renameImage]);
        var result = await CodebergApi.postContent(realUrl, {
          "message": UPLOAD_COMMIT_MESSAGE,
          "content": await EncryptUtils.image2Base64(file.path),
          "branch": config.branch
        });
        String imagePath = result["content"]["path"];
        String downloadUrl = result["content"]["download_url"];
        String sha = result["content"]["sha"];
        String imageUrl = isBlank(config.customUrl)
            ? downloadUrl
            : '${path.joinAll([config.customUrl, imagePath])}';
        var uploadedItem = Uploaded(-1, imageUrl, PBTypeKeys.codeberg,
            info: json.encode(CodebergUploadedInfo(
                path: imagePath,
                sha: sha,
                branch: config.branch,
                ownerrepo: config.repo)));
        await ImageUploadUtils.saveUploadedItem(uploadedItem);
        return uploadedItem;
      } else {
        throw CodebergError(error: '读取配置文件错误！请重试');
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.response &&
          e.error.toString().indexOf('422') > 0) {
        throw CodebergError(error: '文件已存在！');
      } else {
        throw e;
      }
    }
  }
}

/// CodebergError describes the error info when request failed.
class CodebergError implements Exception {
  CodebergError({
    this.error,
  });

  dynamic error;

  String get message => (error?.toString() ?? '');

  @override
  String toString() {
    var msg = 'CodebergError $message';
    if (error is Error) {
      msg += '\n${error.stackTrace}';
    }
    return msg;
  }
}

class CodebergUploadedInfo {
  String sha;
  String branch;
  String path;
  String ownerrepo;

  CodebergUploadedInfo({this.sha, this.branch, this.path, this.ownerrepo});

  CodebergUploadedInfo.fromJson(Map<String, dynamic> json) {
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
