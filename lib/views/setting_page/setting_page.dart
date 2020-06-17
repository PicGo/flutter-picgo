import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picgo/routers/application.dart';
import 'package:flutter_picgo/routers/routers.dart';
import 'package:package_info/package_info.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String version;

  @override
  void initState() {
    super.initState();
    _getVersion();
  }

  void _getVersion() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      this.version = info.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('设置'),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          // 图标面板
          Container(
            width: double.infinity,
            height: 160.0,
            child: Column(
              children: <Widget>[
                SizedBox(height: 20),
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.cover,
                        width: 80,
                        height: 80,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: Text('v${this.version}'),
                ),
              ],
            ),
          ),
          // 菜单列表
          ListTile(
            title: Text('图床设置'),
            onTap: () {
              Application.router.navigateTo(context, Routes.settingPb, transition: TransitionType.cupertino);
            },
            trailing: Icon(Icons.arrow_right),
          ),
          ListTile(
            title: Text('PicGo设置'),
            onTap: () {
              Application.router.navigateTo(context, Routes.settingPicgo, transition: TransitionType.cupertino);
            },
            trailing: Icon(Icons.arrow_right),
          ),
          ListTile(
            title: Text('关于Flutter-PicGo'),
            onTap: () {
              // launch('https://github.com/hackycy/flutter_picgo');
            },
            trailing: Icon(Icons.arrow_right),
          ),
        ],
      ),
    );
  }
}
