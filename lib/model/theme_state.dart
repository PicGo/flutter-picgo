import 'package:flutter/material.dart';
import 'package:flutter_picgo/utils/shared_preferences.dart';

class ThemeState with ChangeNotifier {
  ThemeMode _mode;
  ThemeMode get currentMode => _mode;

  static const Map<ThemeMode, String> modeMap = {
    ThemeMode.light: '浅色模式',
    ThemeMode.dark: '深色模式',
    ThemeMode.system: '跟随系统'
  };

  ThemeState() {
    _init();
  }

  _init() async {
    var sp = await SpUtil.getInstance();
    int localMode = sp.getInt(SharedPreferencesKeys.localThemeState) ?? 2;
    changeThemeState(_parseState(localMode));
  }

  changeThemeState(ThemeMode mode) async {
    _mode = mode;
    notifyListeners();
    // save state
    var sp = await SpUtil.getInstance();
    sp.putInt(SharedPreferencesKeys.localThemeState, _parseInt(mode));
  }

  /// num转enum
  /// 0：浅色模式  1：深色模式  2：跟随系统
  int _parseInt(ThemeMode s) {
    if (s == ThemeMode.light) {
      return 0;
    } else if (s == ThemeMode.dark) {
      return 1;
    } else {
      return 2;
    }
  }

  /// enmu转num
  ThemeMode _parseState(int mode) {
    if (mode == 0) {
      return ThemeMode.light;
    } else if (mode == 1) {
      return ThemeMode.dark;
    } else {
      return ThemeMode.system;
    }
  }
}
