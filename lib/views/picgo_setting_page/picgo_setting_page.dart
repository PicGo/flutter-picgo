import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_picgo/utils/shared_preferences.dart';

class PicGoSettingPage extends StatefulWidget {

  @override
  _PicGoSettingPageState createState() => _PicGoSettingPageState();

}

class _PicGoSettingPageState extends State<PicGoSettingPage> {

  bool isUploadedRename = false;
  bool isTimestampRename = false;
  bool isUploadedTip = false;

  @override
  void initState() {
    super.initState();
    SpUtil.getInstance().then((u) {
      setState(() {
        this.isUploadedRename = u?.getBool(SharedPreferencesKeys.settingIsUploadedRename) ?? false;
        this.isTimestampRename = u?.getBool(SharedPreferencesKeys.settingIsTimestampRename) ?? false;
        this.isUploadedTip = u?.getBool(SharedPreferencesKeys.settingIsUploadedTip) ?? false;
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
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('上传前重命名'),
            trailing: CupertinoSwitch(
              value: this.isUploadedRename,
              onChanged: (value) {
                this._save(SharedPreferencesKeys.settingIsUploadedRename, value);
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
                this._save(SharedPreferencesKeys.settingIsTimestampRename, value);
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
              onChanged: (value) {
                this._save(SharedPreferencesKeys.settingIsUploadedTip, value);
                setState(() {
                  this.isUploadedTip = value;
                });
              },
            ),
          ),
          ListTile(
            title: Text('设置显示图床'),
            onTap: () {

            },
          ),
          ListTile(
            title: Text('检查更新'),
            onTap: () {
              
            },
          ),
        ],
      ),
    );
  }

  void _save(String key, bool value) async {
    var instance = await SpUtil.getInstance();
    instance.putBool(key, value);
  }

}
