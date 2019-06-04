import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:main/Pages/Home.dart';
import 'package:main/Pages/Reviews/InstructorProfile.dart';
import 'package:main/main.dart';


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
  String _InstructorName, _AuthorName, _Text;
  bool InstructorNameValidator;
  bool ReviewValidator;
  String ReviewKey;
  int _Rating;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<TextEditingController> Controllers = new List<TextEditingController>();

  @override
  Widget build(BuildContext context) {
    ReviewKey=widget.review.reviewKey;
    Controllers.add(new TextEditingController());
    Controllers.add(new TextEditingController());
    Controllers.add(new TextEditingController());
    Controllers.add(new TextEditingController());
    _InstructorName = widget.review.InstructorName;
    _AuthorName = widget.review.AuthorName;
    _Text = widget.review.Text;
    _Rating = widget.review.Rating;

    Controllers[0].text = _InstructorName;
    Controllers[1].text = _Rating.toString();
    Controllers[2].text = _Text;
    Controllers[3].text = _AuthorName;
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
                  controller: Controllers[3],
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'שם הכותב';
                    }

                  },
                  onSaved: (input) => _AuthorName = input,
                  decoration: InputDecoration(labelText: 'שם הכותב'),
                ),
                TextFormField(
                  style: new TextStyle(fontWeight:FontWeight.w700),
                  controller: Controllers[0],
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'שם המורה חסר';
                    }
                    if (InstructorNameValidator == false)
                      return "לא קיים כזה מורה כפרה";
                  },
                  onSaved: (input) => _InstructorName = input,
                  decoration: InputDecoration(labelText: 'שם המורה'),
                ),
                TextFormField(
                  style: new TextStyle(fontWeight:FontWeight.w700),
                  controller: Controllers[1],
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'דירוג חסר';
                    }
                  },
                  onSaved: (input) => _Rating = int.parse(input),
                  decoration: InputDecoration(labelText: 'דירוג'),
                ),
                TextFormField(
                  style: new TextStyle(fontWeight:FontWeight.w700),
                  controller: Controllers[2],
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'חסרה חוות דעת על המורה';
                    }
                  },
                  onSaved: (input) => _Text = input,
                  decoration: InputDecoration(
                      labelText: 'חוות דעת על המורה בכמה מילים'),
                ),
                RaisedButton(
                  onPressed: () async {
                    final _formState = _formKey.currentState;
                    _formState.save();
                    var response = await doesInstructorExist(_InstructorName);

                    setState(() {
                      this.InstructorNameValidator = response;
                    });

                    if (_formKey.currentState.validate()) {
                      SaveReview(context);
                    }
                  },
                  child: Text('עדכן'),
                ),
                RaisedButton(
                  onPressed: () async {

                      DeleteReview(context);

                  },
                  child: Text('מחק'),
                )
              ],
            ))))));
  }

  Future<void> DeleteReview(BuildContext context) async {
    await Firestore.instance
        .collection('Reviews')
        .document(ReviewKey)
        .delete();
    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => InstructorProfile(
      user:widget.user,
      userData: widget.userData,
      Instructor: widget.instructor,


    )));
  }

  Future<void> SaveReview(BuildContext context) async {

    final _formState = _formKey.currentState;
    if (_formState.validate()) {
      _formState.save();
        Firestore.instance.collection('Reviews').document(ReviewKey).updateData({ 'AuthorName':_AuthorName, 'InstructorName': _InstructorName,'rating':_Rating,'text':_Text });
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => InstructorProfile(
          user:widget.user,
        userData: widget.userData,
        Instructor: widget.instructor,


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
