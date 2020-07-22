import 'package:flutter/material.dart';
import 'package:flutter_picgo/resources/pb_type_keys.dart';
import 'package:flutter_picgo/views/pb_setting_page/base_pb_page_state.dart';

class NiupicPage extends StatefulWidget {
  _NiupicPageState createState() => _NiupicPageState();
}

class _NiupicPageState extends BasePBSettingPageState<NiupicPage> {
  @override
  AppBar get appbar => AppBar(
        title: Text('牛图网图床'),
        centerTitle: true,
      );

  @override
  onLoadConfig(String config) {}

  @override
  String get pbType => PBTypeKeys.niupic;
}
