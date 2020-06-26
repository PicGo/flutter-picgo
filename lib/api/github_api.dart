import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_picgo/model/github_config.dart';
import 'package:flutter_picgo/resources/pb_type_keys.dart';
import 'package:flutter_picgo/utils/image_upload.dart';
import 'package:flutter_picgo/utils/net.dart';
import 'package:flutter_picgo/utils/strings.dart';

class GithubApi {
  static const String BASE_URL = 'https://api.github.com/';

  static const String CONTENTS =
      'repos/:owner/:repo/contents/:path'; //PUT DELETE GET

  static Future testToken() async {
    Response res = await NetUtils.getInstance().get(BASE_URL);
    return res.data;
  }

  static Future putContent(String url, data) async {
    var op = await oAuth();
    Response res = await NetUtils.getInstance()
        .put(BASE_URL + url ?? '', data: data, options: op);
    return res.data;
  }

  static Future deleteContent(String url, data) async {
    var op = await oAuth();
    Response res = await NetUtils.getInstance()
        .delete(BASE_URL + url, data: data, options: op);
    return res.data;
  }

  static Future getContents(String url, Map<String, dynamic> params) async {
    var op = await oAuth();
    Response res = await NetUtils.getInstance()
        .get(BASE_URL + url, queryParameters: params, options: op);
    return res.data;
  }

  /// 获取配置中的Token
  static Future<Options> oAuth() async {
    try {
      String configStr = await ImageUploadUtils.getPBConfig(PBTypeKeys.github);
      if (!isBlank(configStr)) {
        GithubConfig config = GithubConfig.fromJson(json.decode(configStr));
        if (config != null && !isBlank(config.token)) {
          return Options(headers: {"Authorization": 'Token ${config.token}'});
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
