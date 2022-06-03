import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:proj1/Pages/TestToDoPages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: TestToDoPages(), title: "Todo List");
  }
}
