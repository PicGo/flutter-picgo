import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picgo/components/loading.dart';
import 'package:flutter_picgo/model/uploaded.dart';
import 'package:flutter_picgo/routers/application.dart';
import 'package:flutter_picgo/routers/routers.dart';
import 'package:flutter_picgo/views/album_page/album_page_presenter.dart';
import 'package:toast/toast.dart';
import 'package:flutter/services.dart';

class AlbumPage extends StatefulWidget {
  @override
  _AlbumPageState createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> implements AlbumPageContract {
  AlbumPagePresenter _presenter;
  List<Uploaded> _uploadeds = [];

  _AlbumPageState() {
    _presenter = AlbumPagePresenter(this);
  }

  @override
  void initState() {
    super.initState();
    _presenter.doLoadUploadedImages();
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
        onPressed: () {
          Application.router.navigateTo(context, Routes.upload,
              transition: TransitionType.cupertino);
        },
      ),
      body: RefreshIndicator(
          onRefresh: _onRefresh,
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
              child: CachedNetworkImage(
                imageUrl: _uploadeds[index].path,
                fit: BoxFit.cover,
                placeholder: (context, url) => Center(
                  child: Container(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) {
                  return Container(
                    color: Colors.grey,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.error),
                          SizedBox(height: 2),
                          Text(
                            '加载失败',
                            style: TextStyle(fontSize: 12),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget emptyView() {
    return ListView(
      children: <Widget>[
        SizedBox(height: 100),
        Center(
          child: Container(
            width: 200,
            height: 200,
            child: Image.asset('assets/images/icon_empty_album.png',
                fit: BoxFit.fill),
          ),
        ),
        SizedBox(height: 10),
        Center(
          child: Text(
            '相册暂无任何照片，快点击右下角按钮去上传吧',
            style: TextStyle(color: Colors.grey),
          ),
        )
      ],
    );
  }

  Future<dynamic> _onRefresh() async {
    setState(() {
      _uploadeds.clear();
    });
    return _presenter.doLoadUploadedImages();
  }

  handleTap(int index) {
    Clipboard.setData(ClipboardData(text: _uploadeds[index].path));
    Toast.show('已复制到剪切板', context);
  }

  @override
  void loadUploadedImages(List<Uploaded> uploadeds) {
    setState(() {
      this._uploadeds.addAll(uploadeds);
    });
  }

  @override
  void loadError() {
    Toast.show('加载失败', context);
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
