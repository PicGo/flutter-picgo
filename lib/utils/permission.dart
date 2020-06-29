import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionUtils {
  static Future requestPhotos() async {
    // 检测权限
    var status = await Permission.photos.request();
    return status;
  }

  static Future requestCemera() async {
    var status = await Permission.camera.request();
    return status;
  }

  static showPermissionDialog(BuildContext context, {text: '无法正常访问，因为没有权限'}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('警告'),
            content: Text(text),
            actions: <Widget>[
              FlatButton(
                child: Text('去设置'),
                onPressed: () {
                  openAppSettings();
                },
              ),
            ],
          );
        });
  }
}
