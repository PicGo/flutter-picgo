import 'package:flutter/material.dart';
import 'package:flutter_picgo/views/manage_page/base_loading_page_state.dart';
import 'package:flutter_picgo/views/manage_page/qiniu_page/qiniu_repo_page_presenter.dart';

class QiniuRepoPage extends StatefulWidget {
  String prefix;
  QiniuRepoPage({this.prefix});
  _QiniuRepoPageState createState() => _QiniuRepoPageState(prefix);
}

class _QiniuRepoPageState extends BaseLoadingPageState<QiniuRepoPage>
    implements QiniuRepoPageContract {
  String errorMsg;
  String _prefix;
  QiniuRepoPagePresenter _presenter;

  _QiniuRepoPageState(this._prefix) {
    _presenter = new QiniuRepoPagePresenter(this);
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
    return Center();
  }
}
