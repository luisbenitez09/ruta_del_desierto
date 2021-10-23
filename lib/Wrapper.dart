import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:boletos_abordo/Modelos/MyUser.dart';
import 'package:boletos_abordo/Vistas/Login.dart';
import 'package:boletos_abordo/Vistas/Logged.dart';

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
