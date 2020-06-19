import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picgo/model/uploaded.dart';
import 'package:flutter_picgo/routers/application.dart';
import 'package:flutter_picgo/routers/routers.dart';
import 'package:flutter_picgo/views/album_page/album_page_presenter.dart';

class AlbumPage extends StatefulWidget {
  @override
  _AlbumPageState createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> implements AlbumPageContract {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('相册'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(IconData(0xe639, fontFamily: 'iconfont')),
        onPressed: () {
          Application.router.navigateTo(context, Routes.upload, transition: TransitionType.cupertino);
        },
      ),
    );
  }

  @override
  void loadUploadedImages(List<Uploaded> uploadeds) {}
}
