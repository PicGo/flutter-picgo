import 'dart:io';
import 'dart:math';

import 'package:extended_image/extended_image.dart';
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
          ? TransparentMaterialPageRoute(builder: (_) => page)
          : TransparentCupertinoPageRoute(builder: (_) => page),
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
            ? TransparentMaterialPageRoute(builder: (_) => page)
            : TransparentCupertinoPageRoute(builder: (_) => page));
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
        child: ExtendedImageGesturePageView.builder(
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
          scrollDirection: Axis.horizontal,
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
                  title: Text('复制链接'),
                  onTap: () {
                    _handleCopy(context);
                  },
                ),
              ],
            ),
          ));
        });
  }

  /// 复制链接
  _handleCopy(BuildContext context) {
    Clipboard.setData(
        ClipboardData(text: widget.galleryItems[currentIndex].path));
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
