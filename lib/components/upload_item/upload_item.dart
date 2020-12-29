import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picgo/components/upload_item/upload_item_presenter.dart';
import 'package:flutter_picgo/utils/extended.dart';

enum UploadState {
  /// 上传中
  Uploading,

  /// 保存中
  Saving,

  /// 已完成
  Complete,

  /// 上传失败
  UploadFail,

  /// 保存失败
  SaveFail
}

class UploadItem extends StatefulWidget {
  final File file;
  final String rename;

  UploadItem(this.file, this.rename);

  @override
  _UploadItemState createState() => _UploadItemState();
}

class _UploadItemState extends State<UploadItem> implements UploadItemContract {
  UploadState _state;
  UploadItemPresenter _presenter;
  _UploadItemState() {
    _state = UploadState.Uploading;
    _presenter = new UploadItemPresenter(this);
  }

  @override
  void initState() {
    super.initState();
    _startUpload();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
        height: 50,
        width: 50,
        child: Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.circular(2)),
          child: ExtendedImage.file(
            File(widget.file.path),
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            border: Border.all(color: Colors.grey, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(8)),
            loadStateChanged: (state) => defaultLoadStateChanged(state),
          ),
        ),
      ),
      title: Text(
        widget.rename,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textWidthBasis: TextWidthBasis.parent,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      ),
      subtitle: Text(
        '上传状态：${_parseStateText()}',
        maxLines: 1,
        style: TextStyle(color: Colors.grey),
      ),
      trailing: buildStateTip(),
      onTap: () {},
    );
  }

  Widget buildStateTip() {
    switch (_state) {
      case UploadState.Uploading:
      case UploadState.Saving:
        return SizedBox(
          width: 16,
          height: 16,
          child: CupertinoActivityIndicator(),
        );
      case UploadState.Complete:
        return Icon(
          Icons.done,
          size: 16,
        );
      case UploadState.UploadFail:
      case UploadState.SaveFail:
      default:
        return IconButton(
            iconSize: 16,
            icon: Icon(
              Icons.error,
              color: Colors.red,
            ),
            onPressed: () {
              _startUpload();
            });
    }
  }

  /// 状态转文字
  String _parseStateText() {
    switch (_state) {
      case UploadState.Uploading:
        return '上传中';
      case UploadState.Saving:
        return '保存中';
      case UploadState.Complete:
        return '已完成';
      case UploadState.UploadFail:
        return '上传失败';
      case UploadState.SaveFail:
        return '保存失败';
      default:
        return '未知';
    }
  }

  /// 开始上传
  _startUpload() {
    setState(() {
      _state = UploadState.Uploading;
    });
    _presenter.doUploadImage(widget.file, widget.rename);
  }

  @override
  uploadFaild(String errorMsg) {
    setState(() {
      _state = UploadState.UploadFail;
    });
  }

  @override
  uploadSuccess(String url) {
    setState(() {
      _state = UploadState.Complete;
    });
  }
}
