import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:main/Pages/Reviews/InstructorProfile.dart';
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
  GlobalKey<AutoCompleteTextFieldState<DrivingInstructor>> key =
  new GlobalKey();
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
    if (mounted) {
      setState(() {
        loading = false;
      });
    }else
      return;
  }

  @override
  void initState() {
    getInstructors();
  }

  Widget row(DrivingInstructor d) {
    return Container(
        decoration: new BoxDecoration(

            border: new Border.all(color: Colors.grey,width: 0.5)
        ),
        child:Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: <Widget>[

              Text(
                d.test_area,
                style: TextStyle(fontFamily: 'cour'),
              ),
              Padding(
                padding:const EdgeInsets.only(
                    left: 20.0, top: 75.0),
              ),
              Text(
                d.name,
                style: TextStyle(fontFamily: 'cour'),
              ),

            ]));
  }


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
              title: Text("חפש את המורה",
                  style: new TextStyle(color: Colors.white)),
              backgroundColor: HexColor("#51C5EF"),
              elevation: 0,
              centerTitle: true,
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
                        loading
                            ? LinearProgressIndicator()
                            : Directionality(
                            textDirection: TextDirection.rtl,
                            child: search =
                                AutoCompleteTextField<DrivingInstructor>(
                                  clearOnSubmit: true,
                                  key: key,
                                  suggestions: Inst,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  decoration: InputDecoration(

                                    hintText: "חפש מורה",
                                    hintStyle: TextStyle(color: Colors.white),
                                  ),
                                  itemFilter: (item, query) {
                                    return item.name.startsWith(query);
                                  },
                                  itemSorter: (a, b) {
                                    return a.name.compareTo(b.name);
                                  },
                                  itemSubmitted: (item) {
                                    if(!mounted)
                                      return;
                                    setState(() {
                                      search.textField.controller.text =
                                          item.name;
                                      navigateToInstructorProfile(item);
                                    });
                                  },
                                  itemBuilder: (context, item) {
                                    return row(item);
                                  },
                                ))
                      ],
                    )))));
  }

  void navigateToInstructorProfile(DrivingInstructor Instructor) {
    FirebaseAuth.instance.currentUser().then((firebaseUser) {
      if (firebaseUser == null) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InstructorProfile(
                user: null,
                Instructor: Instructor,
              ),
            ));
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InstructorProfile(
                user: firebaseUser,
                Instructor: Instructor,
              ),
            ));
      }
    });
  }
}
