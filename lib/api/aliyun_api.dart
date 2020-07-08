import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter_picgo/utils/strings.dart';

class AliyunApi {
  // 还需要拼接buckername 例如zjyzy.oss-cn-shenzhen.aliyuncs.com
  // static const BASE_URL = 'oss-cn-shenzhen.aliyuncs.com';

  /// Content-MD5的计算
  static String generateContentMD5(String content) {
    // 先计算MD5加密的二进制数组
    var digest = md5.convert(utf8.encode(content));
    return base64.encode(digest.bytes);
  }

  /// 构建CanonicalizedResource
  static String buildCanonicalizedResource(
      String bucketName, String objectName) {
    if (isBlank(bucketName)) {
      return '/';
    }
    if (isBlank(objectName)) {
      return '/$bucketName/';
    } else {
      return '/$bucketName/$objectName';
    }
  }

  /// Authorization
  static String buildSignature(String accessKeyId, String accessKeySecret,
      String verb, String bucketName, String objectName,
      {String contentMd5 = '', String contentType = ''}) {
    var canonicalizedResource =
        buildCanonicalizedResource(bucketName, objectName);
    var date = HttpDate.format(new DateTime.now());
    var originSign =
        '${verb.toUpperCase()}\n$contentMd5\n$contentType\n$date\n$canonicalizedResource';
    // 使用SecertKey对上一步生成的原始字符串计算HMAC-SHA1签名：
    var hmacsha1 = Hmac(sha1, utf8.encode(accessKeySecret));
    var sign = hmacsha1.convert(utf8.encode(originSign));
    var encodeSign = base64.encode(sign.bytes);
    return 'OSS $accessKeyId:$encodeSign';
  }
}
