import 'package:flutter/material.dart';

import '../page/main_tabs.dart';
import '../page/album.dart';
import '../page/setting.dart';
import '../page/pb_setting.dart';
import '../page/picgo_setting.dart';

final routes = {
  MainTabsPage.routeName: (BuildContext context) => MainTabsPage(),
  AlbumPage.routeName: (BuildContext context) => AlbumPage(),
  SettingPage.routeName: (BuildContext context) => SettingPage(),
  PBSettingPage.routeName: (BuildContext context) => PBSettingPage(),
  PicGoSettingPage.routeName: (BuildContext context) => PicGoSettingPage(),
};

// path map
const MainTabsPagePath = MainTabsPage.routeName;
const AlbumPagePath = AlbumPage.routeName;
const SettingPagePath = SettingPage.routeName;
const PBSettingPagePath = PBSettingPage.routeName;
const PicGoSettingPagePath = PicGoSettingPage.routeName;

/*
 * 实现命名路由传参
 */
final Route<dynamic> Function(RouteSettings) onGenerateRoute = (RouteSettings settings) {
  final String name = settings.name;
  final Function pageContentBuilder = routes[name];
  if (pageContentBuilder != null) {
    if (settings.arguments != null) {
      final Route route = MaterialPageRoute(
        builder: (context) => pageContentBuilder(context, arguments: settings.arguments)
      );
      return route;
    } else {
      final Route route = MaterialPageRoute(
        builder: (context) => pageContentBuilder(context),
      );
      return route;
    }
  }
  return null;
};