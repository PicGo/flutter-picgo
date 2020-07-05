import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picgo/model/config.dart';
import 'package:flutter_picgo/model/qiniu_config.dart';
import 'package:flutter_picgo/resources/pb_type_keys.dart';
import 'package:flutter_picgo/views/config_page/config_page.dart';
import 'package:flutter_picgo/views/pb_setting_page/qiniu_page/qiniu_page_presenter.dart';

class QiniuPage extends StatefulWidget {
  _QiniuPageState createState() => _QiniuPageState();
}

class _QiniuPageState extends ConfigPageState<QiniuPage> implements QiniuPageContract {

  QiniuPagePresenter _presenter;

  _QiniuPageState() {
    _presenter = QiniuPagePresenter(this);
  }

  @override
  void initState() {
    super.initState();
    _presenter.doLoadConfig();
  }

  @override
  String get pbType => PBTypeKeys.qiniu;

  @override
  void save() {
    
  }

  @override
  AppBar get appbar => AppBar(
    title: Text('七牛图床'),
    centerTitle: true,
  );

  @override
  loadConfig(QiniuConfig config) {
    List<Config> configs = [];
    config.toJson().forEach((key, value) {
      Config config;
      if (key == 'accessKey') {
        config = Config(
          label: '设定AccessKey',
          placeholder: 'AccessKey',
          needValidate: true,
          value: value
        );
      } else if (key == 'secretKey') {
        config = Config(
          label: '设定SecretKey',
          placeholder: 'SecretKey',
          needValidate: true,
          value: value
        );
      } else if (key == 'bucket') {
        config = Config(
          label: '设定存储空间名',
          placeholder: 'Bucket',
          needValidate: true,
          value: value
        );
      } else if (key == 'url') {
        config = Config(
          label: '设定访问网址',
          placeholder: '例如：http://xxx.yyy.cloudcdn.cn',
          needValidate: true,
          value: value
        );
      } else if (key == 'area') {
        config = Config(
          label: '确认存储区域',
          placeholder: '例如z0',
          needValidate: true,
          value: value
        );
      } else if (key == 'options') {
        config = Config(
          label: '设定网址后缀',
          placeholder: '例如?imageslim'
        );
      } else if (key == 'path') {
        config = Config(
          label: '指定存储路径',
          placeholder: '例如img/'
        );
      }
      config.name = key;
      configs.add(config);
    });
    setConfigs(configs);
  }
}
