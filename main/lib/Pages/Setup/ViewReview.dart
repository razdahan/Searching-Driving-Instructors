import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:main/Pages/Setup/InstructorProfile.dart';
import "package:autocomplete_textfield/autocomplete_textfield.dart";
import 'package:main/main.dart';
class ViewReview extends StatefulWidget {
  @override
  _ViewReviewState createState() => _ViewReviewState();

  const ViewReview({Key key, this.user}) : super(key: key);
  final FirebaseUser user;
}



class _ViewReviewState extends State<ViewReview> {
  AutoCompleteTextField search;
  GlobalKey<AutoCompleteTextFieldState<DrivingInstructor>> key = new GlobalKey();
  bool InstructorNameValidator;
  static List<DrivingInstructor> Inst = new List<DrivingInstructor>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool loading = true;



  void getInstructors() async {
    final QuerySnapshot result = await Firestore.instance
        .collection('DrivingInstructors')
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    Inst = new List<DrivingInstructor>();

    for (int i = 0; i < documents.length; i++) {
      DrivingInstructor d = new DrivingInstructor(
          phone_number: documents[i].data['phone_number'],
          name: documents[i].data['name'],
          price: documents[i].data['price'],
          test_area: documents[i].data['test_area']);

      Inst.add(d);
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    getInstructors();
  }

  Widget row(DrivingInstructor d) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            d.name,
            style: TextStyle(fontSize: 16.0),
          ),
          Padding(
            padding: EdgeInsets.all(15.0),
          ),
          Text(
            d.test_area,
          )
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('חפש ביקורות על מורה'),
        ),
        body: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                loading
                    ? LinearProgressIndicator()
                    : search = AutoCompleteTextField<DrivingInstructor>(
                        clearOnSubmit: false,
                        key: key,
                        suggestions: Inst,
                        style: TextStyle(color: Colors.black, fontSize: 16.0),
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 20.0),
                          hintText: "חפש מורה",
                          hintStyle: TextStyle(color: Colors.black),
                        ),
                        itemFilter: (item, query) {
                          return item.name.startsWith(query);
                        },
                        itemSorter: (a, b) {
                          return a.name.compareTo(b.name);
                        },
                        itemSubmitted: (item) {
                          setState(() {
                            search.textField.controller.text = item.name;
                            navigateToInstructorProfile(item);
                          });
                        },
                        itemBuilder: (context, item) {
                          return row(item);
                        },
                      )
              ],
            )));
  }

  void navigateToInstructorProfile(DrivingInstructor Instructor) {
    FirebaseAuth.instance.currentUser().then((firebaseUser) {
      if (firebaseUser == null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => InstructorProfile(user: null,Instructor: Instructor,),
                fullscreenDialog: true));
      } else {

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => InstructorProfile(user: firebaseUser,Instructor: Instructor,),
                fullscreenDialog: true));
      }
    });
  }
}
