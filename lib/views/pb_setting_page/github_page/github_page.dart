import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picgo/components/loading.dart';
import 'package:flutter_picgo/model/github_config.dart';
import 'package:flutter_picgo/resources/pb_type_keys.dart';
import 'package:flutter_picgo/routers/application.dart';
import 'package:flutter_picgo/routers/routers.dart';
import 'package:flutter_picgo/utils/image_upload.dart';
import 'package:flutter_picgo/views/pb_setting_page/github_page/github_page_presenter.dart';
import 'package:toast/toast.dart';

class GithubPage extends StatefulWidget {
  @override
  _GithubPageState createState() => _GithubPageState();
}

class _GithubPageState extends State<GithubPage> implements GithubPageContract {
  GithubConfig _config;
  bool _configSuccess = false;

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
          _configSuccess
              ? IconButton(
                  // 开启仓库
                  icon: Icon(IconData(0xe6ab, fontFamily: 'iconfont')),
                  onPressed: () {
                    Application.router.navigateTo(context,
                        '${Routes.settingPbGitubRepo}?path=${Uri.encodeComponent("/")}',
                        transition: TransitionType.cupertino);
                  },
                )
              : IconButton(
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
                    decoration: new InputDecoration(
                        labelText: "指定存储路径", hintText: "例如 wallpaper/"),
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 5),
                  TextFormField(
                    controller: _customDomainController,
                    decoration: new InputDecoration(
                        labelText: "设置自定义域名",
                        hintText: "例如 https://www.baidu.com/"),
                    keyboardType: TextInputType.url,
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
    if (_formKey.currentState.validate()) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return NetLoadingDialog(
            loading: true,
            loadingText: "测试连接中...",
            requestCallBack: _presenter.doTestConfig(),
          );
        },
      );
    }
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

  void _setDefaultPB() async {
    if (_formKey.currentState.validate()) {
      await ImageUpload.setDefaultPB(PBTypeKeys.github);
      Toast.show('设置成功', context);
    }
  }

  @override
  loadConfig(GithubConfig config) {
    setState(() {
      this._config = config;
    });
  }

  @override
  saveConfigSuccess() {
    Toast.show("保存成功", context,
        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
  }

  @override
  showError(String errorMsg) {
    Toast.show(errorMsg, context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  }

  @override
  testConfigSuccess() {
    setState(() {
      this._configSuccess = true;
    });
    Toast.show("测试成功", context,
        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
  }
}
