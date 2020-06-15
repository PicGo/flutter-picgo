import 'package:flutter/material.dart';

class SettingPage extends StatelessWidget {

  static const routeName = '/setting';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('设置'),
        centerTitle: true,
      ),
    );
  }

}