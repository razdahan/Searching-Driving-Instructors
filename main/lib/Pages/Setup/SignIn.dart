import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:main/Pages/Home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:main/main.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email, _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return new Theme(
        data: new ThemeData(
        fontFamily: 'cour',
        hintColor: Colors.white,
        primaryColor: Colors.white,
        primaryColorDark: Colors.white,
    ),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text('התחברות', style: new TextStyle(color: Colors.white)),
          backgroundColor: HexColor("#51C5EF"),
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
        ),
        body: Container(
            decoration: new BoxDecoration(
                gradient: new LinearGradient(
              colors: [HexColor("#1895C2"), HexColor("#51C5EF")],
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
                                padding: EdgeInsets.only(left:30,right:30,top: 25.0),
                                child: TextFormField(
                                  decoration: new InputDecoration(
                                    labelText: "כתובת האימייל",
                                    labelStyle:
                                        new TextStyle(color: Colors.white),
                                    fillColor: Colors.white,
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
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
                                padding: EdgeInsets.only(left:30,right:30,top: 25.0),
                                child: TextFormField(
                                  decoration: new InputDecoration(
                                    labelText: "סיסמא",
                                    labelStyle:
                                        new TextStyle(color: Colors.white),
                                    fillColor: Colors.white,
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
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
                                    left: 100.0, right: 100.0, top: 100.0),
                                child:Card(
                                  elevation: 15,
                                child: GestureDetector(
                                  onTap: signIn,
                                  child: new Container(
                                      alignment: Alignment.center,
                                      height: 40.0,
                                      decoration: new BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            new BorderRadius.circular(9.0),

                                      ),
                                      child: new Text("התחברות",
                                          style: new TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.black))),
                                ),
                              )),
                            )
                          ],
                        ),
                      ],
                    )))));
  }

  Future<void> signIn() async {
    final _formState = _formKey.currentState;
    if (_formState.validate()) {
      _formState.save();
      try {
        FirebaseUser user = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);
        final DocumentSnapshot result = await Firestore.instance
            .collection('users')
            .document(user.uid)
            .get();
        String name = result.data['name'];
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Home(user: user, name: name)));
      } catch (e) {
        print(e.message);
      }
    }
  }
}
