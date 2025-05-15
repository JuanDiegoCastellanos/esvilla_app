import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme extends ChangeNotifier {
  static final ThemeData lightTheme = ThemeData(
      primarySwatch: Colors.green,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        color: Colors.red,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.red,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      fontFamily: 'Lexend');
}

class GlobalStatusBarConfig extends StatelessWidget {
  final Widget child;

  const GlobalStatusBarConfig({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.red,
      statusBarIconBrightness: Brightness.light,
    ));
    return child;
  }
}
