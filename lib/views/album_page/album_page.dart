import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picgo/model/uploaded.dart';
import 'package:flutter_picgo/routers/application.dart';
import 'package:flutter_picgo/routers/routers.dart';
import 'package:flutter_picgo/views/album_page/album_page_presenter.dart';
import 'package:toast/toast.dart';

class AlbumPage extends StatefulWidget {
  @override
  _AlbumPageState createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> implements AlbumPageContract {
  AlbumPagePresenter _presenter;
  List<Uploaded> _uploadeds;

  _AlbumPageState() {
    _presenter = AlbumPagePresenter(this);
  }

  @override
  void initState() {
    super.initState();
    _presenter.doLoadUploadedImages();
  }

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
          Application.router.navigateTo(context, Routes.upload,
              transition: TransitionType.cupertino);
        },
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, //每行三列
            childAspectRatio: 1.0 //显示区域宽高相等
        ),
        itemCount: _uploadeds?.length ?? 0,
        itemBuilder: (context, index) {
          return Container(
            height: 150,
            child: Image.network(
              _uploadeds[index].path,
              fit: BoxFit.cover,
            ),
          );
        }
    ),
    );
  }

  @override
  void loadUploadedImages(List<Uploaded> uploadeds) {
    setState(() {
      this._uploadeds = uploadeds;
    });
  }

  @override
  void loadError() {
    Toast.show('加载失败', context);
  }
}
