import 'package:barcode_scan/barcode_scan.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picgo/model/pb_setting.dart';
import 'package:flutter_picgo/routers/application.dart';
import 'package:flutter_picgo/utils/permission.dart';
import 'package:flutter_picgo/views/pb_setting_page/pb_setting_presenter.dart';
import 'package:permission_handler/permission_handler.dart';

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
            onPressed: () {
              _scanCode();
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
    );
  }

  _scanCode() async {
    var status = await PermissionUtils.requestCemera();
    if (status == PermissionStatus.granted) {
      var result = await BarcodeScanner.scan();
      print(result.type); // The result type (barcode, cancelled, failed)
      print(result.rawContent); // The barcode content
      print(result.format); // The barcode format (as enum)
      print(result.formatNote); //
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
}
