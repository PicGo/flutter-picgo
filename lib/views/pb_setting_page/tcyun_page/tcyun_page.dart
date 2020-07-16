import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_picgo/model/config.dart';
import 'package:flutter_picgo/model/tcyun_config.dart';
import 'package:flutter_picgo/resources/pb_type_keys.dart';
import 'package:flutter_picgo/utils/strings.dart';
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

  @override
  onLoadConfig(String config) {
    List<Config> configs = [];
    Map<String, dynamic> map;
    if (isBlank(config)) {
      map = TcyunConfig().toJson();
    } else {
      map = TcyunConfig.fromJson(json.decode(config)).toJson();
    }
    map.forEach((key, value) {
      Config config;
      if (key == 'secretId') {
        config = Config(
            label: '设定SecretId',
            placeholder: 'SecretId',
            needValidate: true,
            value: value);
      } else if (key == 'secretKey') {
        config = Config(
            label: '设定SecretKey',
            placeholder: 'SecretKey',
            needValidate: true,
            value: value);
      } else if (key == 'bucket') {
        config = Config(
            label: '设定存储空间名',
            placeholder: '例如test-1253954259',
            needValidate: true,
            value: value);
      } else if (key == 'area') {
        config = Config(
            label: '确认存储区域',
            placeholder: '例如tj',
            needValidate: true,
            value: value);
      } else if (key == 'path') {
        config = Config(label: '指定存储路径', placeholder: '例如img/', value: value);
      } else if (key == 'customUrl') {
        config = Config(
            label: '设定自定义域名',
            placeholder: '例如：http://xxx.yyy.cn',
            value: value);
      }
      config.name = key;
      configs.add(config);
    });
    setConfigs(configs);
  }
}
