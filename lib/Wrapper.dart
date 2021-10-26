import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruta_del_desierto/Modelos/MyUser.dart';
import 'package:ruta_del_desierto/Vistas/Login.dart';
import 'package:ruta_del_desierto/Vistas/Logged.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);

    if (user == null) {
      return Login();
    } else {
      return Logged();
    }
  }
}
