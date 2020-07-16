import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_picgo/api/tcyun_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path;

main() {
  test('测试生成 KeyTime', () {
    print(TcyunApi.buildKeyTime());
  });

  test('测试生成 SignKey', () {
    print(TcyunApi.buildSignKey('adsadaads', TcyunApi.buildKeyTime()));
  });

  test('测试Api 签名', () async {
    try {
      await TcyunApi.deleteobject(
          'AKID70e28x4gazd17vKiywkITO1NSWHv6s75',
          'pN0MRGo5HCqDxTqpGPTFlCsHPKzUjhZD',
          'test-1253954259',
          'ap-nanjing',
          'wallhaven-2e9j79.jpg');
    } catch (e) {
      print(e);
    }
  });

  test('PostObjecy 提交', () async {
    try {
      String pathname = path.joinAll(
          [Directory.current.path, '..\\assets\\' 'images', 'logo.png']);
      print(pathname);
      String keyTime = TcyunApi.buildKeyTime();
      String policy = TcyunApi.buildPolicy('ap-nanjing', 'logo.png',
          'AKIDvb0B9rqfeOr44kt2ar46rO2cwzl6JwUk', keyTime);
      print(policy);
      // TcyunApi.postObject(
      //     'test-1253954259',
      //     'ap-nanjing',
      //     'png',
      //     FormData.fromMap({
      //       "key": "logo.png",
      //       "file": await MultipartFile.fromFile(
      //           'C:\\Users\\Administrator\\Desktop\\flutter-picgo\\flutter-picgo\\assets\\images\\logo.png',
      //           filename: 'logo.png'),
      //       "policy": base64.encode(utf8.encode(policy)),
      //       "q-sign-algorithm": "sha1",
      //       "q-ak": "AKIDvb0B9rqfeOr44kt2ar46rO2cwzl6JwUk",
      //       "q-key-time": keyTime,
      //       "q-signature": TcyunApi.buildSignature(
      //           'KOEoR1LL5apX1lFRN4VgZB0nJgmdEbie', keyTime, policy)
      //     }));
    } catch (e) {
      print(e);
    }
  });
}
