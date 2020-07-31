import 'dart:convert';

import 'package:flutter_picgo/api/lsky_api.dart';
import 'package:flutter_picgo/model/lsky_config.dart';
import 'package:flutter_picgo/model/lsky_content.dart';
import 'package:flutter_picgo/resources/pb_type_keys.dart';
import 'package:flutter_picgo/utils/image_upload.dart';
import 'package:flutter_picgo/utils/strings.dart';

abstract class LskyRepoPageContract {
  void loadSuccess(List<LskyContent> data, bool isEnd);

  void loadError(String msg);
}

class LskyRepoPagePresenter {
  LskyRepoPageContract _view;

  LskyRepoPagePresenter(this._view);

  doLoadContents(int page) async {
    try {
      String configStr = await ImageUploadUtils.getPBConfig(PBTypeKeys.lsky);
      if (isBlank(configStr)) {
        _view.loadError('读取配置错误！');
        return;
      }
      LskyConfig config = LskyConfig.fromJson(json.decode(configStr));
      var result = await LskyApi.images(config.token, config.host, page);
      if (result['code'] == 200) {
        bool isEnd =
            result['data']['current_page'] == result['data']['last_page'];
        _view.loadSuccess(
            (result['data']['data'] as List<dynamic>)
                .map((e) => LskyContent.fromJson(e))
                .toList(),
            isEnd);
      } else {
        _view.loadError(result['msg']);
      }
    } catch (e) {
      _view.loadError('$e');
    }
  }

  Future<bool> doDeleteContents(String id) async {
    try {
      String configStr = await ImageUploadUtils.getPBConfig(PBTypeKeys.lsky);
      if (isBlank(configStr)) {
        return false;
      }
      LskyConfig config = LskyConfig.fromJson(json.decode(configStr));
      var result = await LskyApi.delete(config.token, config.host, id);
      if (result['code'] == 200) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
