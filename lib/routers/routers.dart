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
  static const String settingPicgo = '/setting/picgo';
  static const String settingPicgoTheme = '/setting/picgo/theme';
  // --------- github ------------------
  static const String settingPbGithub = '/setting/pb/github';
  static const String settingPbGitubRepo = '/setting/pb/github/repo';
  // -----------------------------------
  // --------- smms ------------------
  static const String settingPbSMMS = '/setting/pb/smms';
  static const String settingPbSMMSRepo = '/setting/pb/smms/repo';
  // -----------------------------------
  // --------- gitee ------------------
  static const String settingPbGitee = '/setting/pb/gitee';
  static const String settingPbGiteeRepo = '/setting/pb/gitee/repo';
  // -----------------------------------
  // --------- qiniu -------------------
  static const String settingPbQiniu = '/setting/pb/qiniu';
  static const String settingPbQiniuRepo = 'setting/pb/qiniu/repo';
  // -----------------------------------
  // --------- aliyun -------------------
  static const String settingPbAliyun = '/setting/pb/aliyun';
  // -----------------------------------
  // --------- tcyun -------------------
  static const String settingPbTcyun = '/setting/pb/tcyun';
  // -----------------------------------
  // --------- niupic -------------------
  static const String settingPbNiupic = '/setting/pb/niupic';
  // -----------------------------------
  // --------- lsky -------------------
  static const String settingPbLsky = '/setting/pb/lsky';
  static const String settingPbLskyRepo = '/setting/pb/lsky/repo';
  // -----------------------------------
  // --------- upyun -------------------
  static const String settingPbUpyun = '/setting/pb/upyun';
  // -----------------------------------

  static void configureRoutes(Router router) {
    router.notFoundHandler = notfoundHandler;
    router.define(root, handler: appHandler);
    router.define(notfound, handler: notfoundHandler);
    router.define(album, handler: albumHandler);
    router.define(upload, handler: uploadHandler);
    router.define(setting, handler: settingHandler);
    router.define(settingPb, handler: pbsettingHandler);
    router.define(settingPbGithub, handler: pbsettingGithubHandler);
    router.define(settingPbGitubRepo, handler: pbsettingGithubRepoHandler);
    router.define(settingPicgo, handler: picgosettingHandler);
    router.define(settingPbSMMS, handler: pbsettingSMMSHandler);
    router.define(settingPbGitee, handler: pbsettingGiteeHandler);
    router.define(settingPbGiteeRepo, handler: pbsettingGiteeRepoHandler);
    router.define(settingPicgoTheme, handler: picggsettingThemeHandler);
    router.define(settingPbQiniu, handler: pbsettingQiniuHandler);
    router.define(settingPbAliyun, handler: pbsettingAliyunHandler);
    router.define(settingPbTcyun, handler: pbsettingTcyunHandler);
    router.define(settingPbNiupic, handler: pbsettingNiupicHandler);
    router.define(settingPbLsky, handler: pbsettingLskyHandler);
    router.define(settingPbUpyun, handler: pbsettingUpyunHandler);
    router.define(settingPbSMMSRepo, handler: pbsettingSMMSRepoHandler);
    router.define(settingPbLskyRepo, handler: pbsettingLskyRepoHandler);
    router.define(settingPbQiniuRepo, handler: pbsettingQiniuRepoHandler);
  }
}
