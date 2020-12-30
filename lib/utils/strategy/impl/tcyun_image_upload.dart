import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_picgo/api/tcyun_api.dart';
import 'package:flutter_picgo/model/tcyun_config.dart';
import 'package:flutter_picgo/model/uploaded.dart';
import 'package:flutter_picgo/resources/pb_type_keys.dart';
import 'package:flutter_picgo/utils/image_upload.dart';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:flutter_picgo/utils/strategy/image_upload_strategy.dart';
import 'package:flutter_picgo/utils/strings.dart';

class TcyunImageUpload implements ImageUploadStrategy {
  @override
  Future<Uploaded> delete(Uploaded uploaded) async {
    TcyunUploaddedInfo info;
    try {
      info = TcyunUploaddedInfo.fromJson(json.decode(uploaded.info));
    } catch (e) {}
    if (info != null) {
      await TcyunApi.deleteobject(
          info.secretId, info.secretKey, info.bucket, info.area, info.key);
    }
    return uploaded;
  }

  @override
  Future<Uploaded> upload(File file, String renameImage) async {
    String configStr = await ImageUploadUtils.getPBConfig(PBTypeKeys.tcyun);
    if (isBlank(configStr)) {
      throw TcyunError(error: '读取配置文件错误！请重试');
    }
    TcyunConfig config = TcyunConfig.fromJson(json.decode(configStr));
    String objectPath = isBlank(config.path)
        ? renameImage
        : path.joinAll([config.path, renameImage]);

    /// post
    String keyTime = TcyunApi.buildKeyTime();
    String policy = TcyunApi.buildPolicy(
        config.bucket, objectPath, config.secretId, keyTime);
    FormData formData = FormData.fromMap({
      "key": objectPath,
      "file": await MultipartFile.fromFile(file.path, filename: renameImage),
      "policy": base64.encode(utf8.encode(policy)),
      "q-sign-algorithm": "sha1",
      "q-ak": config.secretId,
      "q-key-time": keyTime,
      "q-sign-time": keyTime,
      "q-signature": TcyunApi.buildSignature(config.secretKey, keyTime, policy)
    });
    await TcyunApi.postObject(
        config.secretId,
        config.secretKey,
        config.bucket,
        config.area,
        path.extension(renameImage).replaceFirst('.', ''),
        formData);
    String imgPath = path.joinAll([
      isBlank(config.customUrl)
          ? 'https://${config.bucket}.cos.${config.area}.myqcloud.com'
          : config.customUrl,
      objectPath
    ]);
    var uploadedItem = Uploaded(-1, '$imgPath', PBTypeKeys.tcyun,
        info: json.encode(TcyunUploaddedInfo(
            secretId: config.secretId,
            secretKey: config.secretKey,
            area: config.area,
            key: objectPath,
            bucket: config.bucket)));
    await ImageUploadUtils.saveUploadedItem(uploadedItem);
    return uploadedItem;
  }
}

class TcyunError implements Exception {
  TcyunError({
    this.error,
  });

  dynamic error;

  String get message => (error?.toString() ?? '');

  @override
  String toString() {
    var msg = 'TcyunError $message';
    if (error is Error) {
      msg += '\n${error.stackTrace}';
    }
    return msg;
  }
}

class TcyunUploaddedInfo {
  String area;
  String bucket;
  String secretId;
  String secretKey;
  String key;

  TcyunUploaddedInfo(
      {this.area, this.bucket, this.secretId, this.secretKey, this.key});

  TcyunUploaddedInfo.fromJson(Map<String, dynamic> json) {
    area = json['area'];
    bucket = json['bucket'];
    secretId = json['secretId'];
    secretKey = json['secretKey'];
    key = json['key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['area'] = this.area;
    data['bucket'] = this.bucket;
    data['secretId'] = this.secretId;
    data['secretKey'] = this.secretKey;
    data['key'] = this.key;
    return data;
  }
}
