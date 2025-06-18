import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

class RootRedirect extends StatefulWidget {
  const RootRedirect({super.key});

  @override
  State<RootRedirect> createState() => _RootRedirectState();
}

class _RootRedirectState extends State<RootRedirect> {
  Widget? _startScreen;

  @override
  void initState() {
    super.initState();
    _determineStartScreen();
  }

  Future<void> _determineStartScreen() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final prefs = await SharedPreferences.getInstance();
      final role = prefs.getString('user_role') ?? 'user';

      setState(() {
        if (role == 'admin') {
          _startScreen = const AdminHomeScreen();
        } else {
          _startScreen = const HomeScreen();
        }
      });
    } else {
      setState(() {
        _startScreen = const LoginPage();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_startScreen == null) {
      // Tampilkan loading sementara menunggu async selesai
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return _startScreen!;
  }
}
