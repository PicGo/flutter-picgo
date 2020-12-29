import 'package:extended_image/extended_image.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picgo/components/loading.dart';
import 'package:flutter_picgo/model/uploaded.dart';
import 'package:flutter_picgo/routers/application.dart';
import 'package:flutter_picgo/routers/routers.dart';
import 'package:flutter_picgo/utils/extended.dart';
import 'package:flutter_picgo/utils/permission.dart';
import 'package:flutter_picgo/views/album_page/album_page_presenter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toast/toast.dart';
import 'package:flutter/services.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class AlbumPage extends StatefulWidget {
  @override
  _AlbumPageState createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> implements AlbumPageContract {
  AlbumPagePresenter _presenter;
  List<Uploaded> _uploadeds = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  int _perPageItemSize = 8;
  int _currentPage = 0;

  _AlbumPageState() {
    _presenter = AlbumPagePresenter(this);
  }

  @override
  void initState() {
    super.initState();
    _onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('相册 - ${_uploadeds?.length ?? 0}'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(IconData(0xe639, fontFamily: 'iconfont')),
        onPressed: () async {
          /// assets select
          handleSelect();
        },
      ),
      body: SmartRefresher(
          enablePullDown: true,
          enablePullUp: this._uploadeds.length >= _perPageItemSize,
          header: ClassicHeader(
            refreshStyle: RefreshStyle.Follow,
            idleText: '下拉刷新',
            releaseText: '释放刷新',
            completeText: '加载完成',
            refreshingText: '刷新中',
            failedText: '加载失败，请重试',
          ),
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
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          controller: _refreshController,
          child: _uploadeds.length > 0 ? albumView() : emptyView()),
    );
  }

  Widget albumView() {
    return GridView.builder(
      padding: EdgeInsets.all(2),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, //每行三列
          // crossAxisSpacing: 2,
          // mainAxisSpacing: 2,
          childAspectRatio: 1.0 //显示区域宽高相等
          ),
      itemCount: _uploadeds?.length ?? 0,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            handleTap(index);
          },
          onLongPress: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('确定删除吗'),
                    content: Text('删除后无法恢复'),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('确定'),
                        onPressed: () {
                          Navigator.pop(context);
                          showDialog(
                              context: context,
                              builder: (context) {
                                return NetLoadingDialog(
                                  outsideDismiss: false,
                                  loading: true,
                                  loadingText: "删除中...",
                                  requestCallBack: _presenter
                                      .doDeleteImage(_uploadeds[index]),
                                );
                              });
                        },
                      ),
                    ],
                  );
                });
          },
          child: Container(
            height: 150,
            child: Card(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusDirectional.circular(8)),
              child: ExtendedImage.network(
                _uploadeds[index].path,
                height: 150,
                fit: BoxFit.cover,
                cache: true,
                border: Border.all(color: Colors.grey, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(8)),
                loadStateChanged: (state) => defaultLoadStateChanged(state),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget emptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 200,
            height: 200,
            child: Image.asset('assets/images/icon_empty_album.png',
                fit: BoxFit.fill),
          ),
          Center(
            child: Text(
              '相册暂无任何照片，快点击右下角按钮去上传吧',
              style: TextStyle(color: Colors.grey),
            ),
          )
        ],
      ),
    );
  }

  /// 刷新
  _onRefresh() async {
    // _uploadeds.clear();
    setState(() {
      this._currentPage = 0;
      this._uploadeds.clear();
      _refreshController.resetNoData();
    });
    _presenter.doLoadUploadedImages(_perPageItemSize, this._currentPage);
  }

  /// 上拉加载
  _onLoading() async {
    _presenter.doLoadUploadedImages(_perPageItemSize, _currentPage += 1);
  }

  /// 处理图片点击
  handleTap(int index) {
    Clipboard.setData(ClipboardData(text: _uploadeds[index].path));
    Toast.show('已复制到剪切板', context);
  }

  /// 处理选择图片
  handleSelect() async {
    var status = await PermissionUtils.requestPhotos();
    if (status == PermissionStatus.denied) {
      PermissionUtils.showPermissionDialog(context);
      return;
    }
    final List<AssetEntity> assets = await AssetPicker.pickAssets(context);
    if (assets != null && assets.length > 0) {
      Application.router.navigateTo(context, Routes.handleUpload,
          transition: TransitionType.cupertino,
          routeSettings: RouteSettings(arguments: assets));
    } else {
      Toast.show('您已取消选择', context);
    }
  }

  @override
  void loadUploadedImages(List<Uploaded> uploadeds) {
    setState(() {
      if (this._currentPage == 0) {
        _refreshController.refreshCompleted();
      } else if (this._currentPage > 0 &&
          (uploadeds == null || uploadeds.length == 0)) {
        _refreshController.loadNoData();
      } else {
        this._currentPage += 1;
        _refreshController.loadComplete();
      }
      if (uploadeds != null && uploadeds.length > 0) {
        this._uploadeds.addAll(uploadeds);
      }
    });
  }

  @override
  void loadError() {
    Toast.show('加载失败', context);
    if (this._currentPage == 1) {
      _refreshController.refreshFailed();
    } else {
      _refreshController.loadFailed();
    }
  }

  @override
  void deleteError(String msg) {
    Toast.show(msg, context);
  }

  @override
  void deleteSuccess(Uploaded uploaded) {
    this.setState(() {
      this._uploadeds.remove(uploaded);
    });
  }
}
