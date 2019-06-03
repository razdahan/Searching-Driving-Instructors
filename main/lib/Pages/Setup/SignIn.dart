import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:main/Pages/Home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => new _LoginPageState();

}

class _LoginPageState extends State<LoginPage> {
  String _email, _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('התחברות', style: new TextStyle(color: Colors.black)),
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
                                labelText: "סיסמא",
                                labelStyle: new TextStyle(color: Colors.black),
                                fillColor: Colors.white,
                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(9.0),
                                  borderSide: new BorderSide(width: 1,),
                                ),
                              ),
                              validator: (input) {
                                if (input.isEmpty) {
                                  return 'הסיסמא שלך חסרה';
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
                              onTap: signIn,
                              child: new Container(
                                  alignment: Alignment.center,
                                  height: 40.0,
                                  decoration: new BoxDecoration(
                                    borderRadius:
                                    new BorderRadius.circular(9.0),
                                    border: Border.all(width: 1),
                                  ),
                                  child: new Text("התחברות",
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

  Future<void> signIn() async {
    final _formState = _formKey.currentState;
    if (_formState.validate()) {
      _formState.save();
      try {
        FirebaseUser user = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home(user: user)));
      } catch (e) {
        print(e.message);
      }
    }
  }
}
