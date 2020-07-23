import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_picgo/api/lsky_api.dart';
import 'package:flutter_picgo/model/lsky_config.dart';
import 'package:flutter_picgo/model/uploaded.dart';
import 'package:flutter_picgo/resources/pb_type_keys.dart';
import 'package:flutter_picgo/utils/image_upload.dart';
import 'dart:io';

import 'package:flutter_picgo/utils/strategy/image_upload_strategy.dart';
import 'package:flutter_picgo/utils/strings.dart';

class LskyImageUpload implements ImageUploadStrategy {
  @override
  Future<Uploaded> delete(Uploaded uploaded) async {
    return uploaded;
  }

  @override
  Future<Uploaded> upload(File file, String renameImage) async {
    String configStr = await ImageUploadUtils.getPBConfig(PBTypeKeys.lsky);
    if (isBlank(configStr)) {
      throw LskyError(error: '读取配置文件错误！请重试');
    }
    LskyConfig config = LskyConfig.fromJson(json.decode(configStr));
    FormData formData = FormData.fromMap({
      "image": await MultipartFile.fromFile(file.path, filename: renameImage),
    });
    var result = await LskyApi.upload(config.token, config.host, formData);
    if (result['code'] == 200) {
      var uploadedItem =
          Uploaded(-1, '${result['data']['url']}', PBTypeKeys.lsky, info: '');
      await ImageUploadUtils.saveUploadedItem(uploadedItem);
      return uploadedItem;
    } else {
      throw new LskyError(error: '${result['msg']}');
    }
  }
}

class LskyError implements Exception {
  LskyError({
    this.error,
  });

  dynamic error;

  String get message => (error?.toString() ?? '');

  @override
  String toString() {
    var msg = 'LskyError $message';
    if (error is Error) {
      msg += '\n${error.stackTrace}';
    }
    return msg;
  }
}
