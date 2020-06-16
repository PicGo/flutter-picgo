import 'package:fluro/fluro.dart';
import 'package:flutter_picgo/routers/router_handler.dart';

class Routes {

  // 路由Map
  static String root = '/';
  static String album = '/album';
  static String notfound = '/404';
  static String setting = '/setting';
  static String settingPb = '/setting/pb';
  static String settingPbGithub = '/setting/pb/github';
  static String settingPicgo = '/setting/picgo';

  static void configureRoutes(Router router) {
    router.notFoundHandler = notfoundHandler;
    router.define(root, handler: appHandler);
    router.define(notfound, handler: notfoundHandler);
    router.define(album, handler: albumHandler);
    router.define(setting, handler: settingHandler);
    router.define(settingPb, handler: pbsettingHandler);
    router.define(settingPbGithub, handler: pbsettingGithubHandler);
    router.define(settingPicgo, handler: picgosettinghandler);
  }

}