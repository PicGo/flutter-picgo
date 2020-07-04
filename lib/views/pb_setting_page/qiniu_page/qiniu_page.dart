import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QiniuPage extends StatefulWidget {

  _QiniuPageState createState() => _QiniuPageState();

}

class _QiniuPageState extends State<QiniuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('七牛图床'),
        centerTitle: true,
      ),
    );
  }

}