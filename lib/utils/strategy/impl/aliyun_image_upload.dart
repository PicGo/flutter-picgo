import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picgo/api/aliyun_api.dart';
import 'package:flutter_picgo/model/aliyun_config.dart';
import 'package:flutter_picgo/model/uploaded.dart';
import 'package:flutter_picgo/resources/pb_type_keys.dart';
import 'package:flutter_picgo/utils/image_upload.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:flutter_picgo/utils/strategy/image_upload_strategy.dart';
import 'package:flutter_picgo/utils/strings.dart';

class AliyunImageUpload implements ImageUploadStrategy {
  @override
  Future<Uploaded> delete(Uploaded uploaded) async {
    AliyunUploadedInfo info;
    try {
      info = AliyunUploadedInfo.fromJson(json.decode(uploaded.info));
    } catch (e) {}
    if (info != null) {
      String auth = AliyunApi.buildSignature(info.accessKeyId,
          info.accessKeySecret, 'delete', info.bucket, info.object);
      await AliyunApi.deleteObject(info.bucket, info.area, info.object, auth);
    }
    return uploaded;
  }

  @override
  Future<Uploaded> upload(File file, String renameImage) async {
    String configStr = await ImageUploadUtils.getPBConfig(PBTypeKeys.aliyun);
    if (isBlank(configStr)) {
      throw AliyunError(error: '读取配置文件错误！请重试');
    }
    AliyunConfig config = AliyunConfig.fromJson(json.decode(configStr));
    String objectPath = isBlank(config.path)
        ? renameImage
        : path.joinAll([config.path, renameImage]);
    String policy = AliyunApi.buildEncodePolicy(objectPath);
    await AliyunApi.postObject(
        config.bucket,
        config.area,
        FormData.fromMap({
          'key': objectPath,
          'OSSAccessKeyId': config.accessKeyId,
          'policy': policy,
          'Signature': AliyunApi.buildPostSignature(
              config.accessKeyId, config.accessKeySecret, policy),
          'file': await MultipartFile.fromFile(file.path, filename: renameImage),
          // OSS支持用户在Post请求体中增加x-oss-content-type，该项允许用户指定Content-Type
          'x-oss-content-type': 'image/${path.extension(renameImage).replaceFirst('.', '')}'
        }));
    String imgPath = path.joinAll([
      isBlank(config.customUrl)
          ? 'https://${config.bucket}.${config.area}.aliyuncs.com'
          : config.customUrl,
      objectPath
    ]);
    var uploadedItem = Uploaded(
        -1, '$imgPath${config.options ?? ''}', PBTypeKeys.aliyun,
        info: json.encode(AliyunUploadedInfo(
            accessKeyId: config.accessKeyId,
            accessKeySecret: config.accessKeySecret,
            area: config.area,
            bucket: config.bucket,
            object: objectPath)));
    await ImageUploadUtils.saveUploadedItem(uploadedItem);
    return uploadedItem;
  }
}

class AliyunError implements Exception {
  AliyunError({
    this.error,
  });

  dynamic error;

  String get message => (error?.toString() ?? '');

  @override
  String toString() {
    var msg = 'AliyunError $message';
    if (error is Error) {
      msg += '\n${error.stackTrace}';
    }
    return msg;
  }
}

class AliyunUploadedInfo {
  String accessKeyId;
  String accessKeySecret;
  String area;
  String bucket;
  String object;

  AliyunUploadedInfo(
      {this.accessKeyId,
      this.accessKeySecret,
      this.area,
      this.bucket,
      this.object});

  AliyunUploadedInfo.fromJson(Map<String, dynamic> json) {
    accessKeyId = json['accessKeyId'];
    accessKeySecret = json['accessKeySecret'];
    area = json['area'];
    bucket = json['bucket'];
    object = json['object'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accessKeyId'] = this.accessKeyId;
    data['accessKeySecret'] = this.accessKeySecret;
    data['area'] = this.area;
    data['bucket'] = this.bucket;
    data['object'] = this.object;
    return data;
  }
}
