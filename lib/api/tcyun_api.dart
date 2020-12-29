import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter_picgo/utils/net.dart';
import 'package:flutter_picgo/utils/strings.dart';

class TcyunApi {
  static const String BASE_URL = 'myqcloud.com';

  static const String secretKey = 'secretKey';
  static const String secretId = 'secretId';

  static Future postObject(String secretId, String secretKey, String bucket,
      String area, String ext, FormData formData) async {
    Response res = await NetUtils.getInstance().post(
        'https://$bucket.cos.$area.$BASE_URL/',
        data: formData,
        options: Options(
            extra: {TcyunApi.secretId: secretId, TcyunApi.secretKey: secretKey},
            contentType: 'image/$ext'));
    return res.headers;
  }

  static Future deleteobject(String secretId, String secretKey, String bucket,
      String area, String key) async {
    Response res = await NetUtils.getInstance().delete(
        'https://$bucket.cos.$area.$BASE_URL/$key',
        options: Options(
          extra: {TcyunApi.secretId: secretId, TcyunApi.secretKey: secretKey},
        ));
    return res.headers;
  }

  /// 构造“策略”（Policy）
  /// 经过 Base64 编码的“策略”（Policy）内容
  static String buildPolicy(
      String bucket, String key, String secretId, String keyTime) {
    Map<String, dynamic> map = {
      "expiration": "2030-01-01T00:00:00.000Z",
      "conditions": [
        {"bucket": bucket},
        {"key": key},
        {"q-sign-algorithm": "sha1"},
        {"q-ak": secretId},
        {"q-sign-time": keyTime}
      ]
    };
    return json.encode(map);
  }

  /// post Signature
  static String buildSignature(
      String secretKey, String keyTime, String policy) {
    /// signkey
    var hmacsha1Signkey = Hmac(sha1, utf8.encode(secretKey));
    var signKey = hmacsha1Signkey.convert(utf8.encode(keyTime));
    // string to sign
    var stringToSign = sha1.convert(utf8.encode(policy));
    // signature
    var hmacsha1Signature = Hmac(sha1, utf8.encode('$signKey'));
    var signature = hmacsha1Signature.convert(utf8.encode('$stringToSign'));
    return '$signature';
  }

  /// 生成 KeyTime
  /// 获取当前时间对应的 Unix 时间戳 StartTimestamp，Unix 时间戳是从 UTC（协调世界时，
  /// 或 GMT 格林威治时间）1970年1月1日0时0分0秒（北京时间 1970年1月1日8时0分0秒）起至现在的总秒数。
  /// 根据上述时间戳和期望的签名有效时长算出签名过期时间对应的 Unix 时间戳 EndTimestamp。
  /// 拼接签名有效时间，格式为StartTimestamp;EndTimestamp，即为 KeyTime。
  /// 示例：1557902800;1557910000
  static String buildKeyTime() {
    int startTime = (new DateTime.now().millisecondsSinceEpoch) ~/ 1000;
    int endTime = startTime + 99999;
    return '$startTime;$endTime';
  }

  /// 生成 SignKey
  /// 使用 HMAC-SHA1 以 SecretKey 为密钥，以 KeyTime 为消息，计算消息摘要（哈希值），即为 SignKey。
  static String buildSignKey(String secretKey, String keyTime) {
    // 使用SecertKey对上一步生成的原始字符串计算HMAC-SHA1签名：
    var hmacsha1 = Hmac(sha1, utf8.encode(secretKey));
    var sign = hmacsha1.convert(utf8.encode(keyTime));
    return '$sign';
  }
}

/// TcYun验签拦截器
class TcyunInterceptor extends InterceptorsWrapper {
  @override
  Future onRequest(RequestOptions options) async {
    if (options.path.contains(TcyunApi.BASE_URL)) {
      /// 生成 KeyTime
      var keytime = TcyunApi.buildKeyTime();

      /// 生成 SignKey
      var signKey = TcyunApi.buildSignKey(
          '${options.extra[TcyunApi.secretKey]}', keytime);

      /// 生成 UrlParamList 和 HttpParameters
      String urlParamList = '';
      String httpParameters = '';
      if (options.queryParameters != null) {
        options.queryParameters.forEach((key, value) {
          urlParamList += '${key.toLowerCase()};';
          httpParameters +=
              '${key.toLowerCase()}=${isBlank(value) ? '' : value}&';
        });
      }
      if (urlParamList.length > 0) {
        urlParamList = urlParamList.substring(0, urlParamList.length - 1);
      }
      if (httpParameters.length > 0) {
        httpParameters = httpParameters.substring(0, httpParameters.length - 1);
      }

      /// 生成 HeaderList 和 HttpHeaders
      String headerList = '';
      String httpHeaders = '';
      Map<String, dynamic> headers = {
        // 'Date': HttpDate.format(new DateTime.now()),
        'Host': options.uri.host
      };
      headers.addAll(options.headers);
      if (options.method.toUpperCase() == 'GET' ||
          options.method.toUpperCase() == 'HEAD' ||
          options.method.toUpperCase() == 'DELETE' ||
          options.method.toUpperCase() == 'OPTIONS') {
        headers.remove('content-type');
      }
      if (headers != null) {
        headers.forEach((key, value) {
          headerList += '${Uri.encodeComponent(key).toLowerCase()};';
          httpHeaders +=
              '${Uri.encodeComponent(key).toLowerCase()}=${Uri.encodeComponent(value)}&';
        });
      }
      if (headerList.length > 0) {
        headerList = headerList.substring(0, headerList.length - 1);
      }
      if (httpHeaders.length > 0) {
        httpHeaders = httpHeaders.substring(0, httpHeaders.length - 1);
      }

      /// 生成 HttpString
      String method = options.method.toLowerCase();
      String httpString =
          '$method\n${options.uri.path}\n$httpParameters\n$httpHeaders\n';

      /// 生成 StringToSign
      String stringtoSign =
          'sha1\n$keytime\n${sha1.convert(utf8.encode(httpString))}\n';

      /// 生成 Signature
      var hmacsha1 = Hmac(sha1, utf8.encode(signKey));
      var sign = hmacsha1.convert(utf8.encode(stringtoSign));

      /// 生成签名
      var realSign = 'q-sign-algorithm=sha1' +
          '&q-ak=${options.extra[TcyunApi.secretId]}' +
          '&q-sign-time=$keytime' +
          '&q-key-time=$keytime' +
          '&q-header-list=$headerList' +
          '&q-url-param-list=$urlParamList' +
          '&q-signature=$sign';
      headers.addAll({'Authorization': realSign});
      options.headers = headers;
    }
    return options;
  }
}
