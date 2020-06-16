import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class PicGoSettingPage extends StatefulWidget {

  @override
  _PicGoSettingPageState createState() => _PicGoSettingPageState();

}

class _PicGoSettingPageState extends State<PicGoSettingPage> {

  bool isUploadedRename;
  bool isTimestampRename;
  bool isUploadedTip;

  @override
  void initState() {
    super.initState();
    this.isTimestampRename = false;
    this.isUploadedRename = false;
    this.isUploadedTip = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PicGo设置'),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('上传前重命名'),
            trailing: CupertinoSwitch(
              value: this.isUploadedRename,
              onChanged: (value) {
                setState(() {
                  this.isUploadedRename = value;
                });
              },
            ),
          ),
          ListTile(
            title: Text('时间戳重命名'),
            trailing: CupertinoSwitch(
              value: this.isTimestampRename,
              onChanged: (value) {
                setState(() {
                  this.isTimestampRename = value;
                });
              },
            ),
          ),
          ListTile(
            title: Text('开启上传提示'),
            trailing: CupertinoSwitch(
              value: this.isUploadedTip,
              onChanged: (value) {
                setState(() {
                  this.isUploadedTip = value;
                });
              },
            ),
          ),
          ListTile(
            title: Text('设置显示图床'),
            onTap: () {

            },
          ),
          ListTile(
            title: Text('检查更新'),
            onTap: () {
              
            },
          ),
        ],
      ),
    );
  }

}
