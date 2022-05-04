import 'package:bethel_smallholding/app/sign_in/sign_in_page.dart';
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
        primarySwatch: Colors.blue,
      ),
      home: SignInPage(),
    );
  }
}
