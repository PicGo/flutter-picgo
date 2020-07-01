import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter_picgo/resources/theme_colors.dart';
import 'package:flutter_picgo/routers/application.dart';
import 'package:flutter_picgo/routers/routers.dart';
import 'package:flutter_picgo/utils/db_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final provider = DbProvider();
  await provider.init();
  runApp(App());
}

class App extends StatelessWidget {
  App() {
    final router = new Router();
    Routes.configureRoutes(router);
    Application.router = router;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightThemeData,
      darkTheme: darkThemeData,
      initialRoute: '/',
      onGenerateRoute: Application.router.generator,
    );
  }
}
