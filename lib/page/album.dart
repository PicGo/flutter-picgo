import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AlbumPage extends StatelessWidget {

  static const routeName = '/album';

  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('相册'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.file_upload),
        onPressed: () {
          getImage();
        },
      ),
    );
  }

  void getImage() async {
    try {
      final pickedFile = await picker.getImage(source: ImageSource.gallery);
    } catch (e) {
      print('报错$e');
    }
  }

}