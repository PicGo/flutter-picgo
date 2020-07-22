import 'package:dio/dio.dart';
import 'package:flutter_picgo/utils/net.dart';

class NiupicApi {
  static const BASE_URL = 'https://www.niupic.com/';

  static Future upload(FormData data) async {
    Response res = await NetUtils.getInstance()
        .post(BASE_URL + 'index/upload/process', data: data);
    return res.data;
  }
}
