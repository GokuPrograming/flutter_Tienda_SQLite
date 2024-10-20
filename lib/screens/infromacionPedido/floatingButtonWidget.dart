import 'package:flutter/material.dart';
import 'package:animated_floating_buttons/animated_floating_buttons.dart';

class Floatingbuttonwidget extends StatefulWidget {
  final int? id;
  const Floatingbuttonwidget(this.id, {super.key});

  @override
  State<Floatingbuttonwidget> createState() => _FloatingbuttonwidgetState();
}

class _FloatingbuttonwidgetState extends State<Floatingbuttonwidget> {
  final GlobalKey<AnimatedFloatingActionButtonState> key =
      GlobalKey<AnimatedFloatingActionButtonState>();
  Widget float1() {
    return Container(
      child: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/productos');
        },
        heroTag: "new",
        tooltip: 'First button',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget float2() {
    return Container(
      child: FloatingActionButton(
        onPressed: () {
          print(widget.id);
        },
        heroTag: "edit",
        tooltip: 'Second button',
        child: Icon(Icons.edit),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedFloatingActionButton(
        //Fab list
        fabButtons: <Widget>[float1(), float2()],
        key: key,
        colorStartAnimation: Colors.blue,
        colorEndAnimation: Colors.red,
        animatedIconData: AnimatedIcons.menu_close //To principal button
        );
  }
}
