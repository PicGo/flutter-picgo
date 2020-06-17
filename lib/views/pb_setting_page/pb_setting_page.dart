import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picgo/model/pb_setting.dart';
import 'package:flutter_picgo/routers/application.dart';
import 'package:flutter_picgo/routers/routers.dart';
import 'package:flutter_picgo/views/pb_setting_page/pb_setting_presenter.dart';

class PBSettingPage extends StatefulWidget {
  @override
  _PBSettingPageState createState() => _PBSettingPageState();
}

class _PBSettingPageState extends State<PBSettingPage>
    implements PBSettingPageContract {
  List<PBSetting> _settings;

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
      ),
      body: this._settings == null
          ? Center(
              child: Text('暂无图床数据'),
            )
          : ListView.builder(
            itemCount: this._settings?.length ?? 0,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_settings[index].name),
                onTap: () {
                  Application.router.navigateTo(context, _settings[index].path, transition: TransitionType.cupertino);
                },
                trailing: Icon(Icons.arrow_right),
              );
            },
          ),
    );
  }

  @override
  void loadError(String errorMsg) {}

  @override
  void loadPb(List<PBSetting> settings) {
    setState(() {
      this._settings = settings;
    });
  }
}
