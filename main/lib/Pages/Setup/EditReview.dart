import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:main/Pages/Home.dart';
import 'package:main/main.dart';
import 'package:main/Pages/Setup/Welcome.dart';

class EditReview extends StatefulWidget {
  @override
  _EditReviewState createState() => _EditReviewState();

  const EditReview({Key key, this.user}) : super(key: key);
  final FirebaseUser user;
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
    Controllers.add(new TextEditingController());
    Controllers.add(new TextEditingController());
    Controllers.add(new TextEditingController());
    Controllers.add(new TextEditingController());

    return Scaffold(
        appBar: AppBar(
          title: Text('ערוך ביקורת'),
        ),
        body: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextField(
                  onChanged: (input) => ReviewKey = input,
                  decoration: InputDecoration(labelText: 'מפתח ביקורת'),
                ),
                RaisedButton(
                  onPressed: () async {
                    LoadReview();
                  },
                  child: Text('load review'),
                ),
                TextFormField(
                  controller: Controllers[3],
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'שם הכותב';
                    }

                  },
                  onSaved: (input) => _AuthorName = input,
                  decoration: InputDecoration(labelText: 'שם המורה'),
                ),
                TextFormField(
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
                      SaveReview();
                    }
                  },
                  child: Text('עדכן'),
                ),
                RaisedButton(
                  onPressed: () async {

                      DeleteReview();

                  },
                  child: Text('מחק'),
                )
              ],
            )));
  }

  Future<void> DeleteReview() async {
    await Firestore.instance
        .collection('Reviews')
        .document(ReviewKey)
        .delete();
    Navigator.of(context).pop();
    if(widget.user!=null)
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Welcome()));
    else
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Welcome()));
  }

  Future<void> SaveReview() async {

    final _formState = _formKey.currentState;
    if (_formState.validate()) {
      _formState.save();
      try {
        Firestore.instance.collection('Reviews').document(ReviewKey).updateData({ 'AuthorName':_AuthorName, 'InstructorName': _InstructorName,'rating':_Rating,'text':_Text });

        Navigator.of(context).pop();
        if(widget.user!=null)
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Welcome()));
        else
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Welcome()));
      } catch (e) {
        print(e.message);
      }
    }
  }

  Future<void> LoadReview() async {
    print(ReviewKey);
    final DocumentSnapshot result = await Firestore.instance
        .collection('Reviews')
        .document(ReviewKey)
        .get();

    _InstructorName = result.data['InstructorName'];
    _AuthorName = result.data['AuthorName'];
    _Text = result.data['text'];
    _Rating = result.data['rating'];

    Controllers[0].text = _InstructorName;
    Controllers[1].text = _Rating.toString();
    Controllers[2].text = _Text;
    Controllers[3].text = _AuthorName;

    print(_Text);
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
