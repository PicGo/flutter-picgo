import 'package:dio/dio.dart';
import 'package:flutter_picgo/utils/net.dart';

class PicgoApi {
  /// 获取App最新版本
  static Future getLatestVersion() async {
    Response res = await NetUtils.getInstance().get(
        'https://cdn.jsdelivr.net/gh/PicGo/flutter-picgo@dev/docs/version.json');
    return res;
  }
}
