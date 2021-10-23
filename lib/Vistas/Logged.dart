import 'package:flutter/material.dart';
import 'package:boletos_abordo/Vistas/Inicio.dart';
import 'package:boletos_abordo/Vistas/Data.dart';

class Logged extends StatefulWidget {
  @override
  _LoggedState createState() => _LoggedState();
}

class _LoggedState extends State<Logged> {
  bool showInicio = true;
  void changeView() {
    setState(() => showInicio = !showInicio);
  }

  @override
  Widget build(BuildContext context) {
    if (showInicio) {
      return Inicio(changeView: changeView);
    } else {
      return Data();
    }
  }
}
