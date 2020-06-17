import 'package:flutter/material.dart';

class AlbumPage extends StatelessWidget {

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
      
    } catch (e) {
      print('报错$e');
    }
  }

}