import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import 'package:flutter_picgo/views/home.dart';
import 'package:flutter_picgo/views/album_page/album_page.dart';
import 'package:flutter_picgo/views/pb_setting_page/gitee_page/gitee_page.dart';
import 'package:flutter_picgo/views/pb_setting_page/gitee_page/gitee_repo_page.dart';
import 'package:flutter_picgo/views/pb_setting_page/github_page/github_repo_page.dart';
import 'package:flutter_picgo/views/pb_setting_page/pb_setting_page.dart';
import 'package:flutter_picgo/views/pb_setting_page/qiniu_page/qiniu_page.dart';
import 'package:flutter_picgo/views/pb_setting_page/smms_page/smms_page.dart';
import 'package:flutter_picgo/views/picgo_setting_page/theme_setting_page.dart';
import 'package:flutter_picgo/views/upload_page/upload_page.dart';
import 'package:flutter_picgo/views/pb_setting_page/github_page/github_page.dart';
import 'package:flutter_picgo/views/picgo_setting_page/picgo_setting_page.dart';
import 'package:flutter_picgo/views/setting_page/setting_page.dart';
import 'package:flutter_picgo/views/404.dart';

var appHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String indexStr = params['index']?.first;
    int index = 0;
    try {
      index = int.parse(indexStr);
    } catch (e) {}
    return AppPage(selectedIndex: index);
  },
);

// 404页面
var notfoundHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) =>
      PageNotFound(),
);

// 相册页面
var albumHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) =>
      AlbumPage(),
);

// 设置页面
var settingHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) =>
      SettingPage(),
);

// 上传页面
var uploadHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) =>
      UploadPage(),
);

// 图床设置页面
var pbsettingHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) =>
      PBSettingPage(),
);

// Github图床设置页面
var pbsettingGithubHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) =>
      GithubPage(),
);

// Github仓库列表页面
var pbsettingGithubRepoHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    var path = params["path"]?.first;
    var prePath = params["prePath"]?.first;
    return GithubRepoPage(
      path: (path == null || path == '') ? '/' : Uri.decodeComponent(path),
      prePath: (prePath == null || prePath == '')
          ? ''
          : Uri.decodeComponent(prePath),
    );
  },
);

// SM.MS设置页面
var pbsettingSMMSHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) =>
        SMMSPage());

// Gitee设置页面
var pbsettingGiteeHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) =>
      GiteePage(),
);

// Gitee仓库列表页面
var pbsettingGiteeRepoHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    var path = params["path"]?.first;
    var prePath = params["prePath"]?.first;
    return GiteeRepoPage(
      path: (path == null || path == '') ? '/' : Uri.decodeComponent(path),
      prePath: (prePath == null || prePath == '')
          ? ''
          : Uri.decodeComponent(prePath),
    );
  },
);

// 七牛图床设置页面
var pbsettingQiniuHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) => QiniuPage(),
);

// picgo设置页面
var picgosettingHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) =>
      PicGoSettingPage(),
);

// 主题设置页面
var picggsettingThemeHandler = new Handler(
  handlerFunc: (context, parameters) => ThemeSettingPage(),
);

