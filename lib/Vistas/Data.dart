import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ruta_del_desierto/Modelos/MyUser.dart';
import 'package:ruta_del_desierto/Controladores/auth.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class Data extends StatefulWidget {
  final Function changeView;
  Data({this.changeView});

  @override
  _DataState createState() => _DataState();
}

class _DataState extends State<Data> {
  static const myPurple = Color(0xFF5d3a8e);
  static const myOrange = Color(0xFFefb14e);
  Color purplePanel = myPurple, orange = myOrange;

  String pass = '';
  String driver = '';
  String driverName = '';
  String driverUID = '';
  String uid = '';
  bool firstLoad = true;

  String type1 = '';
  String quantity1 = '';
  String total1 = '';
  String type2 = '';
  String quantity2 = '';
  String total2 = '';
  String type3 = '';
  String quantity3 = '';
  String total3 = '';
  String type4 = '';
  String quantity4 = '';
  String total4 = '';
  String type5 = '';
  String quantity5 = '';
  String total5 = '';
  String type6 = '';
  String quantity6 = '';
  String total6 = '';
  String subtotal = '';
  double driverCount = 0.0;
  String fullUID = '';

  String url =
      'http://187.141.142.89:5558/WsServicesApiRsd/ruta/resumen/getdata/';
  final passInput = TextEditingController();
  clearInput() {
    passInput.clear();
  }

  getData() async {
    setState(() {
      fullUID = '$url$uid';
    });

    var response = await http.get(fullUID, headers: {
      "Authorization": "Basic ZWMwdXMzcjpqbnRoJDEzODMh",
      "Content-Type": "application/json"
    });

    if (response.statusCode == 200) {
      var res = jsonDecode(response.body);
      setState(() {
        for (int i = 0; i < 6; i++) {
          try {
            switch (res['list'][i]['param1']) {
              case 'Servicio Local':
                quantity1 = res['list'][i]['param2'];
                total1 = res['list'][i]['param3'];
                type1 = 'Servicio Local\n';
                driverCount += double.parse(res['list'][i]['param3']);
                break;
              case 'Servicio Intermedio':
                quantity2 = res['list'][i]['param2'];
                total2 = res['list'][i]['param3'];
                type2 = 'Servicio Intermedio\n';
                driverCount += double.parse(res['list'][i]['param3']);
                break;
              case 'Servicio Directo':
                quantity3 = res['list'][i]['param2'];
                total3 = res['list'][i]['param3'];
                type3 = 'Servicio Directo\n';
                driverCount += double.parse(res['list'][i]['param3']);
                break;
              case 'Servicio Aeropuerto':
                quantity4 = res['list'][i]['param2'];
                total4 = res['list'][i]['param3'];
                type4 = 'Servicio Aeropuerto\n';
                driverCount += double.parse(res['list'][i]['param3']);
                break;
              case 'Servicio Intermedio Preferente':
                quantity5 = res['list'][i]['param2'];
                total5 = res['list'][i]['param3'];
                type5 = 'Servicio Intermedio Preferente\n';
                driverCount += double.parse(res['list'][i]['param3']);
                break;
              case 'Servicio empleados Aereopuerto':
                quantity6 = res['list'][i]['param2'];
                total6 = res['list'][i]['param3'];
                type6 = 'Servicio Empleados Aeropuerto\n';
                driverCount += double.parse(res['list'][i]['param3']);
                break;
            }
          } catch (e) {}
        }
        subtotal = driverCount.toString();
      });
    }
  }

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
        });
        getData();
      }

      setName();
      firstLoad = false;
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
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
                              'Cuenta de:',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Gilroy',
                              ),
                            ),
                          ),
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
                        margin: EdgeInsets.only(top: 10.0),
                        child: Text(
                          'Boletos escaneados:',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Gilroy',
                          ),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 5.0),
                          child: Table(
                            children: [
                              TableRow(children: [
                                Text(
                                  'Tipo de Boleto',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Gilroy',
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Cantidad',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Gilroy',
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Total',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Gilroy',
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ]),
                              TableRow(children: [
                                Text(
                                  type1,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Gilroy',
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  quantity1,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Gilroy',
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  total1,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Gilroy',
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ]),
                              TableRow(children: [
                                Text(
                                  type2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Gilroy',
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  quantity2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Gilroy',
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  total2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Gilroy',
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ]),
                              TableRow(children: [
                                Text(
                                  type3,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Gilroy',
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  quantity3,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Gilroy',
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  total3,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Gilroy',
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ]),
                              TableRow(children: [
                                Text(
                                  type4,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Gilroy',
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  quantity4,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Gilroy',
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  total4,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Gilroy',
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ]),
                              TableRow(children: [
                                Text(
                                  type5,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Gilroy',
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  quantity5,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Gilroy',
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  total5,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Gilroy',
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ]),
                              TableRow(children: [
                                Text(
                                  type6,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Gilroy',
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  quantity6,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Gilroy',
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  total6,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Gilroy',
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ]),
                            ],
                          )),
                    ],
                  ),
                ),
              ),
              Container(
                width: 405.0,
                height: 450.0,
                margin: EdgeInsets.only(bottom: 25.0),
                child: Material(
                  elevation: 50.0,
                  borderRadius: BorderRadius.circular(30.0),
                  shadowColor: purplePanel,
                  child: Container(
                    width: 390.0,
                    decoration: BoxDecoration(
                        color: purplePanel,
                        borderRadius: BorderRadius.circular(30.0)),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 25.0),
                            child: Text(
                              'Subtotal de venta',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Gilroy',
                                fontWeight: FontWeight.bold,
                                fontSize: 40,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 80.0),
                            child: Text(
                              subtotal,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Gilroy',
                                fontWeight: FontWeight.bold,
                                fontSize: 60,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 100.0),
                            child: ButtonTheme(
                              child: ButtonTheme(
                                height: 45.0,
                                minWidth: 180.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(35.0),
                                ),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    AuthService _auth = new AuthService();
                                    _auth.signOut();
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.orange),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0))),
                                  ),
                                  child: Text(
                                    'Aceptar',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0),
                                  ),
                                ),
                              ),
                            ),
                          )
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
