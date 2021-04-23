import 'package:flutter_picgo/api/qiniu_api.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  test('测试UpToken生成', () {
    String policy = QiniuApi.generatePutPolicy('image', 'test.png');
    QiniuApi.generateUpToken('CRd7Wa4PuSGvs4ArToPTLBMCigGGUY3sk3F8oc8W',
        'f2Jkrlyea5s8h8gLEToa9-k895GNM-BlmQ2RfxwU', policy);
  });

  test('测试AuthToken生成', () {
    var token = QiniuApi.generateAuthToken(
        'post',
        '/move/bmV3ZG9jczpmaW5kX21hbi50eHQ=/bmV3ZG9jczpmaW5kLm1hbi50eHQ=',
        null,
        'rs.qiniu.com',
        null,
        null,
        'MY_ACCESS_KEY',
        'MY_SECRET_KEY');
    expect(token, 'MY_ACCESS_KEY:1uLvuZM6l6oCzZFqkJ6oI4oFMVQ=');
  });
}
