import 'package:flutter/material.dart';
import 'package:flutter_picgo/components/manage_item.dart';
import 'package:flutter_picgo/model/smms_content.dart';
import 'package:flutter_picgo/views/manage_page/base_loading_page_state.dart';
import 'package:flutter_picgo/views/manage_page/smms_page/smms_repo_page_presenter.dart';
import 'package:url_launcher/url_launcher.dart';

class SMMSRepoPage extends StatefulWidget {
  @override
  _SMMSRepoPageState createState() => _SMMSRepoPageState();
}

enum SortBy { timeup, timedown, sizeup, sizedown }

class _SMMSRepoPageState extends BaseLoadingPageState<SMMSRepoPage>
    implements SMMSRepoPageContract {
  String errorMsg;
  List<SMMSContent> contents = [];
  SMMSRepoPagePresenter _presenter;

  _SMMSRepoPageState() {
    _presenter = SMMSRepoPagePresenter(this);
  }

  @override
  void initState() {
    super.initState();
    _presenter.doLoadContents();
  }

  @override
  AppBar get appBar => AppBar(
        title: Text('图床仓库'),
        centerTitle: true,
        actions: [
          PopupMenuButton<SortBy>(
            onSelected: (result) {
              sortItem(result);
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<SortBy>>[
              const PopupMenuItem<SortBy>(
                value: SortBy.timeup,
                child: Text('时间升序'),
              ),
              const PopupMenuItem<SortBy>(
                value: SortBy.timedown,
                child: Text('时间降序'),
              ),
              const PopupMenuItem<SortBy>(
                value: SortBy.sizeup,
                child: Text('大小升序'),
              ),
              const PopupMenuItem<SortBy>(
                value: SortBy.sizedown,
                child: Text('大小降序'),
              ),
            ],
          )
        ],
      );

  @override
  Widget buildEmtpy() {
    return Center(
      child: Text('数据空空如也噢'),
    );
  }

  sortItem(SortBy s) {
    if (this.contents != null && this.contents.length > 1) {
      switch (s) {
        case SortBy.timeup:
          setState(() {
            this.contents.sort((a, b) {
              return a.createdAt.compareTo(b.createdAt);
            });
          });
          break;
        case SortBy.timedown:
          setState(() {
            this.contents.sort((a, b) {
              if (a.createdAt < b.createdAt) {
                return 1;
              } else if (a.createdAt > b.createdAt) {
                return -1;
              } else {
                return 0;
              }
            });
          });
          break;
        case SortBy.sizeup:
          setState(() {
            this.contents.sort((a, b) {
              return a.size.compareTo(b.size);
            });
          });
          break;
        case SortBy.sizedown:
          setState(() {
            this.contents.sort((a, b) {
              if (a.size < b.size) {
                return 1;
              } else if (a.size > b.size) {
                return -1;
              } else {
                return 0;
              }
            });
          });
          break;
      }
    }
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
                // _presenter.doLoadContents(_path, _prePath);
                _presenter.doLoadContents();
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
            Key('${contents[index].hash}'),
            contents[index].url,
            contents[index].filename,
            '${contents[index].size}k',
            FileContentType.FILE,
            onTap: () {
              launch(contents[index].url);
            },
            onDismiss: (direction) {
              setState(() {
                this.contents.removeAt(index);
              });
            },
            confirmDismiss: (direction) async {
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

              var del =
                  await _presenter.doDeleteContents(contents[index].delete);
              return del;
            },
          );
        });
  }

  @override
  void loadError(String msg) {
    setState(() {
      this.state = LoadState.ERROR;
      this.errorMsg = msg;
    });
  }

  @override
  void loadSuccess(List<SMMSContent> data) {
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
