import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_picgo/api/picgo_api.dart';
import 'package:flutter_picgo/routers/application.dart';
import 'package:flutter_picgo/routers/routers.dart';
import 'package:flutter_picgo/utils/local_notification.dart';
import 'package:flutter_picgo/utils/shared_preferences.dart';
import 'package:package_info/package_info.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class PicGoSettingPage extends StatefulWidget {
  @override
  _PicGoSettingPageState createState() => _PicGoSettingPageState();
}

class _PicGoSettingPageState extends State<PicGoSettingPage> {
  bool isUploadedRename = false;
  bool isTimestampRename = false;
  bool isUploadedTip = false;
  bool isForceDelete = false;
  bool isNeedUpdate = false;

  @override
  void initState() {
    super.initState();
    SpUtil.getInstance().then((u) {
      setState(() {
        this.isUploadedRename =
            u?.getBool(SharedPreferencesKeys.settingIsUploadedRename) ?? false;
        this.isTimestampRename =
            u?.getBool(SharedPreferencesKeys.settingIsTimestampRename) ?? false;
        this.isUploadedTip =
            u?.getBool(SharedPreferencesKeys.settingIsUploadedTip) ?? false;
        this.isForceDelete =
            u?.getBool(SharedPreferencesKeys.settingIsForceDelete) ?? false;
      });
    });
    // update
    _getLatestVersion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PicGo设置'),
        centerTitle: true,
      ),
      body: Builder(
        builder: (BuildContext context) {
          return ListView(
            children: <Widget>[
              ListTile(
                title: Text('上传前重命名'),
                trailing: CupertinoSwitch(
                  value: this.isUploadedRename,
                  onChanged: (value) {
                    this._save(
                        SharedPreferencesKeys.settingIsUploadedRename, value);
                    setState(() {
                      this.isUploadedRename = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: Text('时间戳重命名'),
                trailing: CupertinoSwitch(
                  value: this.isTimestampRename,
                  onChanged: (value) {
                    this._save(
                        SharedPreferencesKeys.settingIsTimestampRename, value);
                    setState(() {
                      this.isTimestampRename = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: Text('开启上传提示'),
                trailing: CupertinoSwitch(
                  value: this.isUploadedTip,
                  onChanged: (value) async {
                    if (value) {
                      /// Local Notification 请求权限
                      await LocalNotificationUtil.getInstance()
                          .requestPermissions();
                    }
                    this._save(
                        SharedPreferencesKeys.settingIsUploadedTip, value);
                    setState(() {
                      this.isUploadedTip = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: Text('仅删除本地图片'),
                trailing: CupertinoSwitch(
                  value: this.isForceDelete,
                  onChanged: (value) {
                    this._save(
                        SharedPreferencesKeys.settingIsForceDelete, value);
                    setState(() {
                      this.isForceDelete = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: Text('主题设置'),
                onTap: () {
                  Application.router.navigateTo(
                      context, Routes.settingPicgoTheme,
                      transition: TransitionType.cupertino);
                },
              ),
              // ListTile(
              //   title: Text('设置显示图床'),
              //   onTap: () {},
              // ),
              ListTile(
                title: Text('版本更新'),
                onTap: () {
                  _handleUpdateTap();
                },
                trailing: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Container(
                    width: 8,
                    height: 8,
                    // color: Colors.red,
                    decoration: BoxDecoration(
                        color: isNeedUpdate ? Colors.red : Colors.transparent,
                        borderRadius: BorderRadius.circular(4)),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  _save(String key, bool value) async {
    var instance = await SpUtil.getInstance();
    instance.putBool(key, value);
    Toast.show('保存成功', context);
  }

  _getLatestVersion() async {
    try {
      Response res = await PicgoApi.getLatestVersion();
      PackageInfo info = await PackageInfo.fromPlatform();
      int version = int.parse(info.buildNumber);
      debugPrint('$version');
      int remoteVersion = 0;
      if (Platform.isAndroid) {
        remoteVersion = int.parse('${res.data["Android"]["versionCode"]}');
      } else if (Platform.isIOS) {
        remoteVersion = int.parse('${res.data["iOS"]["versionCode"]}');
      }
      if (version < remoteVersion) {
        setState(() {
          this.isNeedUpdate = true;
        });
      }
    } catch (e) {}
  }

  /// 无论有无更新都进行跳转，不允许放置蒲公英链接
  _handleUpdateTap() async {
    if (Platform.isAndroid) {
      launch('https://github.com/PicGo/flutter-picgo/releases');
    } else if (Platform.isIOS) {
      launch('https://apps.apple.com/cn/app/flutter-picgo/id1519714305');
    }
  }
}
