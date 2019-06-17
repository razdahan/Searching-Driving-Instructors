import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:main/main.dart';
import 'dart:async';
import "package:autocomplete_textfield/autocomplete_textfield.dart";

class AddInstructor extends StatefulWidget {
  @override
  _AddInstructorState createState() => _AddInstructorState();

  const AddInstructor({Key key, this.user, this.userData}) : super(key: key);
  final FirebaseUser user;
  final User userData;
}

class _AddInstructorState extends State<AddInstructor> {
  String _name, _testArea, _phoneNumber, _price;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutoCompleteTextField search;
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();

  Widget row(String d) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
            decoration: new BoxDecoration(
                border: new Border.all(color: Colors.grey, width: 1)),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    d,
                    style: TextStyle(fontFamily: 'cour'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 0.0, top: 30.0),
                  ),
                ])));
  }

  @override
  Widget build(BuildContext context) {
    var arr = [
      "עכו",
      "אופקים",
      "אילת",
      "באר-שבע",
      "דימונה",
      "מצפה רמון",
      "נתיבות",
      "ערד",
      "קרית גת",
      "רהט",
      "שדרות",
      "בית שאן",
      "חדרה",
      "חיפה",
      "טבריה",
      "יוקנעם",
      "כרמיאל",
      "מעלות",
      "נהריה",
      "נצרת עילית",
      "נתניה",
      "עפולה",
      "צפת",
      "קרית אליעזר",
      "קרית שמונה",
      "שפרעם",
      "אשדוד",
      "אשקלון",
      "בית שמש",
      "ירושלים",
      "מודיעין",
      "קרית מלאכי",
      "אריאל",
      "הרצליה",
      "חולון",
      "יבנה",
      "כפר סבא",
      "לוד",
      "פתח-תקוה",
      "ראשון לציון",
      "רחובות",
      "רמלה",
      "תל אביב"
    ];

    return new Theme(
        data: new ThemeData(
          fontFamily: 'cour',
          hintColor: Colors.white,
          primaryColor: Colors.white,
          primaryColorDark: Colors.white,
        ),
        child: Scaffold(
            appBar: AppBar(
              title: Text('הוספת מורה נהיגה',
                  style: new TextStyle(fontSize: 20, color: Colors.black)),
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
                        Directionality(
                            textDirection: TextDirection.rtl,
                            child: Padding(
                                padding: EdgeInsets.only(
                                    left: 30, right: 30, top: 25.0),
                                child: search = AutoCompleteTextField<String>(
                                  onFocusChanged: (hasFocus) {},
                                  clearOnSubmit: false,
                                  key: key,
                                  suggestions: arr,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "איזור טסטים",
                                    hintStyle: TextStyle(color: Colors.white),
                                  ),
                                  itemFilter: (item, query) {
                                    return item.startsWith(query);
                                  },
                                  itemSorter: (a, b) {
                                    return a.compareTo(b);
                                  },
                                  itemSubmitted: (item) {
                                    if (!mounted) return;
                                    setState(() {
                                      search.textField.controller.text = item;
                                    });
                                  },
                                  itemBuilder: (context, item) {
                                    return row(item);
                                  },
                                ))),
                        Directionality(
                            textDirection: TextDirection.rtl,
                            child: Padding(
                                padding: EdgeInsets.only(
                                    left: 30, right: 30, top: 25.0),
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
                                      return 'שם חסר';
                                    }
                                  },
                                  onSaved: (input) => _name = input,
                                ))),

                        Directionality(
                            textDirection: TextDirection.rtl,
                            child: Padding(
                                padding: EdgeInsets.only(
                                    left: 30, right: 30, top: 25.0),
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
                                      return 'הטלפון של המורה חסר';
                                    }
                                  },
                                  onSaved: (input) => _phoneNumber = input,
                                ))),
                        Directionality(
                            textDirection: TextDirection.rtl,
                            child: Padding(
                                padding: EdgeInsets.only(
                                    left: 30, right: 30, top: 25.0),
                                child: TextFormField(
                                  decoration: new InputDecoration(
                                    labelText: "מחיר",
                                    labelStyle:
                                        new TextStyle(color: Colors.white),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                    ),
                                  ),
                                  validator: (input) {
                                    if (input.isEmpty) {
                                      return 'המחיר לשיעור חסר';
                                    }
                                  },
                                  onSaved: (input) => _price = input,
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
                                      onTap: () {
                                        print(widget.userData.role);
                                        if (widget.userData.role != "admin" &&
                                            _formKey.currentState.validate()) {
                                          _formKey.currentState.save();
                                          showDialog(
                                              context: context,
                                              builder: (_) => new AlertDialog(
                                                    title: Text('התראה'),
                                                    content: Directionality(
                                                        textDirection:
                                                            TextDirection.rtl,
                                                        child: Text(
                                                            'הבקשה שלך להוספת המורה תשלח אל השרת ורק לאחר אישור תיתווסף לאפליקציה')),
                                                    actions: <Widget>[
                                                      FlatButton(
                                                        child:
                                                            const Text('ביטול'),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                      FlatButton(
                                                        child:
                                                            const Text('אישור'),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                          addDrivingInstructor();
                                                        },
                                                      )
                                                    ],
                                                  ));
                                        } else {
                                          addDrivingInstructor();
                                        }
                                      },
                                      child: new Container(
                                          alignment: Alignment.center,
                                          height: 40.0,
                                          decoration: new BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                new BorderRadius.circular(9.0),
                                          ),
                                          child: new Text("הוסף",
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

  Future<void> addDrivingInstructor() async {
    print("asdasdasdasfdsafsadfdsfd");
    final _formState = _formKey.currentState;
    if (_formState.validate()) {
      _formState.save();

      String role = widget.userData.role;

      if (role.toLowerCase() == "admin") {
        Firestore.instance.runTransaction((transaction) async {
          DrivingInstructor u = new DrivingInstructor(
              phoneNumber: _phoneNumber,
              name: _name,
              price: _price,
              testArea: _testArea);
          await transaction.set(
              Firestore.instance.collection("DrivingInstructors").document(),
              u.toJson());
        });

        Navigator.pop(context);
      } else {
        Firestore.instance.runTransaction((transaction) async {
          DrivingInstructor u = new DrivingInstructor(
              phoneNumber: _phoneNumber,
              name: _name,
              price: _price,
              testArea: _testArea);
          await transaction.set(
              Firestore.instance
                  .collection("DrivingInstructorsTemp")
                  .document(),
              u.toJson());
        });

        Navigator.pop(context);
      }
    }
  }
}
