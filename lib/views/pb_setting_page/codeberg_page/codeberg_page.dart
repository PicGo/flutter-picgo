import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_picgo/model/config.dart';
import 'package:flutter_picgo/model/codeberg_config.dart';
import 'package:flutter_picgo/resources/pb_type_keys.dart';
import 'package:flutter_picgo/utils/strings.dart';
import 'package:flutter_picgo/views/pb_setting_page/base_pb_page_state.dart';

class CodebergPage extends StatefulWidget {
  @override
  _CodebergPageState createState() => _CodebergPageState();
}

class _CodebergPageState extends BasePBSettingPageState<CodebergPage> {
  @override
  onLoadConfig(String config) {
    List<Config> configs = [];
    Map<String, dynamic> map;
    if (isBlank(config)) {
      map = CodebergConfig().toJson();
    } else {
      map = CodebergConfig.fromJson(json.decode(config)).toJson();
    }
    map.forEach((key, value) {
      Config config;
      if (key == 'repo') {
        config = Config(
            label: '设定仓库名',
            placeholder: '例如 yourname/picbed',
            needValidate: true,
            value: value);
      } else if (key == 'token') {
        config = Config(
            label: '设定Token',
            placeholder: 'Codeberg Personal Access Token',
            needValidate: true,
            value: value);
      } else if (key == 'customUrl') {
        config = Config(
            label: '设定自定义域名',
            placeholder: '例如：https://your.domain.com',
            value: value);
      } else if (key == 'branch') {
        config = Config(
            label: '确认分支名',
            placeholder: '例如 main',
            value: value,
            needValidate: true);
      } else if (key == 'path') {
        config = Config(label: '指定存储路径', placeholder: '例如 img/', value: value);
      }
      config.name = key;
      configs.add(config);
    });
    setConfigs(configs);
  }

  @override
  String get pbType => PBTypeKeys.codeberg;

  @override
  String get title => 'Codeberg图床';
}
