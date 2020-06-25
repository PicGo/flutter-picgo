import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_picgo/components/loading.dart';
import 'package:flutter_picgo/model/smms_config.dart';
import 'package:flutter_picgo/resources/pb_type_keys.dart';
import 'package:flutter_picgo/utils/image_upload.dart';
import 'package:flutter_picgo/views/pb_setting_page/smms_page/smms_page_presenter.dart';
import 'package:toast/toast.dart';

class SMMSPage extends StatefulWidget {
  _SMMSPageState createState() => _SMMSPageState();
}

class _SMMSPageState extends State<SMMSPage> implements SMMSPageContract {
  TextEditingController _tokenController;

  SMMSConfig _config;
  SMMSPagePresenter _presenter;

  final _formKey = GlobalKey<FormState>();

  _SMMSPageState() {
    _presenter = SMMSPagePresenter(this);
  }

  @override
  void initState() {
    super.initState();
    _presenter.doLoadConfig();
  }

  @override
  Widget build(BuildContext context) {
    _tokenController = TextEditingController(text: _config?.token ?? '');
    return Scaffold(
      appBar: AppBar(
        title: Text('SM.MS图床'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            //连接测试
            icon: Icon(IconData(0xe62a, fontFamily: 'iconfont')),
            onPressed: () {
              _testConfig();
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _tokenController,
                    obscureText: true,
                    decoration: new InputDecoration(
                      labelText: "设定 Token",
                    ),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value == '') {
                        return 'Token不能为空';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
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
                        _saveConfig();
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
                        _setDefaultPB();
                      },
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Text(
                '请先保存配置',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[400]),
              ),
            )
          ],
        ),
      ),
    );
  }

  _saveConfig() {
    if (_formKey.currentState.validate()) {
      var config = SMMSConfig(token: _tokenController.text.trim());
      _presenter.doSaveConfig(config);
    }
  }

  _setDefaultPB() {
    if (_formKey.currentState.validate()) {
      ImageUpload.setDefaultPB(PBTypeKeys.smms);
      Toast.show('设置成功', context);
    }
  }

  _testConfig() {
    showDialog(
        context: context,
        builder: (context) {
          return NetLoadingDialog(
              loading: true,
              requestCallBack: _presenter.doTestConfig(),
              loadingText: "测试连接中...",
              outsideDismiss: false);
        });
  }

  @override
  loadConfigFail(String msg) {
    Toast.show(msg, context);
  }

  @override
  loadConfigSuccess(SMMSConfig config) {
    setState(() {
      this._config = config;
    });
  }

  @override
  saveConfigFail(String msg) {
    Toast.show(msg, context);
  }

  @override
  saveConfigSuccess() {
    Toast.show('保存成功', context);
  }

  @override
  testConfigFail(String msg) {
    Toast.show(msg, context);
  }

  @override
  testConfigSuccess(String username) {
    Toast.show('测试连接成功，您的SM.MS用户名为$username', context);
  }
}
