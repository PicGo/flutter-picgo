import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import 'package:flutter_picgo/views/home.dart';
import 'package:flutter_picgo/views/album_page/album_page.dart';
import 'package:flutter_picgo/views/pb_setting_page/pb_setting_page.dart';
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
    } catch (e) {
    }
    return AppPage(selectedIndex: index);
  },
);

var notfoundHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) => PageNotFound(),
);

var albumHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) => AlbumPage(),
);

var settingHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) => SettingPage(),
);

var pbsettingHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) => PBSettingPage(),
);

var pbsettingGithubHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) => GithubPage()
);

var picgosettinghandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) => PicGoSettingPage(),
);