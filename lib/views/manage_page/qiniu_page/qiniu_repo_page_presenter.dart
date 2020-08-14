import 'dart:convert';

import 'package:flutter_picgo/api/qiniu_api.dart';
import 'package:flutter_picgo/model/qiniu_config.dart';
import 'package:flutter_picgo/resources/pb_type_keys.dart';
import 'package:flutter_picgo/utils/image_upload.dart';
import 'package:flutter_picgo/utils/strings.dart';

abstract class QiniuRepoPageContract {}

class QiniuRepoPagePresenter {
  QiniuRepoPageContract _view;

  QiniuRepoPagePresenter(this._view);

  doLoadContents() async {
    try {
      String configStr = await ImageUploadUtils.getPBConfig(PBTypeKeys.qiniu);
      QiniuConfig config = QiniuConfig.fromJson(json.decode(configStr));
      if (isBlank(config.accessKey) || isBlank(config.secretKey)) {
        return;
      }
      var result = await QiniuApi.list({
        'bucket': config.bucket,
        'prefix': '',
        'delimiter': Uri.decodeComponent('/'),
      }, config.accessKey, config.secretKey);
      print(json.encode(result));
    } catch (e) {
      print(e);
    }
  }
}
