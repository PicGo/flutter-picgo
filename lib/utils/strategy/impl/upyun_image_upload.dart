import 'dart:convert';

import 'package:flutter_picgo/api/upyun_api.dart';
import 'package:flutter_picgo/model/uploaded.dart';
import 'package:flutter_picgo/model/upyun_config.dart';
import 'package:flutter_picgo/resources/pb_type_keys.dart';
import 'package:flutter_picgo/utils/image_upload.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter_picgo/utils/strategy/image_upload_strategy.dart';
import 'package:flutter_picgo/utils/strings.dart';

class UpyunImageUpload implements ImageUploadStrategy {
  @override
  Future<Uploaded> delete(Uploaded uploaded) async {
    UpyunUploadedInfo info;
    try {
      info = UpyunUploadedInfo.fromJson(json.decode(uploaded.info));
    } catch (e) {}
    if (info != null) {
      await UpyunApi.deleteObject(
          info.bucket, info.operator, info.password, info.key);
    }
    return uploaded;
  }

  @override
  Future<Uploaded> upload(File file, String renameImage) async {
    String configStr = await ImageUploadUtils.getPBConfig(PBTypeKeys.upyun);
    if (isBlank(configStr)) {
      throw UpyunError(error: '读取配置文件错误！请重试');
    }
    UpyunConfig config = UpyunConfig.fromJson(json.decode(configStr));
    await UpyunApi.putObject(
        file, config.operator, config.password, renameImage, config.bucket,
        path: config.path);
    String wholeKey = joinAll([config.path ?? '', renameImage]);
    String imagePath =
        joinAll([config.url, '$wholeKey${config.options ?? ''}']);
    var uploadedItem = Uploaded(-1, '$imagePath', PBTypeKeys.upyun,
        info: json.encode(UpyunUploadedInfo(
          operator: config.operator,
          password: config.password,
          bucket: config.bucket,
          key: wholeKey,
        )));
    await ImageUploadUtils.saveUploadedItem(uploadedItem);
    return uploadedItem;
  }
}

class UpyunError implements Exception {
  UpyunError({
    this.error,
  });

  dynamic error;

  String get message => (error?.toString() ?? '');

  @override
  String toString() {
    var msg = 'UpyunError $message';
    if (error is Error) {
      msg += '\n${error.stackTrace}';
    }
    return msg;
  }
}

class UpyunUploadedInfo {
  String operator;
  String bucket;
  String password;
  String key;

  UpyunUploadedInfo({this.operator, this.bucket, this.password, this.key});

  UpyunUploadedInfo.fromJson(Map<String, dynamic> json) {
    operator = json['operator'];
    bucket = json['bucket'];
    password = json['password'];
    key = json['key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['operator'] = this.operator;
    data['bucket'] = this.bucket;
    data['password'] = this.password;
    data['key'] = this.key;
    return data;
  }
}
