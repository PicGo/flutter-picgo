import 'package:flutter/material.dart';
import 'package:flutter_picgo/model/github_config.dart';
import 'package:flutter_picgo/views/pb_setting_page/github_page/github_page_presenter.dart';
import 'package:toast/toast.dart';

class GithubPage extends StatefulWidget {
  @override
  _GithubPageState createState() => _GithubPageState();
}

class _GithubPageState extends State<GithubPage> implements GithubPageContract {
  BuildContext _ctx;
  GithubConfig _config;

  GithubPagePresenter _presenter;

  TextEditingController _repositoryNameController,
      _branchNameController,
      _tokenController,
      _storagePathController,
      _customDomainController;

  _GithubPageState() {
    _presenter = GithubPagePresenter(this);
  }

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _presenter.doLoadConfig();
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    _repositoryNameController =
        TextEditingController(text: _config?.repositoryName ?? '');
    _branchNameController =
        TextEditingController(text: _config?.branchName ?? '');
    _tokenController = TextEditingController(text: _config?.token ?? '');
    _storagePathController =
        TextEditingController(text: _config?.storagePath ?? '');
    _customDomainController =
        TextEditingController(text: _config?.customDomain ?? '');
    return Scaffold(
      appBar: AppBar(
        title: Text('Github图床'),
        actions: <Widget>[
          IconButton(
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
                    controller: _repositoryNameController,
                    decoration: new InputDecoration(
                      labelText: "设定仓库名",
                      hintText: "例如 hackycy/picture-bed",
                    ),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value == '') {
                        return '仓库名不能为空';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 5),
                  TextFormField(
                    controller: _branchNameController,
                    decoration: new InputDecoration(
                      labelText: "设定分支名",
                      hintText: "例如 master",
                    ),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value == '') {
                        return '分支名不能为空';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 5),
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
                  SizedBox(height: 5),
                  TextFormField(
                    controller: _storagePathController,
                    obscureText: true,
                    decoration: new InputDecoration(
                      labelText: "指定存储路径",
                    ),
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 5),
                  TextFormField(
                    controller: _customDomainController,
                    obscureText: true,
                    decoration: new InputDecoration(
                      labelText: "设置自定义域名",
                    ),
                    keyboardType: TextInputType.text,
                  )
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
          ],
        ),
      ),
    );
  }

  void _testConfig() {
    if (_formKey.currentState.validate()) {}
  }

  void _saveConfig() {
    if (_formKey.currentState.validate()) {
      var config = GithubConfig(
          repositoryName: _repositoryNameController.text,
          branchName: _branchNameController.text,
          token: _tokenController.text,
          storagePath: _storagePathController.text,
          customDomain: _customDomainController.text);
      _presenter.doSaveConfig(config);
    }
  }

  void _setDefaultPB() {
    if (_formKey.currentState.validate()) {}
  }

  @override
  loadConfig(GithubConfig config) {
    setState(() {
      this._config = config;
    });
  }

  @override
  saveConfigSuccess() {
    Toast.show("保存成功", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
  }

  @override
  showError(String errorMsg) {
    Toast.show(errorMsg, context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
  }
}