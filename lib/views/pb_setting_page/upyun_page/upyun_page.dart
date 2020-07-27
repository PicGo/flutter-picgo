import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_picgo/model/config.dart';
import 'package:flutter_picgo/model/upyun_config.dart';
import 'package:flutter_picgo/resources/pb_type_keys.dart';
import 'package:flutter_picgo/utils/strings.dart';
import 'package:flutter_picgo/views/pb_setting_page/base_pb_page_state.dart';

class UpyunPage extends StatefulWidget {
  _UpyunPageState createState() => _UpyunPageState();
}

class _UpyunPageState extends BasePBSettingPageState<UpyunPage> {
  @override
  AppBar get appbar => AppBar(
        title: Text('又拍云图床'),
        centerTitle: true,
      );

  @override
  onLoadConfig(String config) {
    List<Config> configs = [];
    Map<String, dynamic> map;
    if (isBlank(config)) {
      map = UpyunConfig().toJson();
    } else {
      map = UpyunConfig.fromJson(json.decode(config)).toJson();
    }
    map.forEach((key, value) {
      Config config;
      if (key == 'bucket') {
        config = Config(
            label: '设定存储空间名',
            placeholder: 'Bucket',
            needValidate: true,
            value: value);
      } else if (key == 'operator') {
        config = Config(
            label: '设定操作员',
            placeholder: '例如：me',
            needValidate: true,
            value: value);
      } else if (key == 'password') {
        config = Config(
            label: '设定操作员密码',
            placeholder: '输入密码',
            needValidate: true,
            value: value);
      } else if (key == 'url') {
        config = Config(
            label: '设定加速域名',
            placeholder: '例如https://xxx.yyy.com',
            needValidate: true,
            value: value);
      } else if (key == 'path') {
        config = Config(label: '指定存储路径', placeholder: '例如img/', value: value);
      } else if (key == 'options') {
        config =
            Config(label: '设定网址后缀', placeholder: '例如：!imgslim', value: value);
      }
      config.name = key;
      configs.add(config);
    });
    setConfigs(configs);
  }

  @override
  String get pbType => PBTypeKeys.upyun;
}
