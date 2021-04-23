import 'dart:io';
import 'dart:math';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_picgo/model/uploaded.dart';
import 'package:flutter_picgo/utils/extended.dart';
import 'package:toast/toast.dart';

class ImagePreviewUtils {
  /// 打开图片预览页面
  static void open(BuildContext context, Uploaded content) {
    var page = GalleryPhotoViewWrapper(
      galleryItems: [content],
    );
    Navigator.push(
      context,
      Platform.isAndroid
          ? MaterialPageRoute(builder: (_) => page)
          : CupertinoPageRoute(builder: (_) => page),
    );
  }

  static void openMulti(BuildContext context, int index, List<Uploaded> items) {
    var page = GalleryPhotoViewWrapper(
      galleryItems: items,
      initialIndex: index,
    );
    Navigator.push(
        context,
        Platform.isAndroid
            ? MaterialPageRoute(builder: (_) => page)
            : CupertinoPageRoute(builder: (_) => page));
  }
}

class GalleryPhotoViewWrapper extends StatefulWidget {
  final int initialIndex;
  final List<Uploaded> galleryItems;

  GalleryPhotoViewWrapper({
    this.initialIndex = 0,
    @required this.galleryItems,
  });

  @override
  State<StatefulWidget> createState() {
    return _GalleryPhotoViewWrapperState();
  }
}

class _GalleryPhotoViewWrapperState extends State<GalleryPhotoViewWrapper> {
  int currentIndex;

  @override
  void initState() {
    currentIndex = widget.initialIndex;
    super.initState();
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ExtendedImageSlidePage(
      slideAxis: SlideAxis.both,
      slideType: SlideType.onlyImage,
      slidePageBackgroundHandler: (offset, pageSize) =>
          defaultSlidePageBackgroundHandler(
              offset: offset,
              pageSize: pageSize,
              color: Colors.black,
              pageGestureAxis: SlideAxis.both),
      child: GestureDetector(
        child: Stack(
          // fit: StackFit.expand,
          alignment: Alignment.bottomRight,
          children: [
            ExtendedImageGesturePageView.builder(
              itemBuilder: (BuildContext context, int index) {
                var item = widget.galleryItems[index];
                Widget image = item.path.startsWith('http')
                    ? ExtendedImage.network(
                        item.path,
                        fit: BoxFit.contain,
                        cache: true,
                        mode: ExtendedImageMode.gesture,
                        enableSlideOutPage: true,
                        loadStateChanged: (state) =>
                            defaultLoadStateChanged(state, iconSize: 50),
                      )
                    : ExtendedImage.file(
                        File(item.path),
                        fit: BoxFit.contain,
                        mode: ExtendedImageMode.gesture,
                        enableSlideOutPage: true,
                        loadStateChanged: (state) =>
                            defaultLoadStateChanged(state, iconSize: 50),
                      );
                image = Container(
                  child: image,
                );
                if (index == currentIndex) {
                  return Hero(
                    tag: index,
                    child: image,
                  );
                } else {
                  return image;
                }
              },
              itemCount: widget.galleryItems.length,
              controller: PageController(
                initialPage: currentIndex,
              ),
              onPageChanged: onPageChanged,
              scrollDirection: Axis.horizontal,
            ),
            SafeArea(
                child: Container(
              margin: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  color: Colors.grey),
              padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
              child: Text(
                '${currentIndex + 1} / ${widget.galleryItems.length}',
                style: TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.normal,
                    fontSize: 10),
              ),
            ))
          ],
        ),
        onLongPress: () {
          _showBottomPane();
        },
      ),
    );
  }

  /// 底部弹窗
  _showBottomPane() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SafeArea(
              child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text(
                    '图床类型',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(widget.galleryItems[currentIndex].type),
                ),
                ListTile(
                  title: Text(
                    '图片链接',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(widget.galleryItems[currentIndex].path),
                  onTap: () {
                    _handleCopy(
                        widget.galleryItems[currentIndex].path, context);
                  },
                ),
                ListTile(
                  title: Text(
                    '图片信息',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(widget.galleryItems[currentIndex].info),
                  onTap: () {
                    _handleCopy(
                        widget.galleryItems[currentIndex].info, context);
                  },
                ),
                ListTile(
                  title: Text(
                    '取消',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ));
        });
  }

  /// 复制链接
  _handleCopy(String content, BuildContext context) {
    Clipboard.setData(ClipboardData(text: content));
    Toast.show('已复制到剪切板', context);
    Navigator.pop(context);
  }

  Color defaultSlidePageBackgroundHandler(
      {Offset offset, Size pageSize, Color color, SlideAxis pageGestureAxis}) {
    double opacity = 0.0;
    if (pageGestureAxis == SlideAxis.both) {
      opacity = offset.distance /
          (Offset(pageSize.width, pageSize.height).distance / 2.0);
    } else if (pageGestureAxis == SlideAxis.horizontal) {
      opacity = offset.dx.abs() / (pageSize.width / 2.0);
    } else if (pageGestureAxis == SlideAxis.vertical) {
      opacity = offset.dy.abs() / (pageSize.height / 2.0);
    }
    return color.withOpacity(min(1.0, max(1.0 - opacity, 0.0)));
  }
}
