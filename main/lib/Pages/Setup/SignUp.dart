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
              title: Text('הרשמה', style: new TextStyle(fontSize:25,color: Colors.white)),
              backgroundColor: HexColor("#51C5EF"),
              centerTitle: true,
              elevation: 0,
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
                    child: ListView(
                      children: <Widget>[
                        Directionality(
                            textDirection: TextDirection.rtl,
                            child: Padding(
                                padding: EdgeInsets.only(left:30,right:30,top: 5.0),
                                child: TextFormField(
                                  decoration: new InputDecoration(
                                    labelText: "כתובת האימייל",
                                    labelStyle:
                                        new TextStyle(color: Colors.white),
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
                                    labelText: "שם",
                                    labelStyle:
                                        new TextStyle(color: Colors.white),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
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
                                padding: EdgeInsets.only(left:30,right:30,top: 25.0),
                                child: TextFormField(
                                  decoration: new InputDecoration(
                                    labelText: "גיל",
                                    labelStyle:
                                        new TextStyle(color: Colors.white),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
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
                                padding: EdgeInsets.only(left:30,right:30,top: 25.0),
                                child: TextFormField(
                                  decoration: new InputDecoration(
                                    labelText: "מספר טלפון",
                                    labelStyle:
                                        new TextStyle(color: Colors.white),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
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
                                padding: const EdgeInsets.only(left:30,right:30,top: 25.0),
                                child: TextFormField(
                                  decoration: new InputDecoration(
                                    labelText: "סיסמא",
                                    labelStyle:
                                        new TextStyle(color: Colors.white),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
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
                                      left: 100.0, right: 100.0, top: 30.0),
                                  child: Card(
                                    elevation: 15,
                                    child: GestureDetector(
                                      onTap: signUp,
                                      child: new Container(
                                          alignment: Alignment.center,
                                          height: 40.0,
                                          decoration: new BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                new BorderRadius.circular(9.0),
                                          ),
                                          child: new Text("הרשמה",
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
              role: 'member',
              email: _email);
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
