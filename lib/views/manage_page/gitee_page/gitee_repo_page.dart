import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picgo/components/manage_item.dart';
import 'package:flutter_picgo/model/gitee_content.dart';
import 'package:flutter_picgo/routers/application.dart';
import 'package:flutter_picgo/routers/routers.dart';
import 'package:flutter_picgo/views/manage_page/base_loading_page_state.dart';
import 'package:flutter_picgo/views/manage_page/gitee_page/gitee_repo_page_presenter.dart';
import 'package:path/path.dart' as pathlib;
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class GiteeRepoPage extends StatefulWidget {
  final String path;
  final String prePath;

  GiteeRepoPage({this.path = '/', this.prePath = ''});

  _GiteeRepoPageState createState() => _GiteeRepoPageState(path, prePath);
}

class _GiteeRepoPageState extends BaseLoadingPageState<GiteeRepoPage>
    implements GiteeRepoPageContract {
  String errorMsg;
  final String _path;
  final String _prePath;
  List<GiteeContent> contents = [];
  GiteeRepoPagePresenter _presenter;

  _GiteeRepoPageState(this._path, this._prePath) {
    _presenter = GiteeRepoPagePresenter(this);
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
  void loadSuccess(List<GiteeContent> data) {
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
          return ManageItem(
            Key('${contents[index].sha}'),
            contents[index].downloadUrl,
            contents[index].name,
            '${contents[index].size}k',
            contents[index].type,
            onTap: () {
              if (contents[index].type == FileContentType.DIR) {
                var prePathParam = pathlib
                    .joinAll([_prePath ?? '', _path == '/' ? '' : _path]);
                Application.router.navigateTo(context,
                    '${Routes.settingPbGiteeRepo}?path=${Uri.encodeComponent(contents[index].name)}&prePath=${Uri.encodeComponent(prePathParam)}',
                    transition: TransitionType.cupertino);
              } else {
                launch(contents[index].downloadUrl);
              }
            },
            onDismiss: (direction) {
              setState(() {
                this.contents.removeAt(index);
              });
            },
            confirmDismiss: (direction) async {
              if (contents[index].type == FileContentType.DIR) {
                Toast.show('暂不支持删除文件夹', context);
                return false;
              }
              bool result = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('确定删除吗'),
                      content: Text('删除后无法恢复'),
                      actions: <Widget>[
                        FlatButton(
                            child: Text('确定'),
                            onPressed: () {
                              Navigator.pop(context, true);
                            }),
                      ],
                    );
                  });
              if (!(result ?? false)) {
                return false;
              }

              var del = await _presenter.doDeleteContents(
                  _path, _prePath, contents[index].name, contents[index].sha);
              return del;
            },
          );
        });
  }
}
