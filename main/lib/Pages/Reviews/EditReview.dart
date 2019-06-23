import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:main/Pages/User/Profile.dart';
import 'package:main/Pages/Instructor/Profile.dart';
import 'package:main/main.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'dart:async';

class EditReview extends StatefulWidget {
  @override
  _EditReviewState createState() => _EditReviewState();

  const EditReview(
      {Key key,
      this.user,
      this.userData,
      this.review,
      this.instructor,
      this.fromProfile})
      : super(key: key);
  final FirebaseUser user;
  final User userData;
  final Review review;
  final bool fromProfile;
  final DrivingInstructor instructor;
}

class _EditReviewState extends State<EditReview> {
  Widget startEdit() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      SmoothStarRating(
          allowHalfRating: true,
          onRatingChanged: (v) {
            setState(() {
              rating = v;
            });
          },
          starCount: 5,
          rating: rating,
          size: 40.0,
          color: Colors.white,
          borderColor: Colors.white,
          spacing: 0.0)
    ]);
  }

  String _instructorName, _authorName, _text;
  bool instructorNameValidator;
  bool reviewValidator;
  String reviewKey;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<TextEditingController> controllers = new List<TextEditingController>();
  double rating = 0;
  void initState() {
    super.initState();
    rating = widget.review.rating;
  }

  @override
  Widget build(BuildContext context) {
    reviewKey = widget.review.reviewKey;

    _instructorName = widget.review.instructorName;
    _authorName = widget.review.authorName;
    _text = widget.review.text;
    return new Theme(
        data: new ThemeData(
          fontFamily: 'cour',
          hintColor: Colors.white,
          primaryColor: Colors.white,
          primaryColorDark: Colors.white,
        ),
        child: Scaffold(
            appBar: AppBar(
              elevation: 10.0,
              title:
                  Text('עריכת ביקורת', style: TextStyle(color: Colors.black)),
              backgroundColor: Colors.white,
              centerTitle: true,
              iconTheme: IconThemeData(
                color: Colors.black,
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
                                  left: 30,
                                  right: 30,
                                ),
                                child: TextFormField(
                                  controller: TextEditingController()
                                    ..text = _authorName,
                                  style: new TextStyle(
                                      fontWeight: FontWeight.w700),
                                  validator: (input) {
                                    if (input.isEmpty) {
                                      return 'שם הכותב';
                                    }
                                  },
                                  onSaved: (input) => _authorName = input,
                                  decoration:
                                      InputDecoration(labelText: 'שם הכותב'),
                                ))),
                        Directionality(
                            textDirection: TextDirection.rtl,
                            child: Padding(
                                padding: EdgeInsets.only(
                                  left: 30,
                                  right: 30,
                                ),
                                child: TextFormField(
                                  style: new TextStyle(
                                      fontWeight: FontWeight.w700),
                                  controller: TextEditingController()
                                    ..text = _instructorName,
                                  enabled: false,
                                  onSaved: (input) => _instructorName = input,
                                  decoration:
                                      InputDecoration(labelText: 'שם המורה'),
                                ))),
                        startEdit(),
                        Directionality(
                            textDirection: TextDirection.rtl,
                            child: Padding(
                                padding: EdgeInsets.only(
                                  left: 30,
                                  right: 30,
                                ),
                                child: TextFormField(
                                  style: new TextStyle(
                                      fontWeight: FontWeight.w700),
                                  controller: TextEditingController()
                                    ..text = _text,
                                  validator: (input) {
                                    if (input.isEmpty) {
                                      return 'חסרה חוות דעת על המורה';
                                    }
                                  },
                                  onSaved: (input) => _text = input,
                                  decoration: InputDecoration(
                                      labelText:
                                          'חוות דעת על המורה בכמה מילים'),
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
                                        final _formState =
                                            _formKey.currentState;
                                        if (_formKey.currentState.validate()) {
                                          _formState.save();
                                          saveReview(context);
                                        }
                                      },
                                      child: Container(
                                          alignment: Alignment.center,
                                          height: 40.0,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(9.0),
                                          ),
                                          child: Text("עדכן ביקורת",
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 100.0,
                                    right: 100.0,
                                  ),
                                  child: Card(
                                    elevation: 15,
                                    child: GestureDetector(
                                      onTap: () async {
                                        deleteReview(context);
                                      },
                                      child: Container(
                                          alignment: Alignment.center,
                                          height: 40.0,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(9.0),
                                          ),
                                          child: Text("מחק",
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

  Future<void> deleteReview(BuildContext context) async {
    await Firestore.instance.collection('Reviews').document(reviewKey).delete();
    Navigator.of(context).pop();
    Navigator.pop(context);
    if (widget.fromProfile == true)
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Profile(
                    user: widget.user,
                    userData: widget.userData,
                  )));
    else
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => InstructorProfile(
                    user: widget.user,
                    userData: widget.userData,
                    instructor: widget.instructor,
                  )));
  }

  Future<void> saveReview(BuildContext context) async {
    final _formState = _formKey.currentState;
    if (_formState.validate()) {
      _formState.save();
      Firestore.instance.collection('Reviews').document(reviewKey).updateData({
        'authorName': _authorName,
        'instructorName': _instructorName,
        'rating': rating,
        'text': _text
      });
      Navigator.of(context).pop();
      Navigator.pop(context);
      if (widget.fromProfile == true)
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Profile(
                      user: widget.user,
                      userData: widget.userData,
                    )));
      else
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => InstructorProfile(
                      user: widget.user,
                      userData: widget.userData,
                      instructor: widget.instructor,
                    )));
    }
  }

  Future<bool> doesInstructorExist(String name) async {
    print(name);
    final QuerySnapshot result = await Firestore.instance
        .collection('DrivingInstructors')
        .where('name', isEqualTo: name)
        .limit(1)
        .getDocuments();

    final List<DocumentSnapshot> documents = result.documents;
    print(documents[0].data['name']);
    return documents.length == 1;
  }
}
