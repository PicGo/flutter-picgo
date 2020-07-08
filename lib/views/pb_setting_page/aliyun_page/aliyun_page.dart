import 'package:flutter/material.dart';
import 'package:flutter_picgo/resources/pb_type_keys.dart';
import 'package:flutter_picgo/views/pb_setting_page/aliyun_page/aliyun_page_presenter.dart';
import 'package:flutter_picgo/views/pb_setting_page/base_pb_page_state.dart';

class AliyunPage extends StatefulWidget {
  _AliyunPageState createState() => _AliyunPageState();
}

class _AliyunPageState extends BasePBSettingPageState<AliyunPage>
    implements AliyunPageContract {
  @override
  AppBar get appbar => AppBar(
        title: Text('阿里云OSS图床'),
        centerTitle: true,
      );

  @override
  String get pbType => PBTypeKeys.aliyun;
}
