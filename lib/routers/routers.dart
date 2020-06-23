import 'package:fluro/fluro.dart';
import 'package:flutter_picgo/routers/router_handler.dart';

class Routes {

  // 路由Map
  static const String root = '/';
  static const String album = '/album';
  static const String notfound = '/404';
  static const String setting = '/setting';
  static const String upload = '/upload';
  static const String settingPb = '/setting/pb';
  static const String settingPbGithub = '/setting/pb/github';
  static const String settingPbGitubRepo = '/setting/pb/github/repo';
  static const String settingPicgo = '/setting/picgo';

  static void configureRoutes(Router router) {
    router.notFoundHandler = notfoundHandler;
    router.define(root, handler: appHandler);
    router.define(notfound, handler: notfoundHandler);
    router.define(album, handler: albumHandler);
    router.define(upload, handler: uploadHandler);
    router.define(setting, handler: settingHandler);
    router.define(settingPb, handler: pbsettingHandler);
    router.define(settingPbGithub, handler: pbsettingGithubHandler);
    router.define(settingPbGitubRepo, handler: pbsettingGithubRepohandler);
    router.define(settingPicgo, handler: picgosettinghandler);
  }

}