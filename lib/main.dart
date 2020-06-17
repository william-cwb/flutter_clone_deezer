import 'package:flutter/material.dart';
import 'package:flutterplayermusic/src/views/index.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        accentIconTheme: IconThemeData(
          color: Color(0xFFef5466),
        ),
        primaryColor: Color(0xFF121216),
        accentColor: Color(0xFF23232d),
        textTheme: TextTheme(
          body1: TextStyle(
            color: Colors.white,
          ),
          title: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: IndexPage(),
    );
  }
}
