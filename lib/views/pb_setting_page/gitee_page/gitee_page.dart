import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picgo/components/loading.dart';
import 'package:flutter_picgo/model/gitee_config.dart';
import 'package:flutter_picgo/resources/pb_type_keys.dart';
import 'package:flutter_picgo/routers/application.dart';
import 'package:flutter_picgo/routers/routers.dart';
import 'package:flutter_picgo/utils/image_upload.dart';
import 'package:flutter_picgo/views/pb_setting_page/gitee_page/gitee_page_presenter.dart';
import 'package:toast/toast.dart';

class GiteePage extends StatefulWidget {
  @override
  _GiteePageState createState() => _GiteePageState();
}

class _GiteePageState extends State<GiteePage> implements GiteePageContract {
  GiteeConfig _config;
  bool _configSuccess = false;

  GiteePagePresenter _presenter;

  TextEditingController _ownerController,
      _repositoryNameController,
      _branchNameController,
      _tokenController,
      _storagePathController,
      _customDomainController;

  _GiteePageState() {
    _presenter = GiteePagePresenter(this);
  }

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _presenter.doLoadConfig();
  }

  @override
  Widget build(BuildContext context) {
    _ownerController = TextEditingController(text: _config?.owner ?? '');
    _repositoryNameController =
        TextEditingController(text: _config?.repo ?? '');
    _branchNameController = TextEditingController(text: _config?.branch ?? '');
    _tokenController = TextEditingController(text: _config?.token ?? '');
    _storagePathController = TextEditingController(text: _config?.path ?? '');
    _customDomainController =
        TextEditingController(text: _config?.customUrl ?? '');
    return Scaffold(
      appBar: AppBar(
        title: Text('Gitee图床'),
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
                    controller: _ownerController,
                    decoration: new InputDecoration(
                      labelText: "设定仓库所属空间地址",
                      hintText: "例如 hackycy",
                    ),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value == '') {
                        return '所属空间地址不能为空';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 5),
                  TextFormField(
                    controller: _repositoryNameController,
                    decoration: new InputDecoration(
                      labelText: "设定仓库名",
                      hintText: "例如 picBed",
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
                    // validator: (value) {
                    //   if (value == null || value == '') {
                    //     return '分支名不能为空';
                    //   }
                    //   return null;
                    // },
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
                        hintText: "例如 https://www.baidu.com/ , 不建议配置"),
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
      var config = GiteeConfig(
          owner: _ownerController.text.trim(),
          repo: _repositoryNameController.text.trim(),
          branch: _branchNameController.text.trim(),
          token: _tokenController.text.trim(),
          path: _storagePathController.text.trim(),
          customUrl: _customDomainController.text.trim());
      _presenter.doSaveConfig(config);
    }
  }

  void _setDefaultPB() async {
    if (_formKey.currentState.validate()) {
      await ImageUploadUtils.setDefaultPB(PBTypeKeys.gitee);
      Toast.show('设置成功', context);
    }
  }

  @override
  loadConfig(GiteeConfig config) {
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
      _presenter.doLoadConfig();
    });
    Toast.show("测试成功", context,
        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
  }
}
