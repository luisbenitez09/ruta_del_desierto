import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruta_del_desierto/Controladores/auth.dart';
import 'package:ruta_del_desierto/Modelos/MyUser.dart';
import 'package:http/http.dart' as http;

class Respuesta {
  final bool success;
  final String error;

  Respuesta({this.success, this.error});

  factory Respuesta.fromJson(Map<String, dynamic> json) {
    return Respuesta(success: json['success'], error: json['errorMessage']);
  }
}

class Inicio extends StatefulWidget {
  final Function changeView;
  Inicio({this.changeView});

  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  String pass = '';
  //TODO Future update, connect to firebase cloud function
  static const URL =
      'http://187.141.142.89:5558/WsServicesApiRsd/ruta/checkticket';

  final passInput = TextEditingController();
  clearInput() {
    passInput.clear();
  }

  FocusNode myFocusNode;

  final codeInput = TextEditingController();
  clearCodeInput() {
    codeInput.clear();
  }

  static const rojo = Color(0xFFd33211);
  static const verde = Color(0xFF26aa39);
  static const morado = Color(0xFF5d3a8e);
  static const naranja = Color(0xFFefb14e);
  Color panel,
      panelMorado = morado,
      panelVerde = verde,
      panelRojo = rojo,
      orange = naranja;

  String messageES, messageEN;
  String defaultMsg = 'Escanea tu boleto';
  String defaultMsgEN = 'Scann your ticket';
  String accepted = 'Aceptado';
  String acceptedEN = 'Accepted';
  String rejected = 'Rechazado';
  String rejectedEN = 'Rejected';
  String alert = '', alertEN = '';
  String msjAlert = '¡Boleto inválido!';
  String msjAlertEN = 'Invalid ticket!';
  bool firstLoad = true;

  String driver = '';
  String uid = '';
  String driverName = '';
  String driverUID = '';

  var qrText = "";
  var locked = false;

  int counterCode = 0;

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double panH = h - 40.0;
    double w = MediaQuery.of(context).size.width;

