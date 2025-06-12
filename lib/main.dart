import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quiz/auth/login_page.dart';
import 'package:quiz/firebase_options.dart';
import 'package:quiz/theme/theme.dart';
import 'package:quiz/view/admin/admin_home_screen.dart';
import 'package:quiz/view/user/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Quizlatte",
      theme: AppTheme.theme,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/home': (context) => const HomeScreen(),
        '/admin': (context) => const AdminHomeScreen(), // jika kamu butuh rute untuk admin
      },
    );
  }
}
