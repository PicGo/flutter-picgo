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
            Key('$index'),
            contents[index].url,
            contents[index].filename,
            '${contents[index].size}k',
            FileContentType.FILE,
            onTap: () {
              launch(contents[index].url);
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

              var del = await _presenter.doDeleteContents(contents[index].delete);
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
