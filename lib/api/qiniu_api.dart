import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter_picgo/utils/net.dart';

class QiniuApi {
  static const String BASE_URL = 'http://upload.qiniup.com/';

  static Future upload(FormData data) async {
    Response res = await NetUtils.getInstance().post(BASE_URL, data: data);
    return res.data;
  }

  /// 上传凭证算法
  /// https://developer.qiniu.com/kodo/manual/1208/upload-token
  /// https://pub.flutter-io.cn/packages/crypto
  static String generateUpToken(
      String accessKey, String secretKey, String putPolicy) {
    //对 JSON 编码的上传策略进行URL 安全的 Base64 编码，得到待签名字符串：
    var encodedPutPolicy = base64Encode(utf8.encode(putPolicy));
    // 使用访问密钥（AK/SK）对上一步生成的待签名字符串计算HMAC-SHA1签名：
    var hmacsha1 = Hmac(sha1, utf8.encode(secretKey));
    var digest = hmacsha1.convert(utf8.encode(encodedPutPolicy));
    // 对签名进行URL安全的Base64编码：
    var encodeSign = base64Encode(digest.bytes);
    return '$accessKey:$encodeSign:$encodedPutPolicy';
  }

  /// 生成putPolicy
  /// https://developer.qiniu.com/kodo/manual/1206/put-policy
  static String generatePutPolicy(String bucket, String key) {
    Map<String, dynamic> map = {
      'scope': '$bucket:$key',
      'deadline': new DateTime.now().millisecondsSinceEpoch + 3600
    };
    return json.encode(map);
  }
}
