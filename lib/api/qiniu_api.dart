import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter_picgo/utils/net.dart';
import 'package:flutter_picgo/utils/strings.dart';

class QiniuApi {
  /// 管理Base_url，accesstoken和uptoken不共用baseurl
  static const String BASE_URL = "https://rs.qbox.me";
  static const String BASE_URL2 = "https://rsf.qbox.me";

  static const String accessKey = 'accessKey';
  static const String secretKey = 'secretKey';

  /// 上传
  static Future upload(
      String area, FormData data, Map<String, dynamic> headers) async {
    Response res = await NetUtils.getInstance()
        .post(getHost(area), data: data, options: Options(headers: headers));
    return res.data;
  }

  /// 删除
  static Future delete(String url, String ak, String sk) async {
    Response res = await NetUtils.getInstance().post(url,
        options: Options(
          extra: {
            QiniuApi.accessKey: ak,
            QiniuApi.secretKey: sk,
          },
          contentType: 'application/x-www-form-urlencoded',
        ));
    return res.data;
  }

  // 资源列举
  static Future list(Map<String, dynamic> query, String ak, String sk) async {
    Response res =
        await NetUtils.getInstance().get('${QiniuApi.BASE_URL2}/list',
            queryParameters: query,
            options: Options(
              extra: {
                QiniuApi.accessKey: ak,
                QiniuApi.secretKey: sk,
              },
              contentType: 'application/x-www-form-urlencoded',
            ));
    return res.data;
  }

  /// 上传凭证算法
  /// https://developer.qiniu.com/kodo/manual/1208/upload-token
  /// https://pub.flutter-io.cn/packages/crypto
  static String generateUpToken(
      String accessKey, String secretKey, String encodePutPolicy) {
    //对 JSON 编码的上传策略进行URL 安全的 Base64 编码，得到待签名字符串：
    // 使用访问密钥（AK/SK）对上一步生成的待签名字符串计算HMAC-SHA1签名：
    var hmacsha1 = Hmac(sha1, utf8.encode(secretKey));
    var digest = hmacsha1.convert(utf8.encode(encodePutPolicy));
    // 对签名进行URL安全的Base64编码：
    var encodeSign = urlSafeBase64Encode(digest.bytes);
    return '$accessKey:$encodeSign:$encodePutPolicy';
  }

  /// 生成管理凭证
  /// https://developer.qiniu.com/kodo/manual/1201/access-token
  static String generateAuthToken(
      String method,
      String path,
      String query,
      String host,
      String contentType,
      String body,
      String accessKey,
      String secretKey) {
    var signStr = '${method.toUpperCase()} $path';
    if (!isBlank(query)) {
      signStr += '?$query';
    }
    signStr += '\nHost: $host';
    if (!isBlank(contentType)) {
      signStr += '\nContent-Type: $contentType';
    }
    signStr += '\n\n';
    if (contentType != 'application/octet-stream' && body != null) {
      signStr += body;
    }
    // 使用SecertKey对上一步生成的原始字符串计算HMAC-SHA1签名：
    var hmacsha1 = Hmac(sha1, utf8.encode(secretKey));
    var sign = hmacsha1.convert(utf8.encode(signStr));
    var encodedSign = urlSafeBase64Encode(sign.bytes);
    return '$accessKey:$encodedSign';
  }

  /// 管理凭证历史文档
  /// https://developer.qiniu.com/kodo/manual/6671/historical-document-management-certificate
  static String generateAuthTokenByQBox(String path, String query, String body,
      String accessKey, String secretKey) {
    String signStr = '$path?$query\n${body ?? ''}';
    // 使用SecertKey对上一步生成的原始字符串计算HMAC-SHA1签名：
    var hmacsha1 = Hmac(sha1, utf8.encode(secretKey));
    var sign = hmacsha1.convert(utf8.encode(signStr));
    var encodedSign = urlSafeBase64Encode(sign.bytes);
    return '$accessKey:$encodedSign';
  }

  /// 生成putPolicy
  /// https://developer.qiniu.com/kodo/manual/1206/put-policy
  static String generatePutPolicy(String bucket, String key) {
    Map<String, dynamic> map = {
      'scope': '$bucket:$key',
      'deadline': 1909497600 // 2030-07-06
    };
    return urlSafeBase64Encode(utf8.encode(json.encode(map)));
  }

  /// URL安全的Base64编码
  /// https://developer.qiniu.com/kodo/manual/1231/appendix#urlsafe-base64
  static String urlSafeBase64Encode(List<int> bytes) {
    String str = base64Encode(bytes);
    return str.replaceAll('+', '-').replaceAll('/', '_');
  }

  /// Access Area get Host
  /// https://developer.qiniu.com/kodo/manual/1671/region-endpoint
  static String getHost(String area) {
    switch (area) {
      case 'z0':
        return 'https://upload.qiniup.com';
      case 'z1':
        return 'https://upload-z1.qiniup.com';
      case 'z2':
        return 'https://upload-z2.qiniup.com';
      case 'na0':
        return 'https://upload-na0.qiniup.com';
      case 'as0':
        return 'https://upload-as0.qiniup.com';
      default:
        return '';
    }
  }
}

/// 七牛管理验签拦截器
class QiniuInterceptor extends InterceptorsWrapper {
  @override
  Future onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.path.contains(QiniuApi.BASE_URL)) {
      String ak = '${options.extra[QiniuApi.accessKey]}';
      String sk = '${options.extra[QiniuApi.secretKey]}';
      options.data = options.data ?? '';
      var accessToken = QiniuApi.generateAuthToken(
          options.method,
          options.uri.path,
          options.uri.query,
          options.uri.host,
          options.contentType,
          options.data,
          ak,
          sk);
      options.headers.addAll({
        'Authorization': 'Qiniu $accessToken',
      });
    } else if (options.path.contains(QiniuApi.BASE_URL2)) {
      String ak = '${options.extra[QiniuApi.accessKey]}';
      String sk = '${options.extra[QiniuApi.secretKey]}';
      options.data = options.data ?? '';
      var accessToken = QiniuApi.generateAuthTokenByQBox(
          options.uri.path, options.uri.query, options.data, ak, sk);
      options.headers.addAll({
        'Authorization': 'QBox $accessToken',
      });
    }
    return options;
  }
}
