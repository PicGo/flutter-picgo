import 'package:flutter_picgo/api/qiniu_api.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  test('测试UpToken生成', () {
    String policy = QiniuApi.generatePutPolicy('image', 'test.png');
    print(policy);
    var token = QiniuApi.generateUpToken(
        'CRd7Wa4PuSGvs4ArToPTLBMCigGGUY3sk3F8oc8W',
        'f2Jkrlyea5s8h8gLEToa9-k895GNM-BlmQ2RfxwU',
        policy);
    print(token);
  });
}
