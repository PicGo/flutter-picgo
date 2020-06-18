import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_picgo/components/picker_image.dart';
// import 'dart:io';
import 'package:flutter_picgo/model/uploaded.dart';
import 'package:flutter_picgo/routers/application.dart';
import 'package:flutter_picgo/routers/routers.dart';
import 'package:flutter_picgo/views/album_page/album_page_presenter.dart';
import 'package:image_picker/image_picker.dart';

class AlbumPage extends StatefulWidget {
  @override
  _AlbumPageState createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> implements AlbumPageContract {
  final picker = ImagePicker();

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

  // void getImage() async {
  //   try {
  //     final pickedFile = await picker.getImage(source: ImageSource.gallery);
  //     await showDialog(
  //         context: context,
  //         barrierDismissible: false,
  //         builder: (context) {
  //           return PickerImageDialog('dasdasd.png', pickedFile.path);
  //         });
  //     File(pickedFile.path);
  //   } catch (e) {
  //     print('报错$e');
  //   }
  // }

  @override
  void loadUploadedImages(List<Uploaded> uploadeds) {}
}
