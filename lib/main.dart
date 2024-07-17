import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'sign_in.dart';
import 'home.dart';

// void main() => runApp(MyApp());
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Google',
      home: Home(),
    );
  }
} 
