import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picgo/model/config.dart';
import 'package:flutter_picgo/utils/image_upload.dart';
import 'package:flutter_picgo/utils/strings.dart';

abstract class BasePBSettingPageState<T extends StatefulWidget>
    extends State<T> {
  List<TextEditingController> controllers = [];
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
          // new TextEditingController
          TextEditingController controller =
              TextEditingController(text: configs[i].value ?? '');
          // add
          controllers.add(controller);
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

  AppBar get appbar;
  String get pbType;
  bool get validate => _formKey.currentState.validate();
  void save();

  /// 配置默认图床
  _setDefaultPB() {
    if (!isBlank(pbType)) {
      ImageUploadUtils.setDefaultPB(pbType);
    }
  }
}
