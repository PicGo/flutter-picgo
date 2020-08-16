import 'dart:convert';

import 'package:flutter_picgo/api/qiniu_api.dart';
import 'package:flutter_picgo/components/manage_item.dart';
import 'package:flutter_picgo/model/qiniu_config.dart';
import 'package:flutter_picgo/model/qiniu_content.dart';
import 'package:flutter_picgo/resources/pb_type_keys.dart';
import 'package:flutter_picgo/utils/image_upload.dart';
import 'package:flutter_picgo/utils/strings.dart';
import 'package:path/path.dart' as pathlib;

abstract class QiniuRepoPageContract {
  void loadSuccess(List<QiniuContent> data);

  void loadError(String msg);
}

class QiniuRepoPagePresenter {
  QiniuRepoPageContract _view;

  QiniuRepoPagePresenter(this._view);

  doLoadContents(String prefix) async {
    try {
      String configStr = await ImageUploadUtils.getPBConfig(PBTypeKeys.qiniu);
      QiniuConfig config = QiniuConfig.fromJson(json.decode(configStr));
      if (isBlank(config.accessKey) || isBlank(config.secretKey)) {
        _view.loadError('读取配置文件错误');
        return;
      }
      var result = await QiniuApi.list({
        'bucket': config.bucket,
        'prefix': prefix == '/' ? '' : prefix,
        'delimiter': Uri.decodeComponent('/'),
      }, config.accessKey, config.secretKey);
      List data = (result['items'] as List<dynamic>).map((e) {
        print(e);
        QiniuContent c = QiniuContent.fromJson(e);
        c.type = FileContentType.FILE;
        c.url = pathlib.joinAll([
          config.url,
          c.key,
        ]);
        c.key = '${c.key}'.replaceFirst(prefix == '/' ? '' : prefix, '');
        return c;
      }).toList();
      if (result['commonPrefixes'] != null) {
        (result['commonPrefixes'] as List<dynamic>).forEach((element) {
          QiniuContent c = QiniuContent();
          c.type = FileContentType.DIR;
          c.url = element;
          /// 例如 xin/ax 去除 xin/ 只显示最后一个 ax
          List<String> keys = '$element'.split('/');
          print(keys);
          c.key = keys[keys.length -2];
          data.add(c);
        });
      }
      _view.loadSuccess(data);
    } catch (e) {
      print(e);
      _view.loadError('$e');
    }
  }

  Future<bool> doDeleteContents(String key) async {
    try {
      String configStr = await ImageUploadUtils.getPBConfig(PBTypeKeys.qiniu);
      QiniuConfig config = QiniuConfig.fromJson(json.decode(configStr));
      if (isBlank(config.accessKey) || isBlank(config.secretKey)) {
        _view.loadError('读取配置文件错误');
        return false;
      }
      String encodedEntryURI = QiniuApi.urlSafeBase64Encode(
            utf8.encode('${config.bucket}:$key'));
        String url = '${QiniuApi.BASE_URL}/delete/$encodedEntryURI';
        var result = await QiniuApi.delete(url, config.accessKey, config.secretKey);
        if (isBlank(result.toString())) {
          return true;
        } else {
          _view.loadError('${result['error']}');
          return false;
        }
    } catch (e) {
      return false;
    }
  }

}
