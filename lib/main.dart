import 'package:expenses/views/home/homepage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expenses APP',
      theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.purple,
          fontFamily: 'Quicksand'),
      home: HomePage(),
    );
  }
}
