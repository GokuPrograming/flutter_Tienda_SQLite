import 'package:flutter/material.dart';

class loginResponsiveScreen extends StatelessWidget {
  const loginResponsiveScreen(
      {super.key,
      required this.pantallaVerticalMobile,
      required this.pantallaHorizontalMobile});

  final Widget pantallaVerticalMobile;
  final Widget pantallaHorizontalMobile;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth < 600) {
          return pantallaVerticalMobile;
        } else {
          return pantallaHorizontalMobile;
        }
      },
    );
  }
}
