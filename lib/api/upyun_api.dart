import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';

class UpyunApi {
  static const BASE_URL = 'http://v0.api.upyun.com';

  static const String operatorKey = 'operatorKey';
  static const String passwordKey = 'passwordKey';
}

class UpyunInterceptor extends InterceptorsWrapper {

  @override
  Future onRequest(RequestOptions options) async {
    if (options.path.contains(UpyunApi.BASE_URL)) {
      /// 请求方式，如：GET、POST、PUT、HEAD 等
      String method = options.method.toLowerCase();
      String path = options.uri.path;
      String date = HttpDate.format(DateTime.now());
      String pwdMd5 = '${md5.convert(options.extra[UpyunApi.passwordKey])}';
      String operator = options.extra[UpyunApi.operatorKey];

      /// 签名构造
      var hmacsha1 = Hmac(sha1, utf8.encode(pwdMd5));
      var auth = hmacsha1.convert(utf8.encode('$method&$path&$date')); 
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
