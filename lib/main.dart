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
      title: 'Lince Food',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light, // Tema claro
        primaryColor: const Color.fromARGB(255, 255, 99, 71), // Rojo tomate
        scaffoldBackgroundColor: const Color.fromARGB(255, 255, 248, 225), // Blanco cremoso
        fontFamily: 'Lobster', // Fuente temática para comida
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 255, 99, 71), // Fondo del AppBar
          titleTextStyle: TextStyle(
            color: Color.fromARGB(255, 255, 248, 225), // Texto blanco cremoso
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(
            color: Color.fromARGB(255, 255, 248, 225), // Íconos del AppBar
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color.fromARGB(255, 255, 99, 71), // Fondo FAB
          foregroundColor: Color.fromARGB(255, 255, 248, 225), // Ícono FAB
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color.fromARGB(255, 50, 205, 50), // Verde albahaca
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 255, 99, 71), // Fondo de botón
            foregroundColor: const Color.fromARGB(255, 255, 248, 225), // Texto del botón
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        drawerTheme: const DrawerThemeData(
          backgroundColor: Color.fromARGB(255, 255, 248, 225), // Fondo del Drawer
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            color: Color.fromARGB(255, 47, 47, 47), // Texto principal
            fontSize: 18,
          ),
          bodyMedium: TextStyle(
            color: Color.fromARGB(255, 79, 79, 79), // Subtítulos
            fontSize: 16,
          ),
          titleLarge: TextStyle(
            color: Color.fromARGB(255, 47, 47, 47), // Títulos grandes
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
          titleSmall: TextStyle(
            color: Color.fromARGB(255, 50, 205, 50), // Verde albahaca
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 50, 205, 50), // Verde albahaca para íconos
        ),
      ),
      home: const Menuappresponsivescreen(
        pantallaVerticalMobile: MenuappScreenv(),
        pantallaHorizontalMobile: MenuappScreenH(),
      ),
      routes: AppRoutes.routes,
    );
  }
}
