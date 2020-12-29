import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_picgo/components/loading.dart';
import 'package:flutter_picgo/utils/local_notification.dart';
import 'package:flutter_picgo/utils/permission.dart';
import 'package:flutter_picgo/utils/shared_preferences.dart';
import 'package:flutter_picgo/utils/strings.dart';
import 'package:flutter_picgo/views/upload_page/upload_page_presenter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toast/toast.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/services.dart';

class UploadPage extends StatefulWidget {
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage>
    with WidgetsBindingObserver
    implements UploadPageContract {
  String _title = '';
  String _previewPath = '';
  String _renameImage = '';
  String _clipUrl = '';
  TextEditingController _controller;
  // 默认不选中则不复制
  int _selectButton = 0;

  // 通知提示
  bool needNotify = false;

  // 按钮id
  static const MARKDOWN = 1;
  static const HTML = 2;
  static const URL = 3;

  UploadPagePresenter _presenter;

  _UploadPageState() {
    _presenter = UploadPagePresenter(this);
    SpUtil.getInstance().then((sp) {
      this.needNotify =
          sp.getBool(SharedPreferencesKeys.settingIsUploadedTip) ?? false;
    });
  }

  @override
  void initState() {
    super.initState();
    // 加载当前图床的名称
    _presenter.doLoadCurrentPB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this._title),
        centerTitle: true,
      ),
      body: uploadView(context),
    );
  }

  Widget uploadView(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          margin: EdgeInsets.all(10.0),
          height: 250.0,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).accentColor,
            ),
          ),
          child: Stack(
            children: <Widget>[
              SizedBox.expand(
                child: this._previewPath == ''
                    ? Center()
                    : Image.file(new File(this._previewPath),
                        fit: BoxFit.cover),
              ),
              SizedBox.expand(
                child: IconButton(
                  icon: Icon(
                    IconData(0xe639, fontFamily: 'iconfont'),
                    size: 50,
                    color: Theme.of(context).accentColor,
                  ),
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  tooltip: "上传",
                  onPressed: () {
                    _getImage();
                  },
                ),
              ),
            ],
          ),
        ),
        Container(
          child: Center(
            child: Text(
              '图片预览 - ${isBlank(this._previewPath) ? "暂未选择图片" : this._renameImage}',
              maxLines: 1,
              textWidthBasis: TextWidthBasis.parent,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        SizedBox(height: 10),
        Row(
          children: <Widget>[
            SizedBox(width: 10),
            Expanded(
              child: RaisedButton(
                color: this._selectButton == MARKDOWN
                    ? Theme.of(context).accentColor
                    : Colors.white,
                textColor: this._selectButton == MARKDOWN
                    ? Colors.white
                    : Colors.black,
                child: Text('Markdown'),
                onPressed: () {
                  setState(() {
                    this._selectButton = MARKDOWN;
                    setClipData();
                  });
                },
              ),
            ),
            Expanded(
              child: RaisedButton(
                color: this._selectButton == HTML
                    ? Theme.of(context).accentColor
                    : Colors.white,
                textColor:
                    this._selectButton == HTML ? Colors.white : Colors.black,
                child: Text('HTML'),
                onPressed: () {
                  setState(() {
                    this._selectButton = HTML;
                    setClipData();
                  });
                },
              ),
            ),
            Expanded(
              child: RaisedButton(
                color: this._selectButton == URL
                    ? Theme.of(context).accentColor
                    : Colors.white,
                textColor:
                    this._selectButton == URL ? Colors.white : Colors.black,
                child: Text('URL'),
                onPressed: () {
                  setState(() {
                    this._selectButton = URL;
                    setClipData();
                  });
                },
              ),
            ),
            SizedBox(width: 10),
          ],
        ),
        SizedBox(height: 10),
        Container(
          child: Center(
            child: Text('点击上传后可获取的对应选中的链接格式到剪切板，可点击切换', maxLines: 2),
          ),
        ),
        SizedBox(height: 10),
        Container(
          height: 40,
          child: Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: RaisedButton(
              color: Theme.of(context).accentColor,
              textColor: Colors.white,
              child: Text('上传'),
              onPressed: () {
                if (this._previewPath == null || this._previewPath == '') {
                  _getImage();
                  return;
                }
                _uploadImage();
              },
            ),
          ),
        )
      ],
    );
  }

  /// 获取图片
  _getImage() async {
    var status = await PermissionUtils.requestPhotos();
    if (status == PermissionStatus.denied) {
      PermissionUtils.showPermissionDialog(context);
      return;
    }
    // 获取图片
    // try {
    // final pickedFile = await picker.getImage(source: ImageSource.gallery);
    // if (pickedFile != null) {
    //   var sp = await SpUtil.getInstance();
    //   var settingIsTimestampRename =
    //       sp.getBool(SharedPreferencesKeys.settingIsTimestampRename) ?? false;
    //   var settingIsUploadedRename =
    //       sp.getBool(SharedPreferencesKeys.settingIsUploadedRename) ?? false;

    //   /// 获取文件后缀
    // String suffix = path.extension(pickedFile.path);
    // String filename = path.basenameWithoutExtension(pickedFile.path);
    // _renameImage = settingIsTimestampRename
    //     ? '${new DateTime.now().millisecondsSinceEpoch.toString()}$suffix'
    //     : '$filename$suffix';
    //   if (settingIsUploadedRename) {
    //     _controller = TextEditingController(text: _renameImage);
    //   await showDialog(
    //     context: context,
    //     barrierDismissible: false,
    //     builder: (context) {
    //       return AlertDialog(
    //         title: Center(
    //           child: Text('重命名图片'),
    //         ),
    //         content: Padding(
    //           padding: EdgeInsets.only(left: 4, right: 4),
    //           child: TextField(
    //             controller: _controller,
    //           ),
    //         ),
    //         actions: <Widget>[
    //           FlatButton(
    //               child: Text('确定'),
    //               onPressed: () {
    //                 this._renameImage = _controller.text;
    //                 Navigator.pop(context);
    //               }),
    //         ],
    //       );
    //     },
    //   );
    // }
    //   setState(() {
    //     this._previewPath = pickedFile.path;
    // });
    //   }
    // } catch (e) {
    //   debugPrint(e);
    // }
  }

  /// 上传图片
  _uploadImage() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return NetLoadingDialog(
            loading: true,
            loadingText: "上传中",
            requestCallBack: _presenter.doUploadImage(
                new File(this._previewPath), _renameImage),
          );
        });
  }

  @override
  loadCurrentPB(String pbname) {
    setState(() {
      this._title = '图片上传 - $pbname';
    });
  }

  @override
  uploadFaild(String errorMsg) async {
    if (needNotify) {
      await _showNotification(0, '上传失败：$errorMsg');
    }
    Toast.show(errorMsg ?? '', context);
  }

  /// 设置剪切板
  setClipData([bool needShowTip = true]) {
    if (isBlank(_clipUrl)) {
      Toast.show('暂无可获取图片', context);
      return;
    }
    String cliptext;
    switch (_selectButton) {
      case MARKDOWN:
        {
          cliptext = '![]($_clipUrl)';
        }
        break;
      case HTML:
        {
          cliptext = '<img src="$_clipUrl">';
        }
        break;
      case URL:
        {
          cliptext = _clipUrl;
        }
        break;
      default:
        {
          //statements;
          cliptext = '';
        }
        break;
    }
    if (!isBlank(cliptext)) {
      Clipboard.setData(ClipboardData(text: cliptext));
    }
    if (needShowTip) {
      Toast.show('已复制到剪切板', context);
    }
  }

  @override
  uploadSuccess(String imageUrl) async {
    if (needNotify) {
      await _showNotification(1, '上传成功, 图片链接：$imageUrl');
    }
    this._clipUrl = imageUrl;
    setClipData(false);
    Toast.show('上传成功，图片链接为：$imageUrl', context);
  }

  Future<void> _showNotification(int id, String body) async {
    LocalNotificationUtil.getInstance().show(
        id,
        '上传提示',
        body,
        LocalNotificationUtil.createNotificationDetails(
            LocalNotificationUtil.uploadAndroidChannel(),
            LocalNotificationUtil.normalIOSNotificationDetails(),
            LocalNotificationUtil.normalMacOSNotificationDetails()));
  }
}
