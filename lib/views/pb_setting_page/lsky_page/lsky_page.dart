import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_picgo/model/config.dart';
import 'package:flutter_picgo/model/lsky_config.dart';
import 'package:flutter_picgo/resources/pb_type_keys.dart';
import 'package:flutter_picgo/utils/strings.dart';
import 'package:flutter_picgo/views/pb_setting_page/base_pb_page_state.dart';

class LskyPage extends StatefulWidget {
  _LskyPageState createState() => _LskyPageState();
}

class _LskyPageState extends BasePBSettingPageState<LskyPage> {
  @override
  AppBar get appbar => AppBar(
        title: Text('兰空图床'),
        centerTitle: true,
      );

  @override
  onLoadConfig(String config) {
    List<Config> configs = [];
    Map<String, dynamic> map;
    if (isBlank(config)) {
      map = LskyConfig().toJson();
    } else {
      map = LskyConfig.fromJson(json.decode(config)).toJson();
    }
    map.forEach((key, value) {
      Config config;
      if (key == 'host') {
        config = Config(
            label: '设定Host',
            placeholder: '例如：https://lsky.si-yee.com',
            needValidate: true,
            value: value);
      } else if (key == 'token') {
        config = Config(
            label: '设定Token',
            placeholder: 'token',
            needValidate: true,
            value: value);
      }
      config.name = key;
      configs.add(config);
    });
    setConfigs(configs);
  }

  @override
  String get pbType => PBTypeKeys.lsky;
}
