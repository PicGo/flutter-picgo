import 'package:flutter/material.dart';

class PBSettingPage extends StatelessWidget {

  static const routeName = '/setting/pb';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('图床设置'),
        centerTitle: true,
      ),
    );
  }

}