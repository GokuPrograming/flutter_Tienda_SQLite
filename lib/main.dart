import 'package:flutter/material.dart';
import 'package:store_sqlite/routes/rutes.dart';
import 'package:store_sqlite/screens/login/login_ScreenH.dart';
import 'package:store_sqlite/screens/login/login_screenV.dart';
import 'package:store_sqlite/screens/loginResponsiveScreen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: const loginResponsiveScreen(
          pantallaVerticalMobile: LoginScreenVertical(),
          pantallaHorizontalMobile: LoginScreenHorizontal()),
      routes: AppRoutes.routes,
    );
  }
}
