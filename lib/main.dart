import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter_picgo/model/theme_state.dart';
import 'package:flutter_picgo/resources/theme_colors.dart';
import 'package:flutter_picgo/routers/application.dart';
import 'package:flutter_picgo/routers/routers.dart';
import 'package:flutter_picgo/utils/db_provider.dart';
import 'package:flutter_picgo/utils/local_notification.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  /// needed if you intend to initialize in the `main` function
  WidgetsFlutterBinding.ensureInitialized();
  final provider = DbProvider();
  await provider.init();

  /// notification initialization
  LocalNotificationUtil.getInstance().initialization();

  /// run App
  runApp(App());
}

class App extends StatefulWidget {
  App() {
    final router = new Router();
    Routes.configureRoutes(router);
    Application.router = router;
  }

  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeState(),
        ),
      ],
      child: Consumer<ThemeState>(
        builder: (context, state, child) {
          return state.currentMode == ThemeMode.system
              ? MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: lightThemeData,
                  darkTheme: darkThemeData,
                  initialRoute: '/',
                  onGenerateRoute: Application.router.generator,
                )
              : MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: state.currentMode == ThemeMode.light
                      ? lightThemeData
                      : darkThemeData,
                  initialRoute: '/',
                  onGenerateRoute: Application.router.generator,
                );
        },
      ),
    );
  }
}
