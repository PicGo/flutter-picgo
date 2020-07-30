import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_picgo/model/smms_config.dart';
import 'package:flutter_picgo/resources/pb_type_keys.dart';
import 'package:flutter_picgo/utils/image_upload.dart';
import 'package:flutter_picgo/utils/net.dart';
import 'package:flutter_picgo/utils/strings.dart';

class SMMSApi {
  static const String BASE_URL = 'https://sm.ms/api/v2/';

  static Future getProfile() async {
    var op = await oAuth();
    Response res =
        await NetUtils.getInstance().post(BASE_URL + 'profile', options: op);
    return res.data;
  }

  static Future upload(FormData formData) async {
    var op = await oAuth();
    Response res = await NetUtils.getInstance()
        .post(BASE_URL + 'upload', data: formData, options: op);
    return res.data;
  }

  static Future delete(String hash) async {
    var op = await oAuth();
    Response res = await NetUtils.getInstance()
        .get(BASE_URL + 'delete/' + hash ?? '', options: op);
    return res.data;
  }

  static Future deleteByPath(String path) async {
    var op = await oAuth();
    Response res = await NetUtils.getInstance().get(path, options: op);
    return res.data;
  }

  static Future getUploadHistory() async {
    var op = await oAuth();
    Response res = await NetUtils.getInstance()
        .get(BASE_URL + '/upload_history', options: op);
    return res;
  }

  /// 获取配置中的Token
  static Future<Options> oAuth() async {
    try {
      String configStr = await ImageUploadUtils.getPBConfig(PBTypeKeys.smms);
      if (!isBlank(configStr)) {
        SMMSConfig config = SMMSConfig.fromJson(json.decode(configStr));
        if (config != null && !isBlank(config.token)) {
          return Options(headers: {"Authorization": '${config.token}'});
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
