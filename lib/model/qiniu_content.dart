import 'package:flutter_picgo/components/manage_item.dart';

class QiniuContent {
  FileContentType type;
  /// FILE 时为空， DIR时不能为空
  String url;
  String key;
  String hash;
  int fsize;
  String mimeType;
  int putTime;
  String md5;
  int status;

  QiniuContent(
      {this.type,
      this.key,
      this.hash,
      this.fsize,
      this.mimeType,
      this.putTime,
      this.md5,
      this.status});

  QiniuContent.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    hash = json['hash'];
    fsize = json['fsize'];
    mimeType = json['mimeType'];
    putTime = json['putTime'];
    md5 = json['md5'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['hash'] = this.hash;
    data['fsize'] = this.fsize;
    data['mimeType'] = this.mimeType;
    data['putTime'] = this.putTime;
    data['md5'] = this.md5;
    data['status'] = this.status;
    return data;
  }
}
