import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:boletos_abordo/Modelos/MyUser.dart';
import 'package:http/http.dart' as http;
import 'package:imei_plugin/imei_plugin.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static const URL = 'http://187.141.142.89:5558/WsServicesApiRsd/ruta/session';
  static const URL2 =
      'http://187.141.142.89:5558/WsServicesApiRsd/ruta/endsession';
  static var uid = "";

  //create MyUser obj based on Firebase User
  MyUser _userFromFirebase(User user) {
    return user != null
        ? MyUser(uid: user.uid, name: user.displayName, email: user.email)
        : null;
  }

  //auth change user stream
  Stream<MyUser> get user {
    return _auth.authStateChanges().map(_userFromFirebase);
  }

  //Sign in with mail and pass
  Future sigIn(String email, String password, String action) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      uid = user.uid;

      if (action == 'Inicio') {
        String imei = await ImeiPlugin.getImei();
        print(imei);
        var data = {"param1": user.uid, "param2": password, "param3": imei};
        var response = await http.post(URL,
            headers: {
              "Authorization": "Basic ZWMwdXMzcjpqbnRoJDEzODMh",
              "Content-Type": "application/json"
            },
            body: jsonEncode(data));

        //print("-----------------------------------------------   Data Sign In new ----------------------------------------");
        var res = jsonDecode(response.body);
        print(res);

        if (res['success'] == false) {
          print(res);
          signOut();
        } else {
          return _userFromFirebase(user);
        }
      } else {
        return _userFromFirebase(user);
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //Sign out
  Future signOut() async {
    try {
      var data = {
        //TODO Future update, connect to firebase cloud function
        "param1": uid,
        "param2": "12345",
        "param3": "1234567890"
      };
      var response = await http.post(URL2,
          headers: {
            "Authorization": "Basic ZWMwdXMzcjpqbnRoJDEzODMh",
            "Content-Type": "application/json"
          },
          body: jsonEncode(data));

      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}