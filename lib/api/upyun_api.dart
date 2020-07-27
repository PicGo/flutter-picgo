import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter_picgo/utils/net.dart';
import 'package:path/path.dart';

class UpyunApi {
  static const BASE_URL = 'http://v0.api.upyun.com';

  static const String operatorKey = 'operatorKey';
  static const String passwordKey = 'passwordKey';

  /// REST API PUT
  static Future putObject(
    File file,
    String operator,
    String password,
    String name,
    String bucket, {
    String path = '',
  }) async {
    String wholePath = joinAll([BASE_URL, bucket, path, name]);
    var bytes = file.readAsBytesSync();
    Response res = await NetUtils.getInstance().put(wholePath,
        data: Stream.fromIterable(bytes.map((e) => [e])),
        options: Options(
            headers: {
              Headers.contentLengthHeader: bytes.length,
            },
            contentType: 'image/${extension(name).replaceFirst('.', '')}',
            extra: {
              operatorKey: operator,
              passwordKey: password,
            }));
    return res.headers;
  }

  /// REST API DELETE
  static Future deleteObject(
    String bucket,
    String operator,
    String password,
    String key,
  ) async {
    String wholePath = joinAll([BASE_URL, bucket, key]);
    Response res = await NetUtils.getInstance().delete(wholePath,
        options: Options(
          extra: {
            operatorKey: operator,
            passwordKey: password,
          },
        ));
    return res.headers;
  }

  /// build policy
  static String buildPolicy(String bucket, String saveKey) {
    Map<String, dynamic> map = {
      'bucket': bucket,
      'save-key': saveKey,
      'expiration': DateTime.now().millisecondsSinceEpoch + 30 * 60 * 1000,
    };
    return base64.encode(utf8.encode(json.encode(map)));
  }
}

class UpyunInterceptor extends InterceptorsWrapper {
  @override
  Future onRequest(RequestOptions options) async {
    if (options.path.contains(UpyunApi.BASE_URL.replaceFirst('http://', ''))) {
      /// 请求方式，如：GET、POST、PUT、HEAD 等
      String method = options.method.toUpperCase();
      String path = options.uri.path;
      String date = HttpDate.format(DateTime.now());
      String pwdMd5 =
          '${md5.convert(utf8.encode(options.extra[UpyunApi.passwordKey]))}';
      String operator = options.extra[UpyunApi.operatorKey];
      String sign = '$method&$path&$date';

      /// 签名构造
      var hmacsha1 = Hmac(sha1, utf8.encode('$pwdMd5'));
      var auth = hmacsha1.convert(utf8.encode(sign));
      String realAuth = base64.encode(auth.bytes);

      /// Add Common Header
      options.headers.addAll({
        'Date': date,
        'Authorization': 'UPYUN $operator:$realAuth',
      });
    }
    return options;
  }
}
