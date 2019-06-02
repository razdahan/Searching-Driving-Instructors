import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:main/main.dart';

class InstructorProfile extends StatefulWidget {
  @override
  _InstructorProfileState createState() => _InstructorProfileState();
  const InstructorProfile({Key key, this.user,this.Instructor}) : super(key: key);
  final FirebaseUser user;
  final DrivingInstructor Instructor;
}


class _InstructorProfileState extends State<InstructorProfile> {
  List<Text> reviews=new List<Text>();
  List<TextEditingController> controllers=new List<TextEditingController>();

  bool loading = true;
  void getInstructors() async {
    final QuerySnapshot result = await Firestore.instance
        .collection('Reviews')
        .where('InstructorName',isEqualTo:widget.Instructor.name).getDocuments();

    final List<DocumentSnapshot> documents = result.documents;
    reviews = new List<Text>();
    print(widget.Instructor.name);
    for (int i = 0; i < documents.length; i++) {

      Review r = new Review(
          AuthorName: documents[i].data['AuthorName'],
          InstructorName: documents[i].data['InstructorName'],
          Rating: documents[i].data['rating'],
          Text: documents[i].data['text'],
      );

      var textEditingController = new TextEditingController(text: r.Text);
      controllers.add(textEditingController);
      reviews.add(new Text(r.Text));

    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    getInstructors();
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
    title: Text(widget.Instructor.name),
    ),
      body: loading? LinearProgressIndicator() :SingleChildScrollView(
          child: new Column(
            children: reviews,
          )));



  }
}
