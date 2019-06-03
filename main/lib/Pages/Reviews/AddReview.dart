import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:main/Pages/Setup/Welcome.dart';
import 'package:main/main.dart';

class AddReview extends StatefulWidget {
  @override
  _AddReviewState createState() => _AddReviewState();

  const AddReview({Key key, this.user,this.instructor}) : super(key: key);
  final FirebaseUser user;
  final DrivingInstructor instructor;
}

class _AddReviewState extends State<AddReview> {
  String _text,_rating;
  bool InstructorNameValidator;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
              elevation: 0.0,
              title: Text('הוספת ביקורת', style: new TextStyle(color: Colors.white)),
              backgroundColor: HexColor("#51C5EF"),
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
                        Directionality(
                            textDirection: TextDirection.rtl,
                            child: Padding(
                                padding: EdgeInsets.only(left:30,right:30,top: 25.0),
                                child: TextFormField(
                                  decoration: new InputDecoration(
                                    labelText: "דירוג",
                                    labelStyle:
                                    new TextStyle(color: Colors.white),
                                    fillColor: Colors.white,
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.white),
                                    ),
                                  ),
                                  validator: (input) {
                                    if (input.isEmpty) {
                                      return 'חסר הדירוג';
                                    }
                                  },
                                  onSaved: (input) => _rating = input,
                                ))),
                        Directionality(
                            textDirection: TextDirection.rtl,
                            child: Padding(
                                padding: EdgeInsets.only(left:30,right:30,top: 25.0),
                                child: TextFormField(
                                  decoration: new InputDecoration(
                                    labelText: "ביקורת בכמה מילים",
                                    labelStyle:
                                    new TextStyle(color: Colors.white),
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
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 100.0, right: 100.0, top: 70.0),
                                  child:Card(
                                    elevation: 15,
                                    child: GestureDetector(
                                      onTap: addReview,
                                      child: new Container(
                                          alignment: Alignment.center,
                                          height: 40.0,
                                          decoration: new BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                            new BorderRadius.circular(9.0),

                                          ),
                                          child: new Text("הוסף ביקורת",
                                              style: new TextStyle(
                                                  fontSize:
                                                  15.0,
                                                  color: Colors.black))),
                                    ),
                                  )),
                            )
                          ],
                        ),
                      ],
                    )))));
  }

  Future<void> addReview() async {
    final _formState = _formKey.currentState;
    if (_formState.validate()) {
      _formState.save();
      try {
        String username = "";
        if(widget.user!=null) {
          username=widget.instructor.name;
        }
        else
          username = "Anonymos";

        Firestore.instance.runTransaction((transaction) async {
          Review u = new Review(
              InstructorName:username,
              AuthorName: username,
              Rating: int.parse(_rating),
              Text: _text);
          await transaction.set(
              Firestore.instance.collection("Reviews").document(), u.toJson());
        });


        Navigator.of(context).pop();
        Navigator.pop(
            context);
      } catch (e) {
        print(e);
      }
    }
  }

  /**Future<bool> doesInstructorExist(String name) async {
    print(name);
    final QuerySnapshot result = await Firestore.instance
        .collection('DrivingInstructors')
        .where('name', isEqualTo: name)
        .limit(1)
        .getDocuments();

    final List<DocumentSnapshot> documents = result.documents;

    return documents.length == 1;
  }
      **/
}
