import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picgo/components/manage_item.dart';
import 'package:flutter_picgo/model/gitee_content.dart';
import 'package:flutter_picgo/routers/application.dart';
import 'package:flutter_picgo/routers/routers.dart';
import 'package:flutter_picgo/views/manage_page/base_loading_page_state.dart';
import 'package:flutter_picgo/views/manage_page/gitee_page/gitee_repo_page_presenter.dart';
import 'package:path/path.dart' as pathlib;
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';

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
              contents[index].downloadUrl,
              contents[index].name,
              'unknown',
              contents[index].type == GiteeContentType.FILE
                  ? FileContentType.FILE
                  : FileContentType.DIR);
        });
  }
}

// ListTile(
//               title: Text(contents[index].name,
//                   textWidthBasis: TextWidthBasis.longestLine,
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis),
//               leading: Icon(contents[index].type == GiteeContentType.FILE
//                   ? IconData(0xe654, fontFamily: 'iconfont')
//                   : IconData(0xe63f, fontFamily: 'iconfont')),
//               onTap: () {
//                 if (contents[index].type == GiteeContentType.DIR) {
//                   var prePathParam = pathlib
//                       .joinAll([_prePath ?? '', _path == '/' ? '' : _path]);
//                   Application.router.navigateTo(context,
//                       '${Routes.settingPbGiteeRepo}?path=${Uri.encodeComponent(contents[index].name)}&prePath=${Uri.encodeComponent(prePathParam)}',
//                       transition: TransitionType.cupertino);
//                 } else {
//                   Clipboard.setData(
//                       ClipboardData(text: contents[index].downloadUrl));
//                   Toast.show('已获取下载链接到剪切板', context);
//                 }
//               },
//             )
