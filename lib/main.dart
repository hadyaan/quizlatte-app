import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quiz/firebase_options.dart';
import 'package:quiz/theme/theme.dart';
import 'package:quiz/view/admin/admin_home_screen.dart';
import 'package:quiz/view/user/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Quizlatte",
      theme: AppTheme.theme,
      home: HomeScreen(),
    );
  }
}

// flutter build web

// cd build/web
// python -m http.server 8080

// http://localhost:8080
