import 'package:flutter/material.dart';
import 'package:flutter_picgo/model/theme_state.dart';
import 'package:provider/provider.dart';

class ThemeSettingPage extends StatefulWidget {
  _ThemeSettingPageState createState() => _ThemeSettingPageState();
}

class _ThemeSettingPageState extends State<ThemeSettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('主题设置'),
      ),
      body: Consumer<ThemeState>(
        builder: (context, themeState, child) {
          return ListView(
            children: <Widget>[
              ListTile(
                title: Text(ThemeState.modeMap[ThemeMode.system]),
                trailing: themeState.currentMode == ThemeMode.system
                    ? Icon(Icons.check)
                    : null,
                onTap: () {
                  _changeThemeMode(themeState, ThemeMode.system);
                },
              ),
              ListTile(
                title: Text(ThemeState.modeMap[ThemeMode.light]),
                trailing: themeState.currentMode == ThemeMode.light
                    ? Icon(Icons.check)
                    : null,
                onTap: () {
                  _changeThemeMode(themeState, ThemeMode.light);
                },
              ),
              ListTile(
                title: Text(ThemeState.modeMap[ThemeMode.dark]),
                trailing: themeState.currentMode == ThemeMode.dark
                    ? Icon(Icons.check)
                    : null,
                onTap: () {
                  _changeThemeMode(themeState, ThemeMode.dark);
                },
              )
            ],
          );
        },
      ),
    );
  }

  _changeThemeMode(ThemeState state, ThemeMode mode) {
    state.changeThemeState(mode);
  }
}
