import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_picgo/utils/image_upload.dart';
import 'package:flutter_picgo/utils/strategy/upload_strategy_factory.dart';

abstract class UploadItemContract {
  uploadSuccess(String url);
  uploadFaild(String errorMsg);
}

class UploadItemPresenter {
  UploadItemContract _view;
  UploadItemPresenter(this._view);

  /// 根据配置上传图片
  doUploadImage(File file, String renameImage) async {
    // 读取配置
    try {
      String pbType = await ImageUploadUtils.getDefaultPB();
      var uploader =
          ImageUploadUtils(UploadStrategyFactory.getUploadStrategy(pbType));
      var uploadedItem = await uploader.upload(file, renameImage);
      if (uploadedItem != null) {
        _view.uploadSuccess(uploadedItem.path);
      } else {
        _view.uploadFaild('上传失败！请重试');
      }
    } on DioError catch (e) {
      _view.uploadFaild('${e.message}');
    } catch (e) {
      _view.uploadFaild('$e');
    }
  }
}
