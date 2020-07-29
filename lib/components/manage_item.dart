import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

typedef GestureTapCallback = void Function();

class ManageItem extends StatelessWidget {
  final String url;
  final String name;
  final String time;
  final FileContentType type;
  final GestureTapCallback onTap;

  ManageItem(this.url, this.name, this.time, this.type, {this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: buildLeading(),
      title: Text(
        this.name,
        maxLines: 2,
        style: TextStyle(color: Colors.black),
      ),
      subtitle: Text(
        this.time,
        maxLines: 1,
        style: TextStyle(color: Colors.grey),
      ),
    );
  }

  Widget buildLeading() {
    if (this.type == FileContentType.DIR) {
      return buildCenterIcon(Icon(IconData(0xe63f, fontFamily: 'iconfont')));
    }
    try {
      String path = Uri.parse(this.url).path;
      String suffix = extension(path).replaceFirst('.', '');
      var imageSuffixs = ['png', 'bmp', 'jpeg', 'gif', 'jpg'];
      if (imageSuffixs.contains(suffix)) {
        return SizedBox(
          height: 50,
          width: 50,
          child: Card(
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(8)),
            child: CachedNetworkImage(
              imageUrl: this.url,
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
        );
      } else {
        return buildCenterIcon(Icon(IconData(0xe654, fontFamily: 'iconfont')));
      }
    } catch (e) {
      return buildCenterIcon(Icon(IconData(0xe654, fontFamily: 'iconfont')));
    }
  }

  Widget buildCenterIcon(Icon icon) {
    return SizedBox(
      height: 50,
      width: 50,
      child: Center(
        child: icon,
      ),
    );
  }
}

/// 文件类型
enum FileContentType {
  /// 文件
  FILE,

  /// 文件夹
  DIR,
}
