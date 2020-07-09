import 'dart:convert';

import 'package:flutter_picgo/model/aliyun_config.dart';
import 'package:flutter_picgo/resources/pb_type_keys.dart';
import 'package:flutter_picgo/utils/image_upload.dart';
import 'package:flutter_picgo/utils/strings.dart';

abstract class AliyunPageContract {
  loadConfig(AliyunConfig config);
}

class AliyunPagePresenter {
  AliyunPageContract _view;

  AliyunPagePresenter(this._view);

  doLoadConfig() async {
    try {
      var configStr = await ImageUploadUtils.getPBConfig(PBTypeKeys.aliyun);
      if (!isBlank(configStr)) {
        AliyunConfig config = AliyunConfig.fromJson(json.decode(configStr));
        _view.loadConfig(config);
      } else {
        _view.loadConfig(AliyunConfig());
      }
    } catch (e) {}
  }
}
