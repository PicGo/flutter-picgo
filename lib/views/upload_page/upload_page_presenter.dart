import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_picgo/utils/image_upload.dart';
import 'package:flutter_picgo/utils/strategy/github_image_upload.dart';
import 'package:flutter_picgo/utils/strategy/upload_strategy_factory.dart';

abstract class UploadPageContract {
  loadCurrentPB(String pbname);
  uploadSuccess(String url);
  uploadFaild(String errorMsg);
}

class UploadPagePresenter {
  UploadPageContract _view;
  UploadPagePresenter(this._view);

  /// 读取当前默认图床
  doLoadCurrentPB() async {
    try {
      String pbType = await ImageUploadUtils.getDefaultPB();
      String name = await ImageUploadUtils.getPBName(pbType);
      if (name != null) {
        _view.loadCurrentPB(name);
      }
    } catch (e) {}
  }

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
      debugPrint(e.toString());
      _view.uploadFaild('${e.message}');
    } catch (e) {
      debugPrint(e.toString());
      _view.uploadFaild('$e');
    }
  }
}
