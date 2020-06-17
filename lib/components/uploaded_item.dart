import 'package:flutter/material.dart';

class UploadedItem extends StatelessWidget {

  final String path;

  UploadedItem(this.path);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150.0,
      child: Image.network(path),
    );
  }

}