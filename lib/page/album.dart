import 'package:flutter/material.dart';

class AlbumPage extends StatelessWidget {

  static const routeName = '/album';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('相册'),
        centerTitle: true,
      ),
    );
  }

}