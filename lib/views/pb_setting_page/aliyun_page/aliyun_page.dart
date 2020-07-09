import 'package:flutter/material.dart';
import 'package:flutter_picgo/model/aliyun_config.dart';
import 'package:flutter_picgo/model/config.dart';
import 'package:flutter_picgo/resources/pb_type_keys.dart';
import 'package:flutter_picgo/views/pb_setting_page/aliyun_page/aliyun_page_presenter.dart';
import 'package:flutter_picgo/views/pb_setting_page/base_pb_page_state.dart';

class AliyunPage extends StatefulWidget {
  _AliyunPageState createState() => _AliyunPageState();
}

class _AliyunPageState extends BasePBSettingPageState<AliyunPage>
    implements AliyunPageContract {
  AliyunPagePresenter _presenter;

  _AliyunPageState() {
    _presenter = AliyunPagePresenter(this);
  }

  @override
  void initState() {
    super.initState();
    _presenter.doLoadConfig();
  }

  @override
  AppBar get appbar => AppBar(
        title: Text('阿里云OSS图床'),
        centerTitle: true,
      );

  @override
  String get pbType => PBTypeKeys.aliyun;

  @override
  loadConfig(AliyunConfig config) {
    List<Config> configs = [];
    config.toJson().forEach((key, value) {
      Config config;
      if (key == 'accessKeyId') {
        config = Config(
            label: '设定KeyId',
            placeholder: 'AccessKeyId',
            needValidate: true,
            value: value);
      } else if (key == 'accessKeySecret') {
        config = Config(
            label: '设定KeySecret',
            placeholder: 'AccessKeySecret',
            needValidate: true,
            value: value);
      } else if (key == 'bucket') {
        config = Config(
            label: '设定存储空间名',
            placeholder: 'Bucket',
            needValidate: true,
            value: value);
      } else if (key == 'customUrl') {
        config = Config(
            label: '设定自定义域名',
            placeholder: '例如：http://xxx.yyy.cn',
            value: value);
      } else if (key == 'area') {
        config = Config(
            label: '确认存储区域',
            placeholder: '例如oss-cn-beijing',
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
}
