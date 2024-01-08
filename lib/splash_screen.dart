import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; 
import 'login.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkLoginStatus(); // Panggil fungsi untuk memeriksa status login
  }

  Future<void> checkLoginStatus() async {
    // Delay splash screen for 3 seconds
    Timer(
      Duration(seconds: 3),
      () async {
        // Mengecek status login
        SharedPreferences prefs = await SharedPreferences.getInstance();
        bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

        if (isLoggedIn) {
          // Jika sudah login, pindah ke NextScreen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => NextScreen()),
          );
        } else {
          // Jika belum login, pindah ke layar login
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Login()),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'logo.png',
          height: 200.0,
          width: 200.0,
        ),
      ),
    );
  }
}

class NextScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Widget untuk layar berikutnya
    return Scaffold(
      appBar: AppBar(
        title: Text('Next Screen'),
      ),
      body: Center(
        child: Text('Ini adalah layar berikutnya!'),
      ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      home: SplashScreen(),
    ),
  );
}
