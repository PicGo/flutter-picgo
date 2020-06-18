import 'dart:io';

import 'package:flutter/material.dart';

/// 图片选择预览Dialog
class PickerImageDialog extends Dialog {
  final String imageName;
  final String imagePath;

  PickerImageDialog(this.imageName, this.imagePath);

  TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    _controller = TextEditingController(text: imageName);
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: SizedBox(
          height: 280.0,
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
            child: Container(
              width: double.infinity,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    height: 180,
                    width: double.infinity,
                    child: Image.file(File(this.imagePath), fit: BoxFit.cover),
                  ),
                  SizedBox(height: 10),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: 40,
                    ),
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "请输入图片名称，注意保留后缀",
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 30,
                    child: Row(
                      children: <Widget>[
                        SizedBox(width: 10),
                        Expanded(
                          child: RaisedButton(
                            color: Theme.of(context).accentColor,
                            textColor: Colors.white,
                            child: Text('取消'),
                            onPressed: () {},
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: RaisedButton(
                            color: Theme.of(context).accentColor,
                            textColor: Colors.white,
                            child: Text('上传'),
                            onPressed: () {},
                          ),
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
