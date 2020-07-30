import 'dart:convert';
import 'package:flutter_picgo/api/github_api.dart';
import 'package:flutter_picgo/model/github_config.dart';
import 'package:flutter_picgo/model/github_content.dart';
import 'package:flutter_picgo/resources/pb_type_keys.dart';
import 'package:flutter_picgo/utils/image_upload.dart';
import 'package:flutter_picgo/utils/strings.dart';
import 'package:path/path.dart' as pathutil;

abstract class GithubRepoPageContract {
  void loadSuccess(List<GithubContent> data);

  void loadError(String msg);
}

class GithubRepoPagePresenter {
  GithubRepoPageContract _view;

  GithubRepoPagePresenter(this._view);

  doLoadContents(String path, String prePath) async {
    try {
      String configStr = await ImageUploadUtils.getPBConfig(PBTypeKeys.github);
      GithubConfig config = GithubConfig.fromJson(json.decode(configStr));
      if (isBlank(config.branch) ||
          isBlank(config.repo) ||
          isBlank(config.token)) {
        _view.loadError('读取配置错误！');
        return;
      }
      String realUrl = pathutil.joinAll([
        'repos',
        config.repo,
        'contents',
        prePath ?? '',
        path == '/' ? '' : path
      ]);
      List result =
          await GithubApi.getContents(realUrl, {"ref": config.branch});
      var data = result.map((e) {
        return GithubContent.fromJson(e);
      }).toList();
      _view.loadSuccess(data);
    } catch (e) {
      _view.loadError('$e');
    }
  }

  Future<bool> doDeleteContents(
      String path, String prePath, String name, String sha) async {
    try {
      String configStr = await ImageUploadUtils.getPBConfig(PBTypeKeys.github);
      GithubConfig config = GithubConfig.fromJson(json.decode(configStr));
      if (isBlank(config.repo) || isBlank(config.token)) {
        _view.loadError('读取配置错误！');
        return false;
      }
      String url = pathutil.joinAll([
        'repos',
        config.repo,
        'contents',
        prePath ?? '',
        path == '/' ? '' : path,
        name
      ]);
      await GithubApi.deleteContent(url, {
        "message": 'DELETE BY Flutter-PicGo',
        "sha": sha,
        "branch": config.branch
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}
