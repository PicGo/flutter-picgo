import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_picgo/api/aliyun_api.dart';
import 'package:flutter_picgo/utils/net.dart';
import 'package:flutter_test/flutter_test.dart';

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

      print(res.data);
    } on DioError catch (e) {
      print(e.response.data);
    }
  });
}
