import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picgo/model/github_content.dart';
import 'package:flutter_picgo/routers/application.dart';
import 'package:flutter_picgo/routers/routers.dart';
import 'package:flutter_picgo/views/manage_page/base_loading_page_state.dart';
import 'package:flutter_picgo/views/manage_page/github_page/github_repo_page_presenter.dart';
import 'package:path/path.dart' as pathlib;
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';

class GithubRepoPage extends StatefulWidget {
  final String path;
  final String prePath;

  GithubRepoPage({this.path = '/', this.prePath = ''});

  _GithubRepoPageState createState() => _GithubRepoPageState(path, prePath);
}

class _GithubRepoPageState extends BaseLoadingPageState<GithubRepoPage>
    implements GithubRepoPageContract {
  String errorMsg;
  final String _path;
  final String _prePath;
  List<GithubContent> contents = [];
  GithubRepoPagePresenter _presenter;

  _GithubRepoPageState(this._path, this._prePath) {
    _presenter = GithubRepoPagePresenter(this);
  }

  @override
  void initState() {
    super.initState();
    _presenter.doLoadContents(_path, _prePath);
  }

  @override
  void loadError(String msg) {
    setState(() {
      this.state = LoadState.ERROR;
      this.errorMsg = msg;
    });
  }

  @override
  void loadSuccess(List<GithubContent> data) {
    if (data != null && data.length > 0) {
      setState(() {
        this.state = LoadState.SUCCESS;
        this.contents.clear();
        this.contents.addAll(data);
      });
    } else {
      setState(() {
        this.state = LoadState.EMTPY;
      });
    }
  }

  @override
  AppBar get appBar => AppBar(
        title: _prePath == ''
            ? Text(_path == '/' ? '图床仓库' : _path)
            : Column(
                children: <Widget>[
                  Text(
                    _path,
                    style: TextStyle(fontSize: 18.0),
                  ),
                  Text(
                    _prePath,
                    style: TextStyle(fontSize: 14.0),
                  )
                ],
              ),
        centerTitle: true,
      );

  @override
  Widget buildEmtpy() {
    return Center(
      child: Text('数据空空如也噢'),
    );
  }

  @override
  Widget buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RaisedButton(
            color: Theme.of(context).accentColor,
            textColor: Colors.white,
            child: Text('刷新'),
            onPressed: () {
              setState(() {
                this.state = LoadState.LOADING;
                _presenter.doLoadContents(_path, _prePath);
              });
            },
          ),
          SizedBox(height: 5),
          Text(this.errorMsg ?? '未知错误',
              style: TextStyle(color: Colors.grey[400])),
        ],
      ),
    );
  }

  @override
  Widget buildLoading() {
    return Center(
      child: SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          backgroundColor: Colors.transparent,
          valueColor: AlwaysStoppedAnimation(Colors.blue),
        ),
      ),
    );
  }

  @override
  Widget buildSuccess() {
    return ListView.builder(
        itemCount: contents.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(width: 0.5, color: Colors.grey[400])),
            ),
            child: ListTile(
              title: Text(contents[index].name,
                  textWidthBasis: TextWidthBasis.longestLine,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
              leading: Icon(contents[index].type == GithubContentType.FILE
                  ? IconData(0xe654, fontFamily: 'iconfont')
                  : IconData(0xe63f, fontFamily: 'iconfont')),
              onTap: () {
                if (contents[index].type == GithubContentType.DIR) {
                  var prePathParam = pathlib
                      .joinAll([_prePath ?? '', _path == '/' ? '' : _path]);
                  Application.router.navigateTo(context,
                      '${Routes.settingPbGitubRepo}?path=${Uri.encodeComponent(contents[index].name)}&prePath=${Uri.encodeComponent(prePathParam)}',
                      transition: TransitionType.cupertino);
                } else {
                  Clipboard.setData(
                      ClipboardData(text: contents[index].downloadUrl));
                  Toast.show('已获取下载链接到剪切板', context);
                }
              },
            ),
          );
        });
  }
}
