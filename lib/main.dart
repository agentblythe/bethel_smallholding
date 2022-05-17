import 'package:bethel_smallholding/app/landing_page.dart';
import 'package:bethel_smallholding/services/auth.dart';
import 'package:bethel_smallholding/services/auth_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(BethelSmallholdingApp());
}

class BethelSmallholdingApp extends StatelessWidget {
  const BethelSmallholdingApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AuthProvider(
      auth: Auth(),
      child: MaterialApp(
        title: 'Bethel Smallholding',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LandingPage(),
      ),
    );
  }
}
