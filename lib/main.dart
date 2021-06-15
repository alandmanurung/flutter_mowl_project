// @dart=2.9
import 'package:flutter/material.dart';
import 'screens/loading_screen.dart';

void main() {
  runApp(MyApp());
}

//To change the mall directories and mall locations, please head to featureget.dart and change the link there

//Redirect to loading_screen to get mall locations data
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoadingScreen(),
    );
  }
}
