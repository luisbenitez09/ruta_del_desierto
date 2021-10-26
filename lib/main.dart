import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ruta_del_desierto/Controladores/auth.dart';
import 'package:ruta_del_desierto/Modelos/MyUser.dart';
import 'package:ruta_del_desierto/Wrapper.dart';
import 'package:ruta_del_desierto/Vistas/Login.dart';
import 'package:ruta_del_desierto/Vistas/Inicio.dart';
import 'package:ruta_del_desierto/Vistas/Data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(BoletosAbordo());
}

class BoletosAbordo extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return StreamProvider<MyUser>.value(
      value: AuthService().user,
      child: MaterialApp(
        routes: {
          '/': (context) => Wrapper(),
          '/login': (context) => Login(),
          '/inicio': (context) => Inicio(),
          '/data': (context) => Data(),
        },
      ),
    );
  }
}

class Error extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Espera'),
    );
  }
}
