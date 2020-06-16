import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picgo/routers/application.dart';
import 'package:flutter_picgo/routers/routers.dart';

class PBSettingPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('图床设置'),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Github图床'),
            onTap: () {
              Application.router.navigateTo(context, Routes.settingPbGithub, transition: TransitionType.cupertino);
            },
            trailing: Icon(Icons.arrow_right),
          ),
        ],
      ),
    );
  }

}