import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_picgo/api/gitcode_api.dart';
import 'package:flutter_picgo/model/gitcode_config.dart';
import 'package:flutter_picgo/model/uploaded.dart';
import 'package:flutter_picgo/resources/pb_type_keys.dart';
import 'package:flutter_picgo/utils/encrypt.dart';
import 'package:flutter_picgo/utils/image_upload.dart';
import 'package:flutter_picgo/utils/strings.dart';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:flutter_picgo/utils/strategy/image_upload_strategy.dart';

class GitcodeImageUpload implements ImageUploadStrategy {
  static const UPLOAD_COMMIT_MESSAGE = "Upload by Flutter-PicGo";
  static const DELETE_COMMIT_MESSAGE = "Delete by Flutter-PicGo";

  @override
  Future<Uploaded> delete(Uploaded uploaded) async {
    GitcodeUploadedInfo info;
    try {
      info = GitcodeUploadedInfo.fromJson(json.decode(uploaded.info));
    } catch (e) {}
    if (info != null) {
      String realUrl =
          path.joinAll(['repos', info.ownerrepo, 'contents', info.path]);
      Map<String, dynamic> mapData = {
        "message": DELETE_COMMIT_MESSAGE,
        "sha": info.sha,
      };
      if (!isBlank(info.branch)) {
        mapData["branch"] = info.branch;
      }
      await GitcodeApi.deleteFile(realUrl, mapData);
    }
    return uploaded;
  }

  @override
  Future<Uploaded> upload(File file, String renameImage) async {
    try {
      String configStr =
          await ImageUploadUtils.getPBConfig(PBTypeKeys.gitcode);
      if (isBlank(configStr)) {
        throw GitcodeError(error: '读取配置文件错误！请重试');
      }
      GitcodeConfig config = GitcodeConfig.fromJson(json.decode(configStr));
      String realUrl = path.joinAll([
        'repos',
        config.owner,
        config.repo,
        'contents',
        config.path,
        renameImage
      ]);
      Map<String, dynamic> mapData = {
        "message": UPLOAD_COMMIT_MESSAGE,
        "content": await EncryptUtils.image2Base64(file.path)
      };
      if (!isBlank(config.branch)) {
        mapData["branch"] = config.branch;
      }
      var result = await GitcodeApi.createFile(realUrl, mapData);
      String branch = isBlank(config.branch) ? 'master' : config.branch;
      var content = result == null ? null : result["content"];
      String imagePath = content != null
          ? content["path"]
          : path.joinAll(
              [if (!isBlank(config.path)) config.path, renameImage]);
      String sha = content != null
          ? content["sha"]
          : (result["commit"] == null ? null : result["commit"]["sha"]);
      String downloadUrl =
          (content != null && !isBlank(content["download_url"]))
              ? content["download_url"]
              : 'https://gitcode.com/${config.owner}/${config.repo}/raw/$branch/$imagePath';
      String imageUrl = config.customUrl == null || config.customUrl == ''
          ? downloadUrl
          : '${path.joinAll([config.customUrl, imagePath])}';
      var uploadedItem = Uploaded(-1, imageUrl, PBTypeKeys.gitcode,
          info: json.encode(GitcodeUploadedInfo(
              path: imagePath,
              sha: sha,
              branch: branch,
              ownerrepo: '${config.owner}/${config.repo}')));
      await ImageUploadUtils.saveUploadedItem(uploadedItem);
      return uploadedItem;
    } on DioError catch (e) {
      if (e.type == DioErrorType.response &&
          e.error.toString().indexOf('400') > 0) {
        throw GitcodeError(error: '文件已存在！');
      } else {
        throw e;
      }
    }
  }
}

/// GitcodeError describes the error info  when request failed.
class GitcodeError implements Exception {
  GitcodeError({
    this.error,
  });

  dynamic error;

  String get message => (error?.toString() ?? '');

  @override
  String toString() {
    var msg = 'GitcodeError $message';
    if (error is Error) {
      msg += '\n${error.stackTrace}';
    }
    return msg;
  }
}

class GitcodeUploadedInfo {
  String sha;
  String branch;
  String path;
  String ownerrepo;

  GitcodeUploadedInfo({this.sha, this.branch, this.path, this.ownerrepo});

  GitcodeUploadedInfo.fromJson(Map<String, dynamic> json) {
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
