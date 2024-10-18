import 'package:flutter/material.dart';
import 'package:store_sqlite/routes/rutes.dart';
import 'package:store_sqlite/screens/MenuAppResponsiveScreen.dart';
import 'package:store_sqlite/screens/menuApp/MenuApp_screenH.dart';
import 'package:store_sqlite/screens/menuApp/MenuApp_screenV.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const Menuappresponsivescreen(
          pantallaVerticalMobile: MenuappScreenv(),
          pantallaHorizontalMobile: MenuappScreenH()),
      routes: AppRoutes.routes,
    );
  }
}
