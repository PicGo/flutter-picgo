import 'package:barcode_scan/barcode_scan.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_picgo/model/pb_setting.dart';
import 'package:flutter_picgo/routers/application.dart';
import 'package:flutter_picgo/utils/permission.dart';
import 'package:flutter_picgo/views/pb_setting_page/pb_setting_presenter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toast/toast.dart';

class PBSettingPage extends StatefulWidget {
  @override
  _PBSettingPageState createState() => _PBSettingPageState();
}

class _PBSettingPageState extends State<PBSettingPage>
    implements PBSettingPageContract {
  List<PBSetting> _settings;
  String _errorTip;

  PBSettingPagePresenter _presenter;

  _PBSettingPageState() {
    _presenter = PBSettingPagePresenter(this);
  }

  @override
  void initState() {
    super.initState();
    _presenter.doLoadPb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('图床设置'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(IconData(0xe685, fontFamily: 'iconfont')),
            onPressed: () async {
              await showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('关于使用二维码扫描说明'),
                      content: Text('该功能是为了方便使用了PicGo PC端的用户。\n\n' +
                          '在PC端已经配置好的用户可以使用PicGo新版的生成图床配置二维码功能。\n\n' +
                          '然后使用Flutter-PicGo直接扫描即可进行配置转换。'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('已了解，去扫描'),
                          onPressed: () {
                            Navigator.pop(context);
                            _scanCode();
                          },
                        )
                      ],
                    );
                  });
            },
          ),
        ],
      ),
      body: this._settings == null
          ? Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                child: Text(
                  this._errorTip ?? '暂无图床数据',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            )
          : ListView.builder(
              itemCount: this._settings?.length ?? 0,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_settings[index].name),
                  onTap: () {
                    Application.router.navigateTo(
                        context, _settings[index].path,
                        transition: TransitionType.cupertino);
                  },
                  trailing: Icon(Icons.arrow_right),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(IconData(0xe62c, fontFamily: 'iconfont')),
        tooltip: '导出配置',
        onPressed: () {
          _presenter.doExportConfig();
        },
      ),
    );
  }

  /// 扫描二维码
  _scanCode() async {
    var status = await PermissionUtils.requestCemera();
    if (status == PermissionStatus.granted) {
      var result = await BarcodeScanner.scan();
      if (result.type == ResultType.Barcode) {
        _presenter.doTransferJson(result.rawContent);
      }
    } else {
      PermissionUtils.showPermissionDialog(context);
    }
  }

  @override
  void loadError(String errorMsg) {
    setState(() {
      this._errorTip = errorMsg;
    });
  }

  @override
  void loadPb(List<PBSetting> settings) {
    setState(() {
      this._settings = settings;
    });
  }

  @override
  void transferError(String e) {
    Toast.show(e, context, duration: Toast.LENGTH_LONG);
  }

  @override
  void transferSuccess() {
    Toast.show('配置已转换', context);
  }

  @override
  void exportConfigSuccess(String config) {
    Clipboard.setData(ClipboardData(text: config));
    Toast.show('已将配置导出至剪切板', context);
  }

  @override
  void exportConfigError(String message) {
    Toast.show('导出失败 : $message', context);
  }
}
