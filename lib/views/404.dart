import 'package:flutter/material.dart';
import 'package:flutter_picgo/routers/application.dart';

class PageNotFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("页面走丢啦～"),
      ),
      body: Container(
        child: Center(
          child: OutlineButton(
            color: Colors.blue,
            child: Text('关闭'),
            onPressed: () {
              Application.router.pop(context);
            },
          ),
        ),
      ),
    );
  }
}
