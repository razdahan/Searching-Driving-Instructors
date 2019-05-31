import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:main/Pages/Home.dart';
import 'package:main/Pages/Setup/SignIn.dart';
import 'package:main/Pages/Setup/Welcome.dart';
import "package:autocomplete_textfield/autocomplete_textfield.dart";
class ViewReview extends StatefulWidget {
  @override
  _ViewReviewState createState() => _ViewReviewState();

  const ViewReview({Key key, this.user}) : super(key: key);
  final FirebaseUser user;
}

class Review {
  const Review(
      {@required this.InstructorName,
        @required this.AuthornName,
        @required this.Text,
        @required this.Rating});

  final String InstructorName;
  final String AuthornName;
  final String Text;
  final int Rating;

  Map<String, dynamic> toJson() => {
    'InstructorName': InstructorName,
    'AuthornName': AuthornName,
    'text': Text,
    'rating': Rating
  };
}

class _ViewReviewState extends State<ViewReview> {
  String _InstructorName, _AuthornName, _Text;
  bool InstructorNameValidator;
  int _Rating;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('הוספת ביקורת'),
        ),
        body: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'שם המורה חסר';
                    }
                    if(InstructorNameValidator==false)
                      return "לא קיים כזה מורה כפרה";
                  },
                  onSaved: (input) => _InstructorName = input,
                  decoration: InputDecoration(labelText: 'שם המורה'),
                ),
                TextFormField(
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'דירוג חסר';
                    }
                  },
                  onSaved: (input) => _Rating = int.parse(input),
                  decoration: InputDecoration(labelText: 'דירוג'),
                ),
                TextFormField(
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
                      AddReview();
                    }
                  },
                  child: Text('הוספה'),
                )
              ],
            )));
  }

  Future<void> AddReview() async {
    final _formState = _formKey.currentState;
    if (_formState.validate()) {
      _formState.save();
      try {
        Firestore.instance.runTransaction((transaction) async {
          Review u = new Review(
              InstructorName: _InstructorName,
              AuthornName: 'anonymous',
              Rating: _Rating,
              Text: _Text);
          await transaction.set(
              Firestore.instance.collection("Reviews").document(),
              u.toJson());
        });

        //TODO Change email
        Navigator.of(context).pop();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Welcome()));
      } catch (e) {
        print(e.message);
      }
    }
  }

  Future<bool> doesInstructorExist(String name) async {
    print(name);
    final QuerySnapshot result = await Firestore.instance
        .collection('DrivingInstructors')
        .where('name', isEqualTo: name).limit(1).getDocuments();

    final List<DocumentSnapshot> documents = result.documents;
    print( documents[0].data['name']);
    return documents.length==1;

  }
}
