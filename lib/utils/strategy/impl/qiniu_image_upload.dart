import 'package:flutter_picgo/model/uploaded.dart';
import 'dart:io';
import 'package:flutter_picgo/utils/strategy/image_upload_strategy.dart';

class QiniuImageUpload extends ImageUploadStrategy {
  @override
  Future<Uploaded> delete(Uploaded uploaded) {
    return null;
  }

  @override
  Future<Uploaded> upload(File file, String renameImage) {
    return null;
  }
}
