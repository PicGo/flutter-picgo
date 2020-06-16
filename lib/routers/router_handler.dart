import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import 'package:flutter_picgo/views/app_page/app_page.dart';
import 'package:flutter_picgo/views/album_page/album_page.dart';
import 'package:flutter_picgo/views/pb_setting_page/pb_setting_page.dart';
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
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return PageNotFound();
  },
);

var albumHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return AlbumPage();
  },
);

var settingHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return SettingPage();
  },
);

var pbsettingHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return PBSettingPage();
  },
);

var picgosettinghandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return PicGoSettingPage();
  },
);