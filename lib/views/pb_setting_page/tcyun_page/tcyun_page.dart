import 'package:flutter/material.dart';
import 'package:flutter_picgo/resources/pb_type_keys.dart';
import 'package:flutter_picgo/views/pb_setting_page/base_pb_page_state.dart';

class TcyunPage extends StatefulWidget {
  _TcyunPageState createState() => _TcyunPageState();
}

class _TcyunPageState extends BasePBSettingPageState<TcyunPage> {
  @override
  AppBar get appbar => AppBar(
        title: Text('腾讯云COS图床'),
        centerTitle: true,
      );

  @override
  String get pbType => PBTypeKeys.tcyun;
}
