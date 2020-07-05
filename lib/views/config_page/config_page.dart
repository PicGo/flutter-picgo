import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picgo/model/config.dart';

abstract class ConfigPageState<T extends StatefulWidget> extends State<T> {
  List<TextEditingController> controllers = [];
  String title;
  AppBar appbar;

  ConfigPageState({this.title = '', this.appbar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar,
      body: ListView(
        children: <Widget>[
          _generateConfigRow(),
          SizedBox(height: 10),
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
                      //_setDefaultPB();
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
    );
  }

  /// 生成配置输入框
  Widget _generateConfigRow() {
    if (configs == null || configs.length == 0) {
      return Center(
        child: Text('无需配置'),
      );
    }
    return Column(
      children: configs.asMap().keys.map((i) {
        // new TextEditingController
        TextEditingController controller =
            TextEditingController(text: configs[i].value);
        // add
        controllers.add(controller);
        // text TextFormField
        return Column(
          children: <Widget>[
            SizedBox(height: 5),
            TextFormField(
              controller: controller,
              decoration: new InputDecoration(
                labelText: configs[i].label,
                hintText: configs[i].placeholder,
              ),
              keyboardType: TextInputType.text,
              validator: configs[i].needValidate
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
    );
  }

  List<Config> get configs;
}
