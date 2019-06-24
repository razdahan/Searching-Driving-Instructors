import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:main/Pages/Home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:main/main.dart';
import 'dart:async';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email, _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool loading = false;
  void initState() {
    super.initState();
    loading = false;
  }

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
            resizeToAvoidBottomPadding: false,
            appBar: AppBar(
              title: Text('התחברות', style: new TextStyle(color: Colors.black)),
              backgroundColor: Colors.white,
              elevation: 10,
              centerTitle: true,
              iconTheme: IconThemeData(
                color: Colors.black, //change your color here
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
                    child: ListView(
                      children: <Widget>[
                        loading ? new LinearProgressIndicator() : new Row(),
                        Directionality(
                            textDirection: TextDirection.rtl,
                            child: Padding(
                                padding: EdgeInsets.only(
                                    left: 30, right: 30, top: 25.0),
                                child: TextFormField(
                                  keyboardType: TextInputType.emailAddress,
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
                                    return validateEmail(input);
                                  },
                                  onSaved: (input) => _email = input,
                                ))),
                        Directionality(
                            textDirection: TextDirection.rtl,
                            child: Padding(
                                padding: EdgeInsets.only(
                                    left: 30, right: 30, top: 25.0),
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
                                    if (input.length < 8) {
                                      return 'הסיסמא שלך חייבת להיות יותר מ8 תווים';
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
                                      left: 100.0, right: 100.0, top: 70.0),
                                  child: Card(
                                    elevation: 15,
                                    child: GestureDetector(
                                      onTap: () {
                                        signIn();
                                        final _formState =
                                            _formKey.currentState;
                                        if (_formState.validate())
                                          setState(() {
                                            loading = true;
                                          });
                                      },
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

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'כתובת האימייל שלך לא תקינה';
    else
      return null;
  }

  Future<void> signIn() async {
    final _formState = _formKey.currentState;
    if (_formState.validate()) {
      _formState.save();

      FirebaseUser user;

      try {
        user = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _email.trim(), password: _password.trim());
      } catch (error) {
        setState(() {
          loading = false;
        });
        return showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  title: Directionality(
                    textDirection: TextDirection.rtl,
                    child: new Text("שגיאה"),
                  ),
                  content: new Text("פרטי המשתמש שהזנת שגויים"),
                  actions: <Widget>[
                    // usually buttons at the bottom of the dialog
                    new FlatButton(
                      child: new Text("אוקיי"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ));
      }

      if (user != null) {
        final DocumentSnapshot result = await Firestore.instance
            .collection('users')
            .document(user.uid)
            .get();
        setState(() {
          loading = false;
        });
        User u = new User(
            phoneNumber: result.data['phoneNumber'],
            age: result.data['age'],
            name: result.data['name'],
            role: result.data['role'],
            email: result.data['email'].trim());
        Navigator.pop(context);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Home(
                      user: user,
                      userData: u,
                    )));
      }
    }
  }
}
