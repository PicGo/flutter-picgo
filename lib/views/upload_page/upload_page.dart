import 'package:flutter/material.dart';
import 'package:flutter_picgo/views/upload_page/upload_page_presenter.dart';

class UploadPage extends StatefulWidget {
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> implements UploadPageContract {

  String title = '';

  UploadPagePresenter _presenter;

  _UploadPageState() {
    _presenter = UploadPagePresenter(this);
  }

  @override
  void initState() {
    super.initState();
    _presenter.doLoadCurrentPB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.title),
        centerTitle: true,
      ),
    );
  }

  @override
  loadCurrentPB(String pbname) {
    setState(() {
      this.title = '图片上传 - $pbname';
    });
  }
}
