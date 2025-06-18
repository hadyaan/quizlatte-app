import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz/view/user/home_screen.dart';
import 'package:quiz/theme/theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isSignup = false;
  Duration get loadingTime => const Duration(milliseconds: 2000);

  Future<String?> _authUser(LoginData data) async {
    _isSignup = false;
    try {
      await _auth.signInWithEmailAndPassword(
        email: data.name,
        password: data.password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'Login failed';
    }
  }

  Future<String?> _signupUser(SignupData data) async {
    _isSignup = true;
    try {
      if (data.name == null || data.password == null) {
        return 'Email and password cannot be empty';
      }
      await _auth.createUserWithEmailAndPassword(
        email: data.name!,
        password: data.password!,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'Signup failed';
    }
  }

  Future<String?> _recoverPassword(String email) async {
    _isSignup = false;
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'Password reset failed';
    }
  }

  Future<void> _logout() async {
    await _auth.signOut();
  }

  void _onSubmitAnimationCompleted() {
    final user = _auth.currentUser;
    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterLogin(
        loginAfterSignUp: false,
        onLogin: _authUser,
        onSignup: _signupUser,
        onRecoverPassword: _recoverPassword,
        onSubmitAnimationCompleted: _onSubmitAnimationCompleted,
        headerWidget: Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: Text(
            'Welcome to Quizlatte!',
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        theme: LoginTheme(
          primaryColor: AppTheme.cardColor, // Coklat tua
          accentColor: AppTheme.cardColor,
          cardTheme: const CardTheme(
            color: Color(0xFF795548),
            elevation: 16,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(24)),
            ),
          ),
          textFieldStyle: TextStyle(color: Colors.black),
          inputTheme: const InputDecorationTheme(
            filled: true,
            fillColor: Color(0xFF795548),
            labelStyle: TextStyle(color: Colors.black),
            hintStyle: TextStyle(color: Colors.black54),
            prefixIconColor: Colors.black,
            suffixIconColor: Colors.black,
            iconColor: Colors.black,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: Colors.black45),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: Colors.black),
            ),
          ),
          titleStyle: const TextStyle(
            fontSize: 32,
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
          buttonStyle: const TextStyle(color: Colors.white),
          errorColor: Colors.redAccent,
        ),
      ),
    );
  }
}
