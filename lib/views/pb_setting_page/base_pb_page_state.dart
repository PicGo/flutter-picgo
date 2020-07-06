import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picgo/model/config.dart';
import 'package:flutter_picgo/utils/image_upload.dart';
import 'package:flutter_picgo/utils/strings.dart';
import 'package:toast/toast.dart';

/// 图床设置页面基类，使用该类则需要遵循规则，可自动将数据转化成配置页面，自动生成输入框等以及保存方法
abstract class BasePBSettingPageState<T extends StatefulWidget>
    extends State<T> {
  Map<String, TextEditingController> controllers = {};
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar ?? AppBar(),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
            // 配置列表根据List Configs自动生成
            _generateConfigRow(),
            SizedBox(height: 10),
            // 保存以及设置默认图床按钮
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      color: Theme.of(context).accentColor,
                      textColor: Colors.white,
                      child: Text('保存'),
                      onPressed: () {
                        //_saveConfig();
                        if (validate) {
                          save();
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 5.0),
                  Expanded(
                    child: RaisedButton(
                      color: Colors.greenAccent,
                      textColor: Colors.white,
                      child: Text('设为默认图床'),
                      onPressed: () {
                        if (validate) {
                          _setDefaultPB();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Text(
                '请先保存后再进行连接测试',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[400]),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// 生成配置输入框
  Widget _generateConfigRow() {
    if (configs == null || configs.length == 0) {
      return Column(
        children: <Widget>[
          SizedBox(height: 20),
          Center(
            child: Text('无需配置'),
          )
        ],
      );
    }
    return Form(
      key: _formKey,
      child: Column(
        children: configs.asMap().keys.map((i) {
          if (isBlank(configs[i].name)) {
            throw ArgumentError('name must be not null');
          }
          // new TextEditingController
          TextEditingController controller =
              TextEditingController(text: configs[i].value ?? '');
          // add
          controllers[configs[i].name] = controller;
          // text TextFormField
          return Column(
            children: <Widget>[
              SizedBox(height: i == 0 ? 0 : 5),
              TextFormField(
                controller: controller,
                decoration: new InputDecoration(
                  labelText: configs[i].label ?? '',
                  hintText: configs[i].placeholder ?? '',
                ),
                keyboardType: TextInputType.text,
                validator: configs[i].needValidate ?? false
                    ? (value) {
                        if (value == null || value == '') {
                          return '必填项不能为空';
                        }
                        return null;
                      }
                    : null,
              )
            ],
          );
        }).toList(),
      ),
    );
  }

  List<Config> configs;

  // 子类主动调用
  setConfigs(List<Config> configs) {
    if (configs != null) {
      setState(() {
        this.configs = configs;
      });
    }
  }

  /// 子类自定义AppBar，不实现则默认为空实现AppBar()
  AppBar get appbar;

  /// 当前图床类型
  String get pbType;

  /// 表单验证
  bool get validate => _formKey.currentState.validate();

  /// 保存配置
  save() async {
    if (isBlank(pbType)) {
      return;
    }
    try {
      Map<String, dynamic> configMap = {};
      controllers.forEach((key, value) {
        configMap[key] = value.text.trim();
      });
      String configStr = json.encode(configMap);
      int row = await ImageUploadUtils.savePBConfig(pbType, configStr);
      if (row > 0) {
        Toast.show('保存成功', context);
      } else {
        Toast.show('保存失败', context);
      }
    } catch (e) {
      Toast.show('$e', context, duration: Toast.LENGTH_LONG);
    }
  }

  /// 配置默认图床
  _setDefaultPB() async {
    if (!isBlank(pbType)) {
      await ImageUploadUtils.setDefaultPB(pbType);
      Toast.show('设置成功', context);
    }
  }
}
