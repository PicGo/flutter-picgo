import 'package:flutter_picgo/resources/pb_type_keys.dart';
import 'package:flutter_picgo/utils/strategy/impl/aliyun_image_upload.dart';
import 'package:flutter_picgo/utils/strategy/impl/gitee_image_upload.dart';
import 'package:flutter_picgo/utils/strategy/impl/github_image_upload.dart';
import 'package:flutter_picgo/utils/strategy/image_upload_strategy.dart';
import 'package:flutter_picgo/utils/strategy/impl/qiniu_image_upload.dart';
import 'package:flutter_picgo/utils/strategy/impl/smms_image_upload.dart';
import 'package:flutter_picgo/utils/strings.dart';

class UploadStrategyFactory {
  static Map<String, ImageUploadStrategy> cache = {};

  /// UploadStrategy工厂类，负责创建UploadStrategy
  static ImageUploadStrategy getUploadStrategy(String type) {
    if (isBlank(type)) {
      throw new NullThrownError();
    }
    if (cache[type] == null) {
      if (type == PBTypeKeys.github) {
        cache[type] = new GithubImageUpload();
      } else if (type == PBTypeKeys.smms) {
        cache[type] = new SMMSImageUpload();
      } else if (type == PBTypeKeys.gitee) {
        cache[type] = new GiteeImageUpload();
      } else if (type == PBTypeKeys.qiniu) {
        cache[type] = new QiniuImageUpload();
      } else if (type == PBTypeKeys.aliyun) {
        cache[type] = new AliyunImageUpload();
      }
    }
    return cache[type];
  }
}
