import 'package:dio/dio.dart';
import 'package:flutter_picgo/utils/net.dart';
import 'package:path/path.dart' as path;

class LskyApi {
  static Future token(String email, String pwd, String host) async {
    String url = path.joinAll([host, 'api/token']);
    Response res = await NetUtils.getInstance().post(url, data: {
      'email': email,
      'password': pwd,
    });
    return res.data;
  }

  static Future upload(String token, String host, FormData data) async {
    String url = path.joinAll([host, 'api/upload']);
    Response res = await NetUtils.getInstance()
        .post(url, data: data, options: buildCommonOptions(token));
    return res.data;
  }

  static Future images(String token, String host, int page,
      {int rows = 10}) async {
    String url = path.joinAll([host, 'api/images']);
    Response res = await NetUtils.getInstance().post(
      url,
      data: {
        'page': page,
        'rows': rows,
      },
      options: buildCommonOptions(token),
    );
    return res.data;
  }

  static Future delete(String token, String host, String id) async {
    String url = path.joinAll([host, 'api/delete']);
    Response res = await NetUtils.getInstance().post(url,
        data: {
          'id': id,
        },
        options: buildCommonOptions(token));
    return res.data;
  }

  static Options buildCommonOptions(String token) {
    return Options(headers: {
      'token': token,
    }, contentType: Headers.formUrlEncodedContentType);
  }
}
