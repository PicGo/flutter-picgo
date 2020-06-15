import 'package:flutter/material.dart';

import '../page/main_tabs.dart';
import '../page/album.dart';
import '../page/setting.dart';

final routes = {
  MainTabsPage.routeName: (BuildContext context) => MainTabsPage(),
  AlbumPage.routeName: (BuildContext context) => AlbumPage(),
  SettingPage.routeName: (BuildContext context) => SettingPage(),
};

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