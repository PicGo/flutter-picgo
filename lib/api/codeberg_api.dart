import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_picgo/model/codeberg_config.dart';
import 'package:flutter_picgo/resources/pb_type_keys.dart';
import 'package:flutter_picgo/utils/image_upload.dart';
import 'package:flutter_picgo/utils/net.dart';
import 'package:flutter_picgo/utils/strings.dart';

class CodebergApi {
  static const String BASE_URL = 'https://codeberg.org/api/v1/';

  static const String CONTENTS =
      'repos/:owner/:repo/contents/:path'; //POST DELETE

  /// Codeberg 基于 Forgejo，创建文件使用 POST（GitHub 为 PUT）
  static Future postContent(String url, data) async {
    var op = await oAuth();
    Response res = await NetUtils.getInstance()
        .post(BASE_URL + url, data: data, options: op);
    return res.data;
  }

  static Future deleteContent(String url, data) async {
    var op = await oAuth();
    Response res = await NetUtils.getInstance()
        .delete(BASE_URL + url, data: data, options: op);
    return res.data;
  }

  /// 获取配置中的Token
  static Future<Options> oAuth() async {
    try {
      String configStr =
          await ImageUploadUtils.getPBConfig(PBTypeKeys.codeberg);
      if (!isBlank(configStr)) {
        CodebergConfig config = CodebergConfig.fromJson(json.decode(configStr));
        if (config != null && !isBlank(config.token)) {
          return Options(headers: {"Authorization": 'token ${config.token}'});
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
