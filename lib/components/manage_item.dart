import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picgo/utils/extended.dart';
import 'package:path/path.dart';

typedef GestureTapCallback = void Function();
typedef DismissDirectionCallback = void Function(DismissDirection direction);

class ManageItem extends StatelessWidget {
  final Key key;
  final String url;
  final String name;
  final String info;
  final FileContentType type;
  final GestureTapCallback onTap;
  final DismissDirectionCallback onDismiss;
  final ConfirmDismissCallback confirmDismiss;

  ManageItem(
    this.key,
    this.url,
    this.name,
    this.info,
    this.type, {
    this.onTap,
    this.onDismiss,
    this.confirmDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: key,
      direction: DismissDirection.endToStart,
      child: Stack(
        children: <Widget>[
          ListTile(
            leading: buildLeading(),
            title: Text(
              this.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textWidthBasis: TextWidthBasis.parent,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            subtitle: Text(
              this.info,
              maxLines: 1,
              style: TextStyle(color: Colors.grey),
            ),
            onTap: onTap,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Divider(
              height: 1,
              color: Theme.of(context).dividerColor,
              indent: 80,
            ),
          )
        ],
      ),
      onDismissed: onDismiss,
      confirmDismiss: confirmDismiss,
      background: Container(
        color: Colors.red,
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
              child: ExtendedImage.network(
                this.url,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                cache: true,
                // border: Border.all(color: Colors.grey, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(8)),
                loadStateChanged: (state) => defaultLoadStateChanged(state),
              ),
            ));
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
