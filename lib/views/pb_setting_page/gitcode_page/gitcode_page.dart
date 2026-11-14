import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_picgo/model/config.dart';
import 'package:flutter_picgo/model/gitcode_config.dart';
import 'package:flutter_picgo/resources/pb_type_keys.dart';
import 'package:flutter_picgo/utils/strings.dart';
import 'package:flutter_picgo/views/pb_setting_page/base_pb_page_state.dart';

class GitcodePage extends StatefulWidget {
  @override
  _GitcodePageState createState() => _GitcodePageState();
}

class _GitcodePageState extends BasePBSettingPageState<GitcodePage> {
  @override
  onLoadConfig(String config) {
    List<Config> configs = [];
    Map<String, dynamic> map;
    if (isBlank(config)) {
      map = GitcodeConfig().toJson();
    } else {
      map = GitcodeConfig.fromJson(json.decode(config)).toJson();
    }
    map.forEach((key, value) {
      Config config;
      if (key == 'owner') {
        config = Config(
            label: '设定仓库所属空间地址',
            placeholder: '例如 yourname',
            needValidate: true,
            value: value);
      } else if (key == 'repo') {
        config = Config(
            label: '设定仓库名',
            placeholder: '例如 picbed',
            needValidate: true,
            value: value);
      } else if (key == 'token') {
        config = Config(
            label: '设定Token',
            placeholder: 'GitCode Personal Access Token',
            needValidate: true,
            value: value);
      } else if (key == 'customUrl') {
        config = Config(
            label: '设定自定义域名',
            placeholder: '例如：http://xxx.yyy.cloudcdn.cn，不推荐',
            value: value);
      } else if (key == 'branch') {
        config = Config(
            label: '确认分支名', placeholder: '不填默认master，建议填写', value: value);
      } else if (key == 'path') {
        config = Config(label: '指定存储路径', placeholder: '例如img/', value: value);
      }
      config.name = key;
      configs.add(config);
    });
    setConfigs(configs);
  }

  @override
  String get pbType => PBTypeKeys.gitcode;

  @override
  String get title => 'GitCode图床';
}
