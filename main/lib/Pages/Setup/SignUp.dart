import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:main/Pages/Setup/SignIn.dart';
import 'package:main/main.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String _email, _password, _name, _age, _phone_number;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('הרשמה', style: new TextStyle(color: Colors.black)),
          backgroundColor: Colors.lightBlue,
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
        ),
        body: Container(
            decoration: new BoxDecoration(
                gradient: new LinearGradient(
              colors: [Colors.white, Colors.lightBlue],
              begin: FractionalOffset.bottomCenter,
              end: FractionalOffset.topCenter,
            )),
            child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Directionality(
                        textDirection: TextDirection.rtl,
                        child: Padding(
                            padding: EdgeInsets.only(top: 25.0),
                            child: TextFormField(
                              decoration: new InputDecoration(
                                labelText: "כתובת האימייל",
                                labelStyle: new TextStyle(color: Colors.black),
                                fillColor: Colors.white,
                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(9.0),
                                  borderSide: new BorderSide(
                                      color: Colors.white, width: 1),
                                ),
                              ),
                              validator: (input) {
                                if (input.isEmpty) {
                                  return 'כתובת האימייל שלך חסרה';
                                }
                              },
                              onSaved: (input) => _email = input,
                            ))),
                    Directionality(
                        textDirection: TextDirection.rtl,
                        child: Padding(
                            padding: EdgeInsets.only(top: 25.0),
                            child: TextFormField(
                              decoration: new InputDecoration(
                                labelText: "שם",
                                labelStyle: new TextStyle(color: Colors.black),
                                fillColor: Colors.white,
                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(9.0),
                                  borderSide: new BorderSide(width: 1),
                                ),
                              ),
                              validator: (input) {
                                if (input.isEmpty) {
                                  return 'השם שלך חסר';
                                }
                              },
                              onSaved: (input) => _name = input,
                            ))),
                    Directionality(
                        textDirection: TextDirection.rtl,
                        child: Padding(
                            padding: EdgeInsets.only(top: 25.0),
                            child: TextFormField(
                              decoration: new InputDecoration(
                                labelText: "גיל",
                                labelStyle: new TextStyle(color: Colors.black),
                                fillColor: Colors.white,
                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(9.0),
                                  borderSide: new BorderSide(width: 1),
                                ),
                              ),
                              validator: (input) {
                                if (input.isEmpty) {
                                  return 'הגיל שלך חסר';
                                }
                              },
                              onSaved: (input) => _age = input,
                            ))),
                    Directionality(
                        textDirection: TextDirection.rtl,
                        child: Padding(
                            padding: EdgeInsets.only(top: 25.0),
                            child: TextFormField(
                              decoration: new InputDecoration(
                                labelText: "מספר טלפון",
                                labelStyle: new TextStyle(color: Colors.black),
                                fillColor: Colors.white,
                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(9.0),
                                  borderSide: new BorderSide(width: 1),
                                ),
                              ),
                              validator: (input) {
                                if (input.isEmpty) {
                                  return 'הטלפון שלך חסר';
                                }
                              },
                              onSaved: (input) => _phone_number = input,
                            ))),
                    Directionality(
                        textDirection: TextDirection.rtl,
                        child: Padding(
                            padding: EdgeInsets.only(top: 25.0),
                            child: TextFormField(
                              decoration: new InputDecoration(
                                labelText: "סיסמא",
                                labelStyle: new TextStyle(color: Colors.black),
                                fillColor: Colors.white,
                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(9.0),
                                  borderSide: new BorderSide(width: 1),
                                ),
                              ),
                              validator: (input) {
                                if (input.isEmpty) {
                                  return 'הסיסמא שלך חסרה';
                                }
                                if (input.length < 6) {
                                  return 'אורך הסיסמא חייב להיות גדול יותר משישה תווים';
                                }
                              },
                              onSaved: (input) => _password = input,
                              obscureText: true,
                            ))),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 100.0, right: 100.0, top: 50.0),
                            child: GestureDetector(
                              onTap: signUp,
                              child: new Container(
                                  alignment: Alignment.center,
                                  height: 40.0,
                                  decoration: new BoxDecoration(
                                    borderRadius:
                                        new BorderRadius.circular(9.0),
                                    border: Border.all(width: 1),
                                  ),
                                  child: new Text("הרשמה",
                                      style: new TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.black))),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ))));
  }

  Future<void> signUp() async {
    final _formState = _formKey.currentState;
    if (_formState.validate()) {
      _formState.save();
      try {
        FirebaseUser user = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: _email, password: _password);
        Firestore.instance.runTransaction((transaction) async {
          User u = new User(
              phone_number: _phone_number,
              age: _age,
              name: _name,
              role: 'member');
          await transaction.set(
              Firestore.instance.collection("users").document(user.uid),
              u.toJson());
        });
        Navigator.of(context).pop();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      } catch (e) {
        print(e.message);
      }
    }
  }
}
