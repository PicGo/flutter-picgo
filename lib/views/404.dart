import 'package:flutter/material.dart';

class PageNotFound extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Page not found"),
        ),
        body: Container(child: Text("Page not found")));
  }

}