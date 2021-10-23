import 'package:boletos_abordo/Controladores/auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String pass = '';
  String error = '';

  final passInput = TextEditingController();
  clearInput() {
    passInput.clear();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/login_img.png'),
                    fit: BoxFit.cover),
              ),
            ),
            Row(
              children: <Widget>[
                Container(
                  width: w / 2,
                ),
                Container(
                  width: (w / 2) - 30.0,
                  height: (h - 40.0),
                  margin: EdgeInsets.fromLTRB(0.0, 25.0, 10.0, 10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.circular(35.0),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 50.0),
                          child: Text(
                            'Inicia sesión',
                            style: TextStyle(
                                color: Colors.grey[800],
                                fontWeight: FontWeight.bold,
                                fontSize: 45.0,
                                fontFamily: 'Gilroy'),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 40.0),
                          child: Text(
                            error,
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontFamily: 'Gilroy',
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Container(
                                margin:
                                    EdgeInsets.fromLTRB(50.0, 80.0, 50.0, 0.0),
                                child: TextFormField(
                                  validator: (val) =>
                                      val.isEmpty ? 'Ingresa tu email' : null,
                                  onChanged: (val) {
                                    setState(() => email = val);
                                  },
                                  style: TextStyle(
                                      fontFamily: 'Gilroy',
                                      fontWeight: FontWeight.normal,
                                      fontSize: 20.0),
                                  decoration: InputDecoration(
                                    hintText: 'Email',
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(30.0),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin:
                                    EdgeInsets.fromLTRB(50.0, 30.0, 50.0, 0.0),
                                child: TextFormField(
                                  controller: passInput,
                                  validator: (val) => val.length < 6
                                      ? 'Verifica tu contraseña'
                                      : null,
                                  onChanged: (val) {
                                    setState(() => pass = val);
                                  },
                                  style: TextStyle(
                                      fontFamily: 'Gilroy',
                                      fontWeight: FontWeight.normal,
                                      fontSize: 20.0),
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    hintText: 'Contraseña',
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(30.0),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                          child: ButtonTheme(
                            height: 45.0,
                            minWidth: 180.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(35.0),
                            ),
                            child: ElevatedButton(
                              onPressed: () async {
                                setState(() => error = "");
                                if (_formKey.currentState.validate()) {
                                  dynamic result =
                                      await _auth.sigIn(email, pass, 'Inicio');
                                  if (result == null) {
                                    if (this.mounted) {
                                      setState(() {
                                        error =
                                            "Ingresa correctamente tus datos";
                                        passInput.clear();
                                      });
                                    }
                                  }
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.orange),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0))),
                              ),
                              child: Text(
                                'Iniciar Sesión',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        ));
  }
}
