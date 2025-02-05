import 'package:flutter/material.dart';
import 'package:tourprjt/user/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.passthrough,
        children: [
         Center(
          child:  Image.asset(
            'assets/logo.jpg', 
            fit: BoxFit.cover,
          ),
         )
          
        ],
      ),
    );
  }
}