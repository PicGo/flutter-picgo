import 'dart:convert';
import 'package:flutter_picgo/model/github_config.dart';
import 'package:flutter_picgo/model/github_content.dart';
import 'package:flutter_picgo/resources/pb_type_keys.dart';
import 'package:flutter_picgo/utils/github_net.dart';
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
      if (isBlank(config.branchName) ||
          isBlank(config.repositoryName) ||
          isBlank(config.token)) {
        _view.loadError('读取配置错误！');
        return;
      }
      String realUrl = pathutil
          .joinAll(['repos', config.repositoryName, 'contents', prePath ?? '', path == '/' ? '' : path]);
      List result = await GithubNetUtils.get(realUrl, params: {"ref": config.branchName});
      var data = result.map((e){
        return GithubContent.fromJson(e);
      }).toList();
      _view.loadSuccess(data);
    } catch (e) {
      _view.loadError('$e');
    }
  }
}
