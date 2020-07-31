import 'dart:convert';
import 'package:flutter_picgo/api/gitee_api.dart';
import 'package:flutter_picgo/model/gitee_config.dart';
import 'package:flutter_picgo/model/gitee_content.dart';
import 'package:flutter_picgo/resources/pb_type_keys.dart';
import 'package:flutter_picgo/utils/image_upload.dart';
import 'package:flutter_picgo/utils/strings.dart';
import 'package:path/path.dart' as pathutil;

abstract class GiteeRepoPageContract {
  void loadSuccess(List<GiteeContent> data);

  void loadError(String msg);
}

class GiteeRepoPagePresenter {
  GiteeRepoPageContract _view;

  GiteeRepoPagePresenter(this._view);

  doLoadContents(String path, String prePath) async {
    try {
      String configStr = await ImageUploadUtils.getPBConfig(PBTypeKeys.gitee);
      GiteeConfig config = GiteeConfig.fromJson(json.decode(configStr));
      if (isBlank(config.repo) || isBlank(config.token)) {
        _view.loadError('读取配置错误！');
        return;
      }
      String realUrl = pathutil.joinAll([
        'repos',
        config.owner,
        config.repo,
        'contents',
        prePath ?? '',
        path == '/' ? '' : path
      ]);
      List result = await GiteeApi.getContents(realUrl,
          isBlank(config.branch) ? null : {"ref": config.branch ?? ''});
      var data = result.map((e) {
        return GiteeContent.fromJson(e);
      }).toList();
      _view.loadSuccess(data);
    } catch (e) {
      _view.loadError('$e');
    }
  }

  Future<bool> doDeleteContents(
      String path, String prePath, String name, String sha) async {
    try {
      String configStr = await ImageUploadUtils.getPBConfig(PBTypeKeys.gitee);
      GiteeConfig config = GiteeConfig.fromJson(json.decode(configStr));
      if (isBlank(config.repo) || isBlank(config.token)) {
        _view.loadError('读取配置错误！');
        return false;
      }
      String url = pathutil.joinAll([
        'repos',
        config.owner,
        config.repo,
        'contents',
        prePath ?? '',
        path == '/' ? '' : path,
        name
      ]);
      Map<String, dynamic> query = {
        "message": "DELETE BY Flutter-PicGo",
        "sha": sha,
      };
      if (!isBlank(config.branch)) {
        query["branch"] = config.branch;
      }
      await GiteeApi.deleteFile(url, query);
      return true;
    } catch (e) {
      return false;
    }
  }
}
