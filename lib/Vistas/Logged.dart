import 'package:flutter/material.dart';
import 'package:ruta_del_desierto/Vistas/Inicio.dart';
import 'package:ruta_del_desierto/Vistas/Data.dart';

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