    if (firstLoad) {
      final user = Provider.of<MyUser>(context);
      setName() {
        driverName = user.name;
        driverUID = user.uid;
        setState(() {
          driver = driverName;
          uid = driverUID;
          myFocusNode = FocusNode();
        });
      }

      setName();

      messageES = defaultMsg;
      messageEN = defaultMsgEN;
      panel = panelMorado;
      firstLoad = false;
    }
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text(
                  'Menú',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0,
                    fontFamily: 'Gilroy',
                  ),
                ),
                decoration: BoxDecoration(
                  color: panelMorado,
                ),
              ),
              ListTile(
                title: Text(
                  'Cerrar Sesión',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    fontFamily: 'Gilroy',
                  ),
                ),
                onTap: () {
                  _askMyPass('logOut');
                },
              ),
            ],
          ),
        ),
        resizeToAvoidBottomInset: true,
        body: CustomPaint(
          painter: BackgroundPainter(),
          child: Row(
            children: <Widget>[
              Container(
                width: w / 2,
                height: panH,
                margin: EdgeInsets.only(left: 50),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          child: Row(
                        children: <Widget>[
                          Container(
                            child: Text(
                              'Conductor ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Gilroy',
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              '/ Driver',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontFamily: 'Gilroy',
                              ),
                            ),
                          )
                        ],
                      )),
                      Text(
                        driver,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Gilroy',
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 60.0),
                        child: Text(
                          'Ruta del Desierto les desea un excelente día.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Gilroy',
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 60.0),
                        child: Text(
                          'Ruta del Desierto wishes you an excelent day.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28.0,
                            fontFamily: 'Gilroy',
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: panH / 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              '¿Conduzco mal? ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Gilroy',
                              ),
                            ),
                            Text(
                              ' / Bad driving?',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontFamily: 'Gilroy',
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'REPORTAME ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Gilroy',
                              ),
                            ),
                            Text(
                              ' / REPORT ME',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontFamily: 'Gilroy',
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              //TODO change number
                              '612-123-45-67',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Gilroy',
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                width: (w / 2) - 75.0,
                height: panH,
                margin: EdgeInsets.only(bottom: 25.0),
                child: Material(
                  elevation: 50.0,
                  borderRadius: BorderRadius.circular(30.0),
                  shadowColor: panel,
                  child: Container(
                    decoration: BoxDecoration(
                        color: panel,
                        borderRadius: BorderRadius.circular(30.0)),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: h / 30.0),
                            child: Text(
                              messageES,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Gilroy',
                                fontWeight: FontWeight.bold,
                                fontSize: 40,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              messageEN,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Gilroy',
                                fontSize: 30,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: panH / 10.0),
                            width: 200.0,
                            height: 200.0,
                            child: TextField(
                              controller: codeInput,
                              focusNode: myFocusNode,
                              autofocus: true,
                              onChanged: (code) async {
                                setState(() {
                                  counterCode++;
                                  FocusScope.of(context)
                                      .requestFocus(myFocusNode);
                                });
                                if (counterCode >= 36) {
                                  setState(() {
                                    qrText = code;
                                    FocusScope.of(context).unfocus();
                                  });
                                  _onReaded();
                                }
                              },
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: h / 25.0),
                            child: Text(
                              alert,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Gilroy',
                                fontWeight: FontWeight.bold,
                                fontSize: 40,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              alertEN,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Gilroy',
                                fontSize: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Future<void> _askMyPass(String action) async {
    AuthService _auth = new AuthService();

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        final user = Provider.of<MyUser>(context);
        return AlertDialog(
          title: Text(
            'Requiere verificación',
            style: TextStyle(
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Ingresa tu contraseña',
                  style: TextStyle(fontFamily: 'Gilroy'),
                ),
                Container(
                  child: TextField(
                    controller: passInput,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Contraseña',
                    ),
                    style: TextStyle(fontFamily: 'Gilroy', fontSize: 15.0),
                    onChanged: (val) {
                      setState(() => pass = val);
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Aceptar'),
              onPressed: () async {
                dynamic result = await _auth.sigIn(user.email, pass, 'Confirm');

                if (result == null) {
                  setState(() => clearInput());
                  _badPass();
                } else {
                  if (action == 'logOut') {
                    setState(() => clearInput());
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    widget.changeView();
                  }
                }
              },
            ),
            TextButton(
              child: Text(
                'Cancelar',
                style: TextStyle(
                  color: Colors.redAccent,
                ),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _badPass() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Contraseña incorrecta',
            style: TextStyle(
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Aceptar'),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _onReaded() async {
    var data = {
      "param1": qrText,
      "param2": uid,
      "param3": "725" //Check if its still needed
    };
    var response = await http.post(URL,
        headers: {
          "Authorization": "Basic ZWMwdXMzcjpqbnRoJDEzODMh",
          "Content-Type": "application/json"
        },
        body: jsonEncode(data));

    var res = jsonDecode(response.body);
    print(res);

    setState(() {
      clearCodeInput();
      FocusScope.of(context).requestFocus(myFocusNode);
    });

    if (response.statusCode == 200) {
      Respuesta res = Respuesta.fromJson(jsonDecode(response.body));
      if (res.success) {
        setState(() {
          panel = panelVerde;
          messageES = accepted;
          messageEN = acceptedEN;
        });
      } else {
        setState(() {
          panel = panelRojo;
          messageES = rejected;
          messageEN = rejectedEN;
          alert = msjAlert;
          alertEN = msjAlertEN;
        });
      }
    } else {
      setState(() {
        panel = panelRojo;
        messageES = "ERROR";
        messageEN = rejectedEN;
        alert = msjAlert;
        alertEN = msjAlertEN;
      });
    }
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      messageES = defaultMsg;
      messageEN = defaultMsgEN;
      panel = panelMorado;
      alert = '';
      alertEN = '';
      counterCode = 0;
      clearCodeInput();
      FocusScope.of(context).requestFocus(myFocusNode);
    });
  }
}

class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final h = size.height;
    final w = size.width;
    const mainPurple = Color(0xFF5d3a8e);
    const darkPurple = Color(0xFF401289);
    const lightPurple = Color(0x4dA28AC9);

    const mainOrange = Color(0xFFefb14e);
    const darkOrange = Color(0xFFed930f);
    const lightOrange = Color(0xFFf7c786);

    const secondPurple = Color(0xFFa4a4cf);
    const blue = Color(0xFF5454c6);
    const pink = Color(0xFFe93c6b);

    Paint paint = new Paint();

    Path mainBackground = Path();
    mainBackground.addRect(Rect.fromLTRB(0, -80.0, w, h));
    paint.color = mainPurple;
    canvas.drawPath(mainBackground, paint);

    Path darkP = new Path();
    darkP.moveTo(w * 0.11, h * -0.2);
    darkP.quadraticBezierTo(w * 0.58, h * -0.0, w * 0.6, h);
    darkP.lineTo(w, h);
    darkP.lineTo(w, h * -0.2);
    darkP.close();
    paint.color = darkPurple;
    canvas.drawPath(darkP, paint);

    Path lightP = new Path();
    lightP.moveTo(0, h * 0.7);
    lightP.quadraticBezierTo(w * 0.15, h * -0.05, w * 0.5, h * -0.2);
    lightP.lineTo(0, h * -0.2);
    lightP.close();
    paint.color = lightPurple;
    canvas.drawPath(lightP, paint);

    Path mainO = new Path();
    mainO.moveTo(w * 0.565, h * -0.2);
    mainO.quadraticBezierTo(w * 0.6, h * 0.5, w * 0.45, h);
    mainO.lineTo(w * 0.78, h);
    mainO.quadraticBezierTo(w, h * 0.7, w, h * -0.2);
    mainO.close();
    paint.color = mainOrange;
    canvas.drawPath(mainO, paint);

    Path lightO = new Path();
    lightO.moveTo(w * 0.55, h * 0.49);
    lightO.quadraticBezierTo(w * 0.59, h * 0.7, w * 0.6, h);
    lightO.lineTo(w * 0.45, h);
    lightO.quadraticBezierTo(w * 0.53, h * 0.73, w * 0.55, h * 0.49);
    lightO.close();
    paint.color = lightOrange;
    canvas.drawPath(lightO, paint);

    Path purpleRing = new Path();
    purpleRing.moveTo(w * 0.7, h * -0.2);
    purpleRing.quadraticBezierTo(w * 0.6, h * 0.2, w * 0.8, h * 0.5);
    purpleRing.quadraticBezierTo(w * 0.8, h * 0.2, w * 0.85, h * -0.2);
    purpleRing.close();
    paint.color = secondPurple;
    canvas.drawPath(purpleRing, paint);

    Path darkO = new Path();
    darkO.moveTo(w * 0.9, h * -0.2);
    darkO.quadraticBezierTo(w * 0.9, h * 0.2, w * 0.9, h * 0.5);
    darkO.lineTo(w, h * 0.5);
    darkO.lineTo(w, h * -0.2);
    darkO.close();
    paint.color = darkOrange;
    canvas.drawPath(darkO, paint);

    Path blueRing = new Path();
    blueRing.moveTo(w * 0.83, h * -0.2);
    blueRing.quadraticBezierTo(w * 0.7, h * 0.2, w * 0.9, h * 0.8);
    blueRing.quadraticBezierTo(w * 1.03, h * 0.3, w * 0.97, h * -0.2);
    blueRing.close();
    paint.color = blue;
    canvas.drawPath(blueRing, paint);

    Path pinkShape = new Path();
    pinkShape.moveTo(w, h * 0.45);
    pinkShape.quadraticBezierTo(w * 0.8, h * 0.35, w * 0.7, h * 0.3);
    pinkShape.quadraticBezierTo(w * 0.8, h * 0.75, w * 0.7, h * 0.8);
    pinkShape.quadraticBezierTo(w * 0.8, h * 0.75, w, h * 0.85);
    pinkShape.close();
    paint.color = pink;
    canvas.drawPath(pinkShape, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
