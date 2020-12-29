import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter_picgo/api/aliyun_api.dart';
import 'package:flutter_picgo/utils/net.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path;

main() {
  test('测试Content-MD5', () {
    var digest = AliyunApi.generateContentMD5('0123456789');
    expect(digest, 'eB5eJF1ptWaXm4bijSPyxw==');
  });

  test('测试Auth Header签名', () async {
    var sign = AliyunApi.buildSignature('LTAIsXml0iczvY0J',
        'yw8eO9Fa9Py2GAPRGG8N3GPKCeKCXl', 'PUT', 'zjyzy', 'test.txt');
    try {
      Response res = await NetUtils.getInstance().put(
        'https://zjyzy.oss-cn-shenzhen.aliyuncs.com/test.txt',
        options: Options(headers: {
          'Authorization': sign,
          'Date': HttpDate.format(new DateTime.now()),
        }, contentType: 'application/x-www-form-urlencoded'),
      );
    } on DioError catch (e) {}
  });

  test('测试FormData提交图片', () async {
    String pathname = path
        .joinAll([Directory.current.path, '..', 'assets/images', 'logo.png']);
    var policyText = {
      "expiration":
          "2030-01-01T12:00:00.000Z", // 设置Policy的失效时间，如果超过失效时间，就无法通过此Policy上传文件
      "conditions": [
        {"key": 'logo.png'} // 设置上传文件的大小限制，如果超过限制，文件上传到OSS会报错
      ]
    };
    var originSign = base64.encode(utf8.encode(json.encode(policyText)));

    var hmacsha1 = Hmac(sha1, utf8.encode('yw8eO9Fa9Py2GAPRGG8N3GPKCeKCXl'));
    var sign = hmacsha1.convert(utf8.encode(originSign));
    var encodeSign = base64.encode(sign.bytes);
    try {
      Response res = await NetUtils.getInstance().post(
          'https://zjyzy.oss-cn-shenzhen.aliyuncs.com',
          data: FormData.fromMap({
            'key': 'logo.png',
            'OSSAccessKeyId': 'LTAIsXml0iczvY0J',
            'policy': originSign,
            'Signature': encodeSign,
            'file': await MultipartFile.fromFile(pathname, filename: 'logo.png')
          }),
          options: Options(contentType: Headers.formUrlEncodedContentType));
    } on DioError catch (e) {}
  });
}
