import 'package:flutter/material.dart';

import 'only_pie.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}




class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
//  https://github.com/geordyvcErasmus/flutter_sms




   getIndianRupee(value) {
    final regexp = RegExp("[Rs|IN][Rs\\s|IN.](\\d+[.](\\d\\d|\\d))");
    final match = regexp.firstMatch(value);
    return double.tryParse(match.group(1));
  }

  @override
  Widget build(BuildContext context) {
     return HomeOnlyPiePage();
  }
}
