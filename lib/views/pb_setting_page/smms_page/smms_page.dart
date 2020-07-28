import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_picgo/model/config.dart';
import 'package:flutter_picgo/model/smms_config.dart';
import 'package:flutter_picgo/resources/pb_type_keys.dart';
import 'package:flutter_picgo/utils/strings.dart';
import 'package:flutter_picgo/views/pb_setting_page/base_pb_page_state.dart';

class SMMSPage extends StatefulWidget {
  _SMMSPageState createState() => _SMMSPageState();
}

class _SMMSPageState extends BasePBSettingPageState<SMMSPage> {
  @override
  onLoadConfig(String config) {
    List<Config> configs = [];
    Map<String, dynamic> map;
    if (isBlank(config)) {
      map = SMMSConfig().toJson();
    } else {
      map = SMMSConfig.fromJson(json.decode(config)).toJson();
    }
    map.forEach((key, value) {
      Config config;
      if (key == 'token') {
        config = Config(
            label: '设定Token',
            placeholder: 'Token',
            needValidate: true,
            value: value);
      }
      config.name = key;
      configs.add(config);
    });
    setConfigs(configs);
  }

  @override
  String get pbType => PBTypeKeys.smms;

  @override
  String get title => 'SM.MS图床';
}
