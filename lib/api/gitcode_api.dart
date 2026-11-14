import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_picgo/model/gitcode_config.dart';
import 'package:flutter_picgo/resources/pb_type_keys.dart';
import 'package:flutter_picgo/utils/image_upload.dart';
import 'package:flutter_picgo/utils/net.dart';
import 'package:flutter_picgo/utils/strings.dart';

class GitcodeApi {
  static const String BASE_URL = 'https://api.gitcode.com/api/v5/';

  static const String KEY_ACCESS_TOKEN = 'access_token';

  static Future testToken() async {
    Response res =
        await NetUtils.getInstance().get(BASE_URL + 'user', queryParameters: {
      KEY_ACCESS_TOKEN: await oAuth(),
    });
    return res.data;
  }

  static Future createFile(String url, Map<String, dynamic> map) async {
    Map<String, dynamic> realMap = {
      KEY_ACCESS_TOKEN: await oAuth(),
    };
    realMap.addAll(map);
    var data = FormData.fromMap(realMap);
    Response res =
        await NetUtils.getInstance().post(BASE_URL + url, data: data);
    map.clear();
    map = null;
    return res.data;
  }

  static Future getContents(String url, Map<String, dynamic> params) async {
    Response res = await NetUtils.getInstance()
        .get(BASE_URL + url, queryParameters: params);
    return res.data;
  }

  static Future deleteFile(String url, Map<String, dynamic> query) async {
    Map<String, dynamic> realQuery = {
      KEY_ACCESS_TOKEN: await oAuth(),
    };
    realQuery.addAll(query);
    Response res = await NetUtils.getInstance()
        .delete(BASE_URL + url, queryParameters: realQuery);
    return res.data;
  }

  /// 获取配置中的Token
  static Future<String> oAuth() async {
    try {
      String configStr =
          await ImageUploadUtils.getPBConfig(PBTypeKeys.gitcode);
      if (!isBlank(configStr)) {
        GitcodeConfig config =
            GitcodeConfig.fromJson(json.decode(configStr));
        if (config != null && !isBlank(config.token)) {
          return config.token;
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
