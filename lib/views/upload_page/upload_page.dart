import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_picgo/components/loading.dart';
import 'package:flutter_picgo/utils/shared_preferences.dart';
import 'package:flutter_picgo/views/upload_page/upload_page_presenter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';
import 'package:path/path.dart' as path;

class UploadPage extends StatefulWidget {
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> implements UploadPageContract {
  String _title = '';
  String _previewPath = '';
  String _renameImage ;
  TextEditingController _controller;
  int _selectButton = 1;

  UploadPagePresenter _presenter;
  final picker = ImagePicker();

  _UploadPageState() {
    _presenter = UploadPagePresenter(this);
  }

  @override
  void initState() {
    super.initState();
    _presenter.doLoadCurrentPB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this._title),
        centerTitle: true,
      ),
      body: ListView(
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
              child: Text('链接格式'),
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: <Widget>[
              SizedBox(width: 10),
              Expanded(
                child: RaisedButton(
                  color: this._selectButton == 1
                      ? Theme.of(context).accentColor
                      : Colors.white,
                  textColor:
                      this._selectButton == 1 ? Colors.white : Colors.black,
                  child: Text('Markdown'),
                  onPressed: () {
                    setState(() {
                      this._selectButton = 1;
                    });
                  },
                ),
              ),
              Expanded(
                child: RaisedButton(
                  color: this._selectButton == 2
                      ? Theme.of(context).accentColor
                      : Colors.white,
                  textColor:
                      this._selectButton == 2 ? Colors.white : Colors.black,
                  child: Text('HTML'),
                  onPressed: () {
                    setState(() {
                      this._selectButton = 2;
                    });
                  },
                ),
              ),
              Expanded(
                child: RaisedButton(
                  color: this._selectButton == 3
                      ? Theme.of(context).accentColor
                      : Colors.white,
                  textColor:
                      this._selectButton == 3 ? Colors.white : Colors.black,
                  child: Text('URL'),
                  onPressed: () {
                    setState(() {
                      this._selectButton = 3;
                    });
                  },
                ),
              ),
              SizedBox(width: 10),
            ],
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
      ),
    );
  }

  /// 获取图片
  _getImage() async {
    try {
      final pickedFile = await picker.getImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        var sp = await SpUtil.getInstance();
        var settingIsTimestampRename =
            sp.getBool(SharedPreferencesKeys.settingIsTimestampRename) ?? false;
        var settingIsUploadedRename =
            sp.getBool(SharedPreferencesKeys.settingIsUploadedRename) ?? false;
        /// 获取文件后缀
        String suffix = path.extension(pickedFile.path);
        String filename = path.basenameWithoutExtension(pickedFile.path);
        _renameImage = settingIsTimestampRename
            ? '${new DateTime.now().millisecondsSinceEpoch.toString()}$suffix'
            : '$filename$suffix';
        if (settingIsUploadedRename) {
          _controller = TextEditingController(text: _renameImage);
          await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                title: Center(
                  child: Text('重命名图片'),
                ),
                content: Padding(
                  padding: EdgeInsets.only(left: 4, right: 4),
                  child: TextField(
                    controller: _controller,
                  ),
                ),
                actions: <Widget>[
                  FlatButton(child: Text('确定'), onPressed: () {
                    this._renameImage = _controller.text;
                    Navigator.pop(context);
                  }),
                ],
              );
            },
          );
        }
        setState(() {
          this._previewPath = pickedFile.path;
        });
      }
    } catch (e) {
      debugPrint(e);
      Toast.show("请给予权限", context);
    }
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
            requestCallBack:
                _presenter.doUploadImage(new File(this._previewPath), _renameImage),
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
  uploadFaild(String errorMsg) {
    Toast.show(errorMsg ?? '', context);
  }

  @override
  uploadSuccess(String imageUrl) {
    Toast.show(imageUrl ?? '', context);
  }
}
