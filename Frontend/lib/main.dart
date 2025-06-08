import 'dart:io';

import 'package:flutter/material.dart';
import 'package:latihan/pages/home_page.dart';
import 'package:latihan/pages/auth/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  final key = await SharedPreferences.getInstance();
  final statusLogin = key.getBool('statusLogin') ?? false;
  runApp(MyApp(status: statusLogin,));
}

class MyApp extends StatelessWidget {
  MyApp({required this.status});
  bool status;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Latihan',
      home: status ? HomePage() : LoginPage(),
    );
  }
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
