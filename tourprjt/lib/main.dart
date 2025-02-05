import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:tourprjt/Splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.openBox('usersBox');
  Hive.openBox('tourbox');
  Hive.openBox('concertbox');
  Hive.openBox('eventbox');
  Hive.openBox('bookingbox');
  runApp(MaterialApp(
    home: SplashScreen(),
    debugShowCheckedModeBanner: false,
  ));
}
