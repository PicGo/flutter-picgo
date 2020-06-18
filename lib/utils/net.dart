import 'dart:async';
import 'package:dio/dio.dart';

Map<String, dynamic> optHeader = {
  'accept-language': 'zh-cn',
  'content-type': 'application/json'
};

var dio = new Dio(BaseOptions(connectTimeout: 30000, headers: optHeader));

class NetUtils {
  static Future get(String url, [Map<String, dynamic> params]) async {
    var response;

    // 设置代理 便于本地 charles 抓包
    // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //     (HttpClient client) {
    //   client.findProxy = (uri) {
    //     return "PROXY 30.10.24.79:8889";
    //   };
    // };

    if (params != null) {
      response = await dio.get(url, queryParameters: params);
    } else {
      response = await dio.get(url);
    }
    return response.data;
  }

  static Future post(String url, Map<String, dynamic> params) async {
    // // 设置代理 便于本地 charles 抓包
    // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //     (HttpClient client) {
    //   client.findProxy = (uri) {
    //     return "PROXY 30.10.24.79:8889";
    //   };
    // };
    var response = await dio.post(url, data: params);
    return response.data;
  }
}