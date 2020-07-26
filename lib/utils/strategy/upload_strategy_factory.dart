import 'package:flutter_picgo/resources/pb_type_keys.dart';
import 'package:flutter_picgo/utils/strategy/impl/aliyun_image_upload.dart';
import 'package:flutter_picgo/utils/strategy/impl/gitee_image_upload.dart';
import 'package:flutter_picgo/utils/strategy/impl/github_image_upload.dart';
import 'package:flutter_picgo/utils/strategy/image_upload_strategy.dart';
import 'package:flutter_picgo/utils/strategy/impl/lsky_image_upload.dart';
import 'package:flutter_picgo/utils/strategy/impl/niupic_image_upload.dart';
import 'package:flutter_picgo/utils/strategy/impl/qiniu_image_upload.dart';
import 'package:flutter_picgo/utils/strategy/impl/smms_image_upload.dart';
import 'package:flutter_picgo/utils/strategy/impl/tcyun_image_upload.dart';
import 'package:flutter_picgo/utils/strategy/impl/upyun_image_upload.dart';
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
        /// Github
        cache[type] = new GithubImageUpload();
      } else if (type == PBTypeKeys.smms) {
        /// SM.MS
        cache[type] = new SMMSImageUpload();
      } else if (type == PBTypeKeys.gitee) {
        /// Gitee
        cache[type] = new GiteeImageUpload();
      } else if (type == PBTypeKeys.qiniu) {
        /// 七牛
        cache[type] = new QiniuImageUpload();
      } else if (type == PBTypeKeys.aliyun) {
        /// 阿里云
        cache[type] = new AliyunImageUpload();
      } else if (type == PBTypeKeys.tcyun) {
        /// 腾讯云
        cache[type] = new TcyunImageUpload();
      } else if (type == PBTypeKeys.niupic) {
        /// 牛图网
        cache[type] = new NiupicImageUpload();
      } else if (type == PBTypeKeys.lsky) {
        /// 兰空
        cache[type] = new LskyImageUpload();
      } else if (type == PBTypeKeys.upyun) {
        /// 又拍云
        cache[type] = new UpyunImageUpload();
      }
    }
    return cache[type];
  }
}
