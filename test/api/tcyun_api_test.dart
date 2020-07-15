import 'package:flutter_picgo/api/tcyun_api.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  test('测试生成 KeyTime', () {
    print(TcyunApi.buildKeyTime());
  });

  test('测试生成 SignKey', () {
    print(TcyunApi.buildSignKey('adsadaads', TcyunApi.buildKeyTime()));
  });

  test('测试Api 签名', () async {
    await TcyunApi.deleteobject(
        'AKID70e28x4gazd17vKiywkITO1NSWHv6s75',
        'pN0MRGo5HCqDxTqpGPTFlCsHPKzUjhZD',
        'test-1253954259',
        'ap-nanjing',
        'wallhaven-2e9j79.jpg');
  });
}
