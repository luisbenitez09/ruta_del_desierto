import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ruta_del_desierto/Modelos/MyUser.dart';
import 'package:imei_plugin/imei_plugin.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference collectionReference = FirebaseFirestore.instance.collection("tablets-imei");

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

    String imei = await ImeiPlugin.getImei();
    print(imei);
    QuerySnapshot imeiList = await collectionReference.get();
    if(action == "Inicio") { //Looking for the first login
      if (imeiList.docs.length != 0) {
        for(var doc in imeiList.docs) {
          print("DOC ID:");
          print(doc.id);
          if (doc.id == imei) { //Checking if the imei is registered
            print("I find an imei!!");
            try {
              UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
              User user = result.user;
              return _userFromFirebase(user);
            } catch (e) {
              //print(e.toString());
              return null;
            }
          } else { //Imei not registered
            print("IMEI DOES NOT EXIST");
            return null;
          }
        }
      }
    }
  }

  //Sign out
  Future signOut() async {
    try {
      /*var data = {
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
          body: jsonEncode(data));*/

      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}