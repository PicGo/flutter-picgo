import 'package:flutter_picgo/resources/pb_type_keys.dart';
import 'package:flutter_picgo/utils/strategy/impl/aliyun_image_upload.dart';
import 'package:flutter_picgo/utils/strategy/impl/gitee_image_upload.dart';
import 'package:flutter_picgo/utils/strategy/impl/github_image_upload.dart';
import 'package:flutter_picgo/utils/strategy/image_upload_strategy.dart';
import 'package:flutter_picgo/utils/strategy/impl/qiniu_image_upload.dart';
import 'package:flutter_picgo/utils/strategy/impl/smms_image_upload.dart';
import 'package:flutter_picgo/utils/strings.dart';

class UploadStrategyFactory {
  /// UploadStrategy工厂类，负责创建UploadStrategy
  static ImageUploadStrategy getUploadStrategy(String type) {
    if (isBlank(type)) {
      throw new NullThrownError();
    }
    if (type == PBTypeKeys.github) {
      return new GithubImageUpload();
    } else if (type == PBTypeKeys.smms) {
      return new SMMSImageUpload();
    } else if (type == PBTypeKeys.gitee) {
      return new GiteeImageUpload();
    } else if (type == PBTypeKeys.qiniu) {
      return new QiniuImageUpload();
    } else if (type == PBTypeKeys.aliyun) {
      return new AliyunImageUpload();
    }
    return null;
  }
}
