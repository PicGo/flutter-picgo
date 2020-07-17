import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_picgo/routers/application.dart';
import 'package:flutter_picgo/routers/routers.dart';
import 'package:flutter_picgo/utils/local_notification.dart';
import 'package:flutter_picgo/utils/shared_preferences.dart';
import 'package:toast/toast.dart';

class PicGoSettingPage extends StatefulWidget {
  @override
  _PicGoSettingPageState createState() => _PicGoSettingPageState();
}

class _PicGoSettingPageState extends State<PicGoSettingPage> {
  bool isUploadedRename = false;
  bool isTimestampRename = false;
  bool isUploadedTip = false;
  bool isForceDelete = false;

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
                title: Text('检查更新'),
                onTap: () {},
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
}
