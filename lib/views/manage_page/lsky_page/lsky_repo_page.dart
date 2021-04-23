import 'package:flutter/material.dart';
import 'package:flutter_picgo/components/manage_item.dart';
import 'package:flutter_picgo/model/lsky_content.dart';
import 'package:flutter_picgo/views/manage_page/base_loading_page_state.dart';
import 'package:flutter_picgo/views/manage_page/lsky_page/lsky_repo_page_presenter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

class LskyRepoPage extends StatefulWidget {
  _LskyRepoPageState createState() => _LskyRepoPageState();
}

class _LskyRepoPageState extends BaseLoadingPageState<LskyRepoPage>
    implements LskyRepoPageContract {
  String errorMsg;
  int currentPage = 1;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<LskyContent> contents = [];
  LskyRepoPagePresenter _presenter;

  _LskyRepoPageState() {
    _presenter = LskyRepoPagePresenter(this);
  }

  @override
  void initState() {
    super.initState();
    _presenter.doLoadContents(currentPage);
  }

  @override
  AppBar get appBar => AppBar(
        title: Text('图床仓库'),
        centerTitle: true,
      );

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
                // _presenter.doLoadContents(_path, _prePath);
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
    return SmartRefresher(
        enablePullDown: false,
        enablePullUp: true,
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = Text("上拉加载");
            } else if (mode == LoadStatus.loading) {
              body = SizedBox(
                width: 15,
                height: 15,
                child: CircularProgressIndicator(),
              );
            } else if (mode == LoadStatus.failed) {
              body = Text("加载失败！点击重试！");
            } else if (mode == LoadStatus.canLoading) {
              body = Text("松手,加载更多!");
            } else {
              body = Text("没有更多数据了!");
            }
            return Container(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        onLoading: _onLoading,
        controller: _refreshController,
        child: ListView.builder(
            itemCount: contents.length,
            itemBuilder: (context, index) {
              return ManageItem(
                Key('${contents[index].md5}'),
                contents[index].url,
                contents[index].name,
                '${contents[index].size}b',
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

                  var del = await _presenter
                      .doDeleteContents('${contents[index].id}');
                  return del;
                },
              );
            }));
  }

  _onLoading() async {
    _presenter.doLoadContents(currentPage);
  }

  @override
  void loadError(String msg) {
    setState(() {
      this.state = LoadState.ERROR;
      this.errorMsg = msg;
    });
  }

  @override
  void loadSuccess(List<LskyContent> data, bool isEnd) {
    if (data != null && data.length > 0) {
      setState(() {
        if (this.state != LoadState.SUCCESS) {
          this.state = LoadState.SUCCESS;
        }
        this.contents.addAll(data);

        if (isEnd) {
          _refreshController.loadNoData();
        }

        currentPage += 1;
      });
    } else {
      if (currentPage == 1) {
        setState(() {
          this.state = LoadState.EMTPY;
        });
      }
    }
  }
}
