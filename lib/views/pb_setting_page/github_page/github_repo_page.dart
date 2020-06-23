import 'package:flutter/material.dart';

class GithubRepoPage extends StatefulWidget {

  final String path;

  GithubRepoPage({this.path = '/'});

  _GithubRepoPageState createState() => _GithubRepoPageState(path);

}

class _GithubRepoPageState extends State<GithubRepoPage> {

  final String path;

  _GithubRepoPageState(this.path);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('仓库内容'),
      ),
      body: Center(
        child: Text(this.path),
      ),
    );
  }

}