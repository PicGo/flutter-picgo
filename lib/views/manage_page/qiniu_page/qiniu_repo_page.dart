import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picgo/components/manage_item.dart';
import 'package:flutter_picgo/model/qiniu_content.dart';
import 'package:flutter_picgo/routers/application.dart';
import 'package:flutter_picgo/routers/routers.dart';
import 'package:flutter_picgo/views/manage_page/base_loading_page_state.dart';
import 'package:flutter_picgo/views/manage_page/qiniu_page/qiniu_repo_page_presenter.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path/path.dart' as pathlib;

class QiniuRepoPage extends StatefulWidget {
  final String prefix;
  QiniuRepoPage({this.prefix});
  _QiniuRepoPageState createState() => _QiniuRepoPageState(prefix);
}

class _QiniuRepoPageState extends BaseLoadingPageState<QiniuRepoPage>
    implements QiniuRepoPageContract {
  String errorMsg;
  String _prefix;
  List<QiniuContent> contents = [];
  QiniuRepoPagePresenter _presenter;

  _QiniuRepoPageState(this._prefix) {
    _presenter = new QiniuRepoPagePresenter(this);
  }

  @override
  void initState() {
    super.initState();
    _presenter.doLoadContents(this._prefix);
  }

  @override
  AppBar get appBar => AppBar(
        title: Text(this._prefix == '/' ? '图床仓库' : this._prefix),
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
          ElevatedButton(
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.white),
                backgroundColor:
                    MaterialStateProperty.all(Theme.of(context).accentColor)),
            child: Text('刷新'),
            onPressed: () {
              setState(() {
                this.state = LoadState.LOADING;
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
            Key('${contents[index].key}'),
            contents[index].url,
            contents[index].key,
            '${contents[index].fsize ?? 0}k',
            contents[index].type,
            onTap: () {
              if (contents[index].type == FileContentType.DIR) {
                Application.router.navigateTo(context,
                    '${Routes.settingPbQiniuRepo}?path=${Uri.encodeComponent(contents[index].url)}',
                    transition: TransitionType.cupertino);
              } else {
                launch(contents[index].url);
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
                        TextButton(
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
              String realKey = pathlib.joinAll(
                  [_prefix == '/' ? '' : _prefix, contents[index].key]);
              var del = await _presenter.doDeleteContents(realKey);
              return del;
            },
          );
        });
  }

  @override
  void loadError(String msg) {
    Toast.show(msg, context);
  }

  @override
  void loadSuccess(List<QiniuContent> data) {
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
}
