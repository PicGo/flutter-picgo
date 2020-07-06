import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_picgo/api/qiniu_api.dart';
import 'package:flutter_picgo/model/qiniu_config.dart';
import 'package:flutter_picgo/model/uploaded.dart';
import 'package:flutter_picgo/resources/pb_type_keys.dart';
import 'package:flutter_picgo/utils/image_upload.dart';
import 'dart:io';
import 'package:flutter_picgo/utils/strategy/image_upload_strategy.dart';
import 'package:flutter_picgo/utils/strings.dart';

class QiniuImageUpload extends ImageUploadStrategy {
  @override
  Future<Uploaded> delete(Uploaded uploaded) async {
    String infoStr = await ImageUploadUtils.getUploadedItemInfo(uploaded.id);
    QiniuuploadedInfo info;
    try {
      info = QiniuuploadedInfo.fromJson(json.decode(infoStr));
    } catch (e) {}
    if (info != null) {}
    return uploaded;
  }

  @override
  Future<Uploaded> upload(File file, String renameImage) async {
    try {
      String configStr = await ImageUploadUtils.getPBConfig(PBTypeKeys.qiniu);
      if (isBlank(configStr)) {
        throw QiniuError(error: '读取配置文件错误！请重试');
      }
      QiniuConfig config = QiniuConfig.fromJson(json.decode(configStr));
      // putPolicy
      String resourceKey = path.joinAll([config.path ?? '', renameImage]);
      String putPolicy = QiniuApi.generatePutPolicy(config.bucket, resourceKey);
      String upToken = QiniuApi.generateUpToken(
          config.accessKey, config.secretKey, putPolicy);
      var result = await QiniuApi.upload(
          config.area,
          FormData.fromMap({
            "key": resourceKey,
            "token": upToken,
            "fileName": renameImage,
            "file":
                await MultipartFile.fromFile(file.path, filename: renameImage),
          }),
          {
            "Authorization": 'UpToken $upToken',
          });
      var uploadedItem = Uploaded(
          -1,
          '${path.join(config.url, result["key"])}${config.options}',
          PBTypeKeys.qiniu,
          info: json.encode(
              QiniuuploadedInfo(hash: result["hash"], key: result["key"])));
      await ImageUploadUtils.saveUploadedItem(uploadedItem);
      return uploadedItem;
    } on DioError catch (e) {
      debugPrint(e.response.data);
      if (e.type == DioErrorType.RESPONSE &&
          e.error.toString().indexOf('400') > 0) {
        throw QiniuError(error: '400 请求报文格式错误');
      } else if (e.type == DioErrorType.RESPONSE &&
          e.error.toString().indexOf('401') > 0) {
        throw QiniuError(error: '401 管理凭证无效');
      } else if (e.type == DioErrorType.RESPONSE &&
          e.error.toString().indexOf('599') > 0) {
        throw QiniuError(error: '599 服务端操作失败');
      } else if (e.type == DioErrorType.RESPONSE &&
          e.error.toString().indexOf('612') > 0) {
        throw QiniuError(error: '612 待删除资源不存在');
      } else {
        throw e;
      }
    }
  }
}

/// SMMSError describes the error info  when request failed.
class QiniuError implements Exception {
  QiniuError({
    this.error,
  });

  dynamic error;

  String get message => (error?.toString() ?? '');

  @override
  String toString() {
    var msg = 'QiniuError $message';
    if (error is Error) {
      msg += '\n${error.stackTrace}';
    }
    return msg;
  }
}

class QiniuuploadedInfo {
  String hash;
  String key;

  QiniuuploadedInfo({this.hash, this.key});

  QiniuuploadedInfo.fromJson(Map<String, dynamic> json) {
    hash = json['hash'];
    key = json['key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hash'] = this.hash;
    data['key'] = this.key;
    return data;
  }
}
