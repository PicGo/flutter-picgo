import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class SettingPage extends StatefulWidget {
  static const routeName = '/setting';

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
                        'images/logo.png',
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
          ),
          ListTile(
            title: Text('PicGo设置'),
          ),
        ],
      ),
    );
  }
}
