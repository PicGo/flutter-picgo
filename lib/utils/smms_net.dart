import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_picgo/api/smms_api.dart';
import 'package:flutter_picgo/model/smms_config.dart';
import 'package:flutter_picgo/resources/pb_type_keys.dart';
import 'package:flutter_picgo/resources/table_name_keys.dart';
import 'package:flutter_picgo/utils/sql.dart';

const bool inProduction = const bool.fromEnvironment("dart.vm.product");

Map<String, dynamic> optHeader = {
  // 'accept-language': 'zh-cn',
  // 'content-type': 'application/json'
};

var dio = new Dio(BaseOptions(
    connectTimeout: 30000,
    receiveTimeout: 30000,
    sendTimeout: 30000,
    headers: optHeader,
    baseUrl: SMMSApi.BASE_URL));

class SMMSNetUtils {
  static Future get(String url, {Map<String, dynamic> params}) async {
    // 拦截器
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (RequestOptions options) async {
        var token = await oAuth();
        options.headers["Authorization"] = '$token';
      },
    ));
    Response response;
    if (params != null) {
      response = await dio.get(url, queryParameters: params);
    } else {
      response = await dio.get(url);
    }
    // if (response.statusCode != 200) {
    //   dio.reject(response.data["message"] ?? '未知异常');
    // }
    return response.data;
  }

  static Future post(String url, Map<String, dynamic> data) async {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (RequestOptions options) async {
        var token = await oAuth();
        options.headers["Authorization"] = '$token';
      },
    ));
    Response response = await dio.post(url, data: data);
    return response.data;
  }

  static Future postForm(String url, FormData data) async {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (RequestOptions options) async {
        var token = await oAuth();
        options.headers["Authorization"] = '$token';
      },
    ));
    Response response = await dio.post(url, data: data);
    return response.data;
  }

  static Future put(String url, Map<String, dynamic> data) async {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (RequestOptions options) async {
        var token = await oAuth();
        options.headers["Authorization"] = '$token';
      },
    ));
    if (!inProduction) {
      dio.interceptors.add(LogInterceptor());
    }
    Response response = await dio.put(url, data: data);
    return response.data;
  }

  static Future delete(String url, Map<String, dynamic> data) async {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (RequestOptions options) async {
        var token = await oAuth();
        options.headers["Authorization"] = '$token';
      },
    ));
    if (!inProduction) {
      dio.interceptors.add(LogInterceptor());
    }
    Response response = await dio.delete(url, data: data);
    return response.data;
  }

  /// 获取配置中的Token
  static Future oAuth() async {
    try {
      var sql = Sql.setTable(TABLE_NAME_PBSETTING);
      var pbsettingRow =
          (await sql.getBySql('type = ?', [PBTypeKeys.smms]))?.first;
      if (pbsettingRow != null &&
          pbsettingRow["config"] != null &&
          pbsettingRow["config"] != '') {
        SMMSConfig config =
            SMMSConfig.fromJson(json.decode(pbsettingRow["config"]));
        if (config != null && config.token != null && config.token != '') {
          return config.token;
        }
      }
    } catch (e) {}
  }
}
