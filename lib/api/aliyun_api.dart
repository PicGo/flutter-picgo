import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter_picgo/utils/net.dart';
import 'package:flutter_picgo/utils/strings.dart';

class AliyunApi {
  // 还需要拼接buckername 例如zjyzy.oss-cn-shenzhen.aliyuncs.com
  static const BASE_URL = 'aliyuncs.com';

  static postObject(String bucket, String aera, FormData data) async {
    Response res = await NetUtils.getInstance().post(
      'https://$bucket.$aera.aliyuncs.com',
      data: data,
    );
    return res.headers;
  }

  static deleteObject(
      String bucket, String aera, String object, String auth) async {
    Response res = await NetUtils.getInstance()
        .delete('https://$bucket.$aera.aliyuncs.com/$object',
            options: Options(headers: {
              'Authorization': auth,
              'Date': HttpDate.format(new DateTime.now()),
            }));
    return res.headers;
  }

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

  /// form policy
  static String buildEncodePolicy(String objectName) {
    var policyText = {
      "expiration":
          "2030-01-01T00:00:00.000Z", // 设置Policy的失效时间，如果超过失效时间，就无法通过此Policy上传文件
      "conditions": [
        {
          "key": objectName,
        } // 设置上传文件的大小限制，如果超过限制，文件上传到OSS会报错
      ]
    };
    var encodePolicy = base64.encode(utf8.encode(json.encode(policyText)));
    return encodePolicy;
  }

  /// Form Authorization
  static String buildPostSignature(
      String accessKeyId, String accessKeySecret, String encodePolicy) {
    // 使用SecertKey对上一步生成的原始字符串计算HMAC-SHA1签名：
    var hmacsha1 = Hmac(sha1, utf8.encode(accessKeySecret));
    var sign = hmacsha1.convert(utf8.encode(encodePolicy));
    var encodeSign = base64.encode(sign.bytes);
    return encodeSign;
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
