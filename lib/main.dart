import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      home: const RootRedirect(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/admin': (context) => const AdminHomeScreen(),
      },
    );
  }
}

class RootRedirect extends StatelessWidget {
  const RootRedirect({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Jika user masih login, langsung ke home
      return const HomeScreen();
    } else {
      // Kalau belum login, tampilkan login
      return const LoginPage();
    }
  }
}
