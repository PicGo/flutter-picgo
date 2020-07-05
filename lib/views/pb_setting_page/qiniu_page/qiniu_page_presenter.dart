import 'dart:convert';

import 'package:flutter_picgo/model/qiniu_config.dart';
import 'package:flutter_picgo/resources/pb_type_keys.dart';
import 'package:flutter_picgo/utils/image_upload.dart';
import 'package:flutter_picgo/utils/strings.dart';

abstract class QiniuPageContract {
  loadConfig(QiniuConfig config);
}

class QiniuPagePresenter {
  QiniuPageContract _view;

  QiniuPagePresenter(this._view);

  doLoadConfig() async {
    try {
      var configStr = await ImageUploadUtils.getPBConfig(PBTypeKeys.qiniu);
      if (!isBlank(configStr)) {
        QiniuConfig config = QiniuConfig.fromJson(json.decode(configStr));
        _view.loadConfig(config);
      } else {
        _view.loadConfig(QiniuConfig());
      }
    } catch (e) {}
  }
}
