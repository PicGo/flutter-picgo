import 'dart:io';
import 'dart:math';
import 'package:flutter_picgo/components/upload_item/upload_item.dart';
import 'package:flutter_picgo/utils/strings.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:flutter_picgo/resources/shared_preferences_keys.dart';
import 'package:flutter_picgo/utils/image_upload.dart';
import 'package:flutter_picgo/utils/shared_preferences.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class HandleUploadPage extends StatefulWidget {
  final List<AssetEntity> assets;

  HandleUploadPage(this.assets, {Key key}) : super(key: key);

  @override
  _HandleUploadPageState createState() => _HandleUploadPageState();
}

class _HandleUploadPageState extends State<HandleUploadPage> {
  String _title = '';
  bool isParse = false;
  List<File> files;
  List<String> filesName;

  TextEditingController _controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCurrentPb();
    _parseAsset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this._title),
        centerTitle: true,
      ),
      body: isParse ? buildList() : buildParseTip(),
    );
  }

  Widget buildList() {
    return Column(
      children: buildUploadItem(),
    );
  }

  List<UploadItem> buildUploadItem() {
    if (files == null || files.length <= 0) {
      return [];
    }

    List<UploadItem> items = [];
    for (int i = 0; i < files.length; i++) {
      print(files[i]);
      print(filesName[i]);
      items.add(new UploadItem(files[i], filesName[i]));
    }
    return items;
  }

  Widget buildParseTip() {
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

  _getCurrentPb() async {
    String pbType = await ImageUploadUtils.getDefaultPB();
    String name = await ImageUploadUtils.getPBName(pbType);
    setState(() {
      this._title = '图片上传 - $name';
    });
  }

  _parseAsset() async {
    if (widget.assets != null && widget.assets.length > 0) {
      files = [];
      filesName = [];
      File tmp;

      /// 将Assets文件转换成File
      for (int i = 0; i < widget.assets.length; i++) {
        tmp = await widget.assets[i].originFile;
        files.add(tmp);
        filesName.add(path.basename(tmp.path));
      }

      var sp = await SpUtil.getInstance();

      var settingIsTimestampRename =
          sp.getBool(SharedPreferencesKeys.settingIsTimestampRename) ?? false;

      if (settingIsTimestampRename) {
        /// 处理时间戳命名
        var random = Random();
        for (int i = 0; i < widget.assets.length; i++) {
          /// 获取图片名
          String suffix = path.extension(tmp.path);

          /// replace
          filesName[i] =
              '${new DateTime.now().millisecondsSinceEpoch.toString()}-${random.nextInt(100)}$suffix';
        }
      }
      var settingIsUploadedRename =
          sp.getBool(SharedPreferencesKeys.settingIsUploadedRename) ?? false;

      if (settingIsUploadedRename) {
        String content = filesName.join('\n');

        /// 处理默认文本内容
        _controller.text = content;

        /// 处理重命名
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: Center(
                child: Text('重命名图片，多张图片时以换行符分隔'),
              ),
              content: Container(
                padding: EdgeInsets.only(left: 4, right: 4),
                child: TextField(
                  textInputAction: TextInputAction.newline,
                  controller: _controller,
                  scrollPadding: EdgeInsets.zero,
                  maxLines: null,
                ),
              ),
              actions: <Widget>[
                FlatButton(
                    child: Text('确定'),
                    onPressed: () {
                      Navigator.pop(context);
                      _handleTextFieldContent(_controller.text.trim());
                    }),
              ],
            );
          },
        );
      } else {
        _parseAssetsSuccess();
      }
    } else {
      Navigator.pop(context);
    }
  }

  _handleTextFieldContent(String content) {
    List<String> splits = content.split('\n');
    if (splits != null && splits.length >= widget.assets.length) {
      /// 处理内容是否正确
      for (int i = 0; i < widget.assets.length; i++) {
        if (!isBlank(splits[i])) {
          /// 不为空，则再覆盖
          filesName[i] = splits[i];
        }
      }
    }
    _parseAssetsSuccess();
  }

  _parseAssetsSuccess() {
    setState(() {
      isParse = true;
    });
  }
}
