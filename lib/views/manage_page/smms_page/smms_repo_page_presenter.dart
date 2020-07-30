import 'dart:convert';

import 'package:flutter_picgo/api/smms_api.dart';
import 'package:flutter_picgo/model/smms_content.dart';

abstract class SMMSRepoPageContract {
  void loadSuccess(List<SMMSContent> data);

  void loadError(String msg);
}

class SMMSRepoPagePresenter {
  SMMSRepoPageContract _view;

  SMMSRepoPagePresenter(this._view);

  doLoadContents() async {
    try {
      var result = await SMMSApi.getUploadHistory();
      var resultmap = json.decode(result);
      if (resultmap["success"]) {
        _view.loadSuccess((resultmap['data'] as List<dynamic>).map<SMMSContent>((e) => SMMSContent.fromJson(e)).toList());
      } else {
        _view.loadError(resultmap['message'] ?? '未知错误');
      }
    } catch (e) {
      _view.loadError('$e');
    }
  }

  Future<bool> doDeleteContents(String path) async {
    try {
      var result = await SMMSApi.delete(path.replaceFirst('https://sm.ms/delete/', ''));
      var resultmap = json.decode(result);
      if (resultmap["success"]) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
