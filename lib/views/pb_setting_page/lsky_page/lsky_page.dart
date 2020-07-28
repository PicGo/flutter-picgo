import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_picgo/api/lsky_api.dart';
import 'package:flutter_picgo/model/config.dart';
import 'package:flutter_picgo/model/lsky_config.dart';
import 'package:flutter_picgo/resources/pb_type_keys.dart';
import 'package:flutter_picgo/utils/strings.dart';
import 'package:flutter_picgo/views/pb_setting_page/base_pb_page_state.dart';
import 'package:toast/toast.dart';

class LskyPage extends StatefulWidget {
  _LskyPageState createState() => _LskyPageState();
}

class _LskyPageState extends BasePBSettingPageState<LskyPage> {
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
            placeholder: 'Token',
            needValidate: false,
            value: value);
      } else if (key == 'email') {
        config = Config(
            label: '设定邮箱',
            placeholder: 'Email',
            needValidate: true,
            value: value);
      } else if (key == 'password') {
        config = Config(
            label: '设定密码',
            placeholder: '设定密码',
            needValidate: true,
            value: value);
      }
      config.name = key;
      configs.add(config);
    });
    setConfigs(configs);
  }

  @override
  String get tip => '点击保存会自动获取Token，如果已填写字段则不会自动生成';

  @override
  String get pbType => PBTypeKeys.lsky;

  @override
  save() async {
    if (isBlank(controllers['token'].text.trim())) {
      // 如果Token为空，则自动获取
      String email = controllers['email'].value.text.trim();
      String pwd = controllers['password'].value.text.trim();
      String host = controllers['host'].value.text.trim();
      var result = await LskyApi.token(email, pwd, host);
      if (result["code"] == 200) {
        // controllers["token"].text = '${result["data"]["token"]}';
        setState(() {
          configs[3].value = '${result["data"]["token"]}';

          super.save();
        });
      } else {
        Toast.show('Token获取失败，请检查配置', context);
      }
    } else {
      return super.save();
    }
  }

  @override
  String get title => '兰空图床';
}
