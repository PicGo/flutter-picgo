import 'package:flutter_picgo/model/uploaded.dart';
import 'dart:io';

import 'package:flutter_picgo/utils/strategy/image_upload_strategy.dart';

class TcyunImageUpload implements ImageUploadStrategy {
  @override
  Future<Uploaded> delete(Uploaded uploaded) {
    throw UnimplementedError();
  }

  @override
  Future<Uploaded> upload(File file, String renameImage) {
    throw UnimplementedError();
  }
}
