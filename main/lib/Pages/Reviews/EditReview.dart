import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:main/Pages/Reviews/InstructorProfile.dart';
import 'package:main/main.dart';
import 'dart:async';

class EditReview extends StatefulWidget {
  @override
  _EditReviewState createState() => _EditReviewState();

  const EditReview({Key key, this.user, this.userData,this.review,this.instructor}) : super(key: key);
  final FirebaseUser user;
  final User userData;
  final Review review;
  final DrivingInstructor instructor;
}

class _EditReviewState extends State<EditReview> {
  String _instructorName, _authorName, _text;
  bool instructorNameValidator;
  bool reviewValidator;
  String reviewKey;
  double _rating;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<TextEditingController> controllers = new List<TextEditingController>();

  @override
  Widget build(BuildContext context) {
    reviewKey=widget.review.reviewKey;
    controllers.add(new TextEditingController());
    controllers.add(new TextEditingController());
    controllers.add(new TextEditingController());
    controllers.add(new TextEditingController());
    _instructorName = widget.review.instructorName;
    _authorName = widget.review.authorName;
    _text = widget.review.text;
    _rating = widget.review.rating;

    controllers[0].text = _instructorName;
    controllers[1].text = _rating.toString();
    controllers[2].text = _text;
    controllers[3].text = _authorName;
    return new Theme(

        data: new ThemeData(

          fontFamily: 'cour',
          hintColor: Colors.white,
          primaryColor: Colors.white,
          primaryColorDark: Colors.white,
        ),
    child:Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text(' ערוך ביקורת ', style: new TextStyle(color: Colors.white)),
          backgroundColor: HexColor("#51C5EF"),
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
        body:Container(
    decoration: new BoxDecoration(
    gradient: new LinearGradient(
    colors: [HexColor("#1895C2"), HexColor("#51C5EF")],
    begin: FractionalOffset.bottomCenter,
    end: FractionalOffset.topCenter,
    )),
    child:
    Directionality(
      textDirection: TextDirection.rtl,

    child:Form(
            key: _formKey,
            child: Column(
              children: <Widget>[

                TextFormField(
                  style: new TextStyle(fontWeight:FontWeight.w700),
                  controller: controllers[3],
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'שם הכותב';
                    }

                  },
                  onSaved: (input) => _authorName = input,
                  decoration: InputDecoration(labelText: 'שם הכותב'),
                ),
                TextFormField(
                  style: new TextStyle(fontWeight:FontWeight.w700),
                  controller: controllers[0],
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'שם המורה חסר';
                    }
                    if (instructorNameValidator == false)
                      return "לא קיים כזה מורה כפרה";
                  },
                  onSaved: (input) => _instructorName = input,
                  decoration: InputDecoration(labelText: 'שם המורה'),
                ),
                TextFormField(
                  style: new TextStyle(fontWeight:FontWeight.w700),
                  controller: controllers[1],
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'דירוג חסר';
                    }
                  },
                  onSaved: (input) => _rating = double.parse(input),
                  decoration: InputDecoration(labelText: 'דירוג'),
                ),
                TextFormField(
                  style: new TextStyle(fontWeight:FontWeight.w700),
                  controller: controllers[2],
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'חסרה חוות דעת על המורה';
                    }
                  },
                  onSaved: (input) => _text = input,
                  decoration: InputDecoration(
                      labelText: 'חוות דעת על המורה בכמה מילים'),
                ),
                RaisedButton(
                  onPressed: () async {
                    final _formState = _formKey.currentState;
                    _formState.save();
                    var response = await doesInstructorExist(_instructorName);

                    setState(() {
                      this.instructorNameValidator = response;
                    });

                    if (_formKey.currentState.validate()) {
                      saveReview(context);
                    }
                  },
                  child: Text('עדכן'),
                ),
                RaisedButton(
                  onPressed: () async {

                      deleteReview(context);

                  },
                  child: Text('מחק'),
                )
              ],
            ))))));
  }

  Future<void> deleteReview(BuildContext context) async {
    await Firestore.instance
        .collection('Reviews')
        .document(reviewKey)
        .delete();
    Navigator.of(
        context).pop();
    Navigator.pop(
        context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => InstructorProfile(
      user:widget.user,
      userData: widget.userData,
      instructor: widget.instructor,


    )));
  }

  Future<void> saveReview(BuildContext context) async {

    final _formState = _formKey.currentState;
    if (_formState.validate()) {
      _formState.save();
        Firestore.instance.collection('Reviews').document(reviewKey).updateData({ 'authorName':_authorName, 'instructorName': _instructorName,'rating':_rating,'text':_text });
      Navigator.of(
          context).pop();
      Navigator.pop(
          context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => InstructorProfile(
          user:widget.user,
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
