import 'dart:convert';

import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picgo/model/config.dart';
import 'package:flutter_picgo/model/qiniu_config.dart';
import 'package:flutter_picgo/resources/pb_type_keys.dart';
import 'package:flutter_picgo/routers/application.dart';
import 'package:flutter_picgo/routers/routers.dart';
import 'package:flutter_picgo/utils/strings.dart';
import 'package:flutter_picgo/views/pb_setting_page/base_pb_page_state.dart';

class QiniuPage extends StatefulWidget {
  _QiniuPageState createState() => _QiniuPageState();
}

class _QiniuPageState extends BasePBSettingPageState<QiniuPage> {
  @override
  String get pbType => PBTypeKeys.qiniu;

  @override
  onLoadConfig(String config) {
    List<Config> configs = [];
    Map<String, dynamic> map;
    if (isBlank(config)) {
      map = QiniuConfig().toJson();
    } else {
      map = QiniuConfig.fromJson(json.decode(config)).toJson();
    }
    map.forEach((key, value) {
      Config config;
      if (key == 'accessKey') {
        config = Config(
            label: '设定AccessKey',
            placeholder: 'AccessKey',
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
            placeholder: 'Bucket',
            needValidate: true,
            value: value);
      } else if (key == 'url') {
        config = Config(
            label: '设定访问网址',
            placeholder: '例如：http://xxx.yyy.cloudcdn.cn',
            needValidate: true,
            value: value);
      } else if (key == 'area') {
        config = Config(
            label: '确认存储区域',
            placeholder: '例如z0',
            needValidate: true,
            value: value);
      } else if (key == 'options') {
        config =
            Config(label: '设定网址后缀', placeholder: '例如?imageslim', value: value);
      } else if (key == 'path') {
        config = Config(label: '指定存储路径', placeholder: '例如img/', value: value);
      }
      config.name = key;
      configs.add(config);
    });
    setConfigs(configs);
  }

  @override
  String get title => '七牛图床';

  @override
  bool get isSupportManage => true;

  @override
  handleManage() {
    Application.router.navigateTo(context,
        '${Routes.settingPbQiniuRepo}?path=${Uri.encodeComponent("/")}',
        transition: TransitionType.cupertino);
  }
}
