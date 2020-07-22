import 'package:dio/dio.dart';
import 'package:flutter_picgo/api/niupic_api.dart';
import 'package:flutter_picgo/model/uploaded.dart';
import 'package:flutter_picgo/resources/pb_type_keys.dart';
import 'package:flutter_picgo/utils/image_upload.dart';
import 'dart:io';

import 'package:flutter_picgo/utils/strategy/image_upload_strategy.dart';

class NiupicImageUpload implements ImageUploadStrategy {
  /// 牛图网不支持删除
  @override
  Future<Uploaded> delete(Uploaded uploaded) async {
    return uploaded;
  }

  @override
  Future<Uploaded> upload(File file, String renameImage) async {
    FormData formData = FormData.fromMap({
      "image_field":
          await MultipartFile.fromFile(file.path, filename: renameImage),
    });
    var result = await NiupicApi.upload(formData);
    if (result["code"] == 200) {
      var uploadedItem = Uploaded(
          -1, 'https://${result['data']}', PBTypeKeys.niupic,
          info: '');
      await ImageUploadUtils.saveUploadedItem(uploadedItem);
      return uploadedItem;
    } else {
      throw new NiupicError(error: '${result['msg']}');
    }
  }
}

class NiupicError implements Exception {
  NiupicError({
    this.error,
  });

  dynamic error;

  String get message => (error?.toString() ?? '');

  @override
  String toString() {
    var msg = 'NiupicError $message';
    if (error is Error) {
      msg += '\n${error.stackTrace}';
    }
    return msg;
  }
}
