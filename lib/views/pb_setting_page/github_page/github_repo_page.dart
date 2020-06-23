import 'package:flutter/material.dart';

class GithubRepoPage extends StatefulWidget {

  _GithubRepoPageState createState() => _GithubRepoPageState();

}

class _GithubRepoPageState extends State<GithubRepoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('仓库内容'),
      ),
    );
  }

}