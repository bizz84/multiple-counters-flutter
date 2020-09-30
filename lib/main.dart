import 'package:flutter/material.dart';
import 'package:multiple_counters_flutter/bottom_navigation.dart';

//Main function
void main() => runApp(new MyApp());

//Stateless widget
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multiple counters',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: BottomNavigation(),
    );
  }
}
