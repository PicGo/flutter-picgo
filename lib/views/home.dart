import 'package:flutter/material.dart';

import 'album_page/album_page.dart';
import 'setting_page/setting_page.dart';

class AppPage extends StatefulWidget {

  final int selectedIndex;

  AppPage({this.selectedIndex = 0});

  @override
  _MainTabsPageState createState() => _MainTabsPageState(this.selectedIndex);

}

class _MainTabsPageState extends State<AppPage> {

  int _selectedIndex;

  _MainTabsPageState(this._selectedIndex);

  List<Widget> _pageList = [AlbumPage(), SettingPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: this._pageList[this._selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: this._selectedIndex,
        onTap: (value) {
          setState(() {
            this._selectedIndex = value;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(IconData(0xe621, fontFamily: 'iconfont')),
            label:'相册'
          ),
          BottomNavigationBarItem(
            icon: Icon(IconData(0xe634, fontFamily: 'iconfont')),
            label: '设置'
          ),
        ],
      ),
    );
  }

}