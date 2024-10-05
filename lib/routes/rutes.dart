import 'package:flutter/material.dart';
import 'package:store_sqlite/screens/login/login_ScreenH.dart';
import 'package:store_sqlite/screens/login/login_screenV.dart';
import 'package:store_sqlite/screens/loginResponsiveScreen.dart';

class AppRoutes {
  static const menuScreen = '/MenuScreen';
  static const loginScreen = '/loginScreen';

  static final routes = <String, WidgetBuilder>{
    //recibe una cadena , y un witget
    loginScreen: (context) => const loginResponsiveScreen(
        pantallaVerticalMobile: LoginScreenVertical(),
        pantallaHorizontalMobile: LoginScreenHorizontal())
  };
}
