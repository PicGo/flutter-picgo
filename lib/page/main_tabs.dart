import 'package:flutter/material.dart';

import 'album.dart';
import 'setting.dart';

class MainTabsPage extends StatefulWidget {

  static const routeName = '/';

  final int selectedIndex;

  MainTabsPage({this.selectedIndex = 0});

  @override
  _MainTabsPageState createState() => _MainTabsPageState(this.selectedIndex);

}

class _MainTabsPageState extends State<MainTabsPage> {

  int _selectedIndex;

  _MainTabsPageState(this._selectedIndex);

  List<Widget> _list = [AlbumPage(), SettingPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: this._list[this._selectedIndex],
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
            title: Text('相册')
          ),
          BottomNavigationBarItem(
            icon: Icon(IconData(0xe634, fontFamily: 'iconfont')),
            title: Text('设置')
          ),
        ],
      ),
    );
  }

}