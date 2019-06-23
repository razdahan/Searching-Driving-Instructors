import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:main/main.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'dart:async';

class AddReview extends StatefulWidget {
  @override
  _AddReviewState createState() => _AddReviewState();

  const AddReview({Key key, this.user, this.instructor, this.userData})
      : super(key: key);
  final FirebaseUser user;
  final DrivingInstructor instructor;
  final User userData;
}

class _AddReviewState extends State<AddReview> {
  String _text;

  bool instructorNameValidator;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  double rating = 0;

  @override
  Widget build(BuildContext context) {
    return new Theme(
        data: ThemeData(
          fontFamily: 'cour',
          hintColor: Colors.white,
          primaryColor: Colors.white,
          primaryColorDark: Colors.white,
        ),
        child: Scaffold(
            resizeToAvoidBottomPadding: false,
            appBar: AppBar(
              elevation: 10.0,
              title:
                  Text('הוספת ביקורת', style: TextStyle(color: Colors.black)),
              backgroundColor: Colors.white,
              centerTitle: true,
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
            ),
            body: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  colors: [HexColor("#1895C2"), HexColor("#51C5EF")],
                  begin: FractionalOffset.bottomCenter,
                  end: FractionalOffset.topCenter,
                )),
                child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SmoothStarRating(
                                  allowHalfRating: true,
                                  onRatingChanged: (v) {
                                    rating = v;
                                    setState(() {});
                                  },
                                  starCount: 5,
                                  rating: rating,
                                  size: 40.0,
                                  color: Colors.white,
                                  borderColor: Colors.white,
                                  spacing: 0.0)
                            ]),
                        Directionality(
                            textDirection: TextDirection.rtl,
                            child: Padding(
                                padding: EdgeInsets.only(
                                  left: 30,
                                  right: 30,
                                ),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: "ביקורת בכמה מילים",
                                    labelStyle: TextStyle(color: Colors.white),
                                    fillColor: Colors.white,
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                    ),
                                  ),
                                  validator: (input) {
                                    if (input.isEmpty) {
                                      return ' חסרה ביקורת קצרה';
                                    }
                                  },
                                  onSaved: (input) => _text = input,
                                ))),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 100.0, right: 100.0, top: 70.0),
                                  child: Card(
                                    elevation: 15,
                                    child: GestureDetector(
                                      onTap: () async {
                                        showDialog(
                                            context: context,
                                            builder: (_) => AlertDialog(
                                                  title: Text("התראה"),
                                                  content: Text(
                                                      "הביקרות שלך תיתווסף בפעם הבאה שתטען את הדף"),
                                                  actions: <Widget>[
                                                    // usually buttons at the bottom of the dialog
                                                    FlatButton(
                                                      child: Text("אוקיי"),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        addReview(context);
                                                      },
                                                    ),
                                                  ],
                                                ));
                                      },
                                      child: Container(
                                          alignment: Alignment.center,
                                          height: 40.0,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(9.0),
                                          ),
                                          child: Text("הוסף ביקורת",
                                              style: TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.black,
                                                  fontWeight:
                                                      FontWeight.w700))),
                                    ),
                                  )),
                            )
                          ],
                        ),
                      ],
                    )))));
  }

  Future<void> addReview(BuildContext context) async {
    final _formState = _formKey.currentState;
    if (_formState.validate()) {
      _formState.save();

      String username = "";
      String uid = "";

      if (widget.user != null) {
        username = widget.userData.name;
        uid = widget.user.uid;
      } else {
        username = "אנונימי";
        uid = "anonymos";
      }
      Firestore.instance.runTransaction((transaction) async {
        Review u = new Review(
            instructorName: widget.instructor.name,
            authorName: username,
            rating: rating,
            text: _text,
            userId: uid);
        await transaction.set(
            Firestore.instance.collection("Reviews").document(), u.toJson());
      });

      Navigator.pop(context);
    }
  }
}
