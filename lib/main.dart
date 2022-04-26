import 'package:flutter/material.dart';

void main() {
  runApp(BethelSmallholdingApp());
}

class BethelSmallholdingApp extends StatelessWidget {
  const BethelSmallholdingApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bethel Smallholding',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: Container(
        color: Colors.white,
      ),
    );
  }
}
