import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:main/Pages/Home.dart';
import 'package:main/main.dart';

class AddInstructor extends StatefulWidget {
  @override
  _AddInstructorState createState() => _AddInstructorState();
  const AddInstructor({Key key, this.user,this.userData}) : super(key: key);
  final FirebaseUser user;
  final User userData;
}



class _AddInstructorState extends State<AddInstructor> {
  String _name, _test_area, _phone_number, _price;
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
    child:Scaffold(
        appBar: AppBar(
          title: Text('הוספת מורה נהיגה', style: new TextStyle(fontSize:25,color: Colors.white)),
          backgroundColor: HexColor("#51C5EF"),
          centerTitle: true,
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
        ),
        body:Container(
        decoration: new BoxDecoration(
        gradient: new LinearGradient(
        colors: [HexColor("#1895C2"), HexColor("#51C5EF")],
        begin: FractionalOffset.bottomCenter,
        end: FractionalOffset.topCenter,
        )),
        child:Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                Directionality(
                    textDirection: TextDirection.rtl,
                    child: Padding(
                        padding: EdgeInsets.only(left:30,right:30,top: 25.0),
                        child: TextFormField(
                          decoration: new InputDecoration(
                            labelText: "שם",
                            labelStyle:
                            new TextStyle(color: Colors.white),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.white),
                            ),
                          ),
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'שם חסר';
                            }
                          },
                          onSaved: (input) => _name = input,
                        ))),
                Directionality(
                    textDirection: TextDirection.rtl,
                    child: Padding(
                        padding: EdgeInsets.only(left:30,right:30,top: 25.0),
                        child: TextFormField(
                          decoration: new InputDecoration(
                            labelText: "מספר טלפון",
                            labelStyle:
                            new TextStyle(color: Colors.white),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.white),
                            ),
                          ),
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'הטלפון של המורה חסר';
                            }
                          },
                          onSaved: (input) => _phone_number = input,
                        ))),
                Directionality(
                    textDirection: TextDirection.rtl,
                    child: Padding(
                        padding: EdgeInsets.only(left:30,right:30,top: 25.0),
                        child: TextFormField(
                          decoration: new InputDecoration(
                            labelText: "מחיר",
                            labelStyle:
                            new TextStyle(color: Colors.white),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.white),
                            ),
                          ),
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'המחיר לשיעור חסר';
                            }
                          },
                          onSaved: (input) => _price = input,
                        ))),
                Directionality(
                    textDirection: TextDirection.rtl,
                    child: Padding(
                        padding: EdgeInsets.only(left:30,right:30,top: 25.0),
                        child: TextFormField(
                          decoration: new InputDecoration(
                            labelText: "אזור טסטים",
                            labelStyle:
                            new TextStyle(color: Colors.white),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.white),
                            ),
                          ),
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'אזור טסטים חסר';
                            }
                          },
                          onSaved: (input) => _test_area = input,
                        ))),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                          padding: const EdgeInsets.only(
                              left: 100.0, right: 100.0, top: 30.0),
                          child: Card(
                            elevation: 15,
                            child: GestureDetector(
                              onTap: (){

                                if(widget.userData.role!="admin"){

                                  showDialog(
                                      context: context,
                                      builder: (_) => new AlertDialog(
                                    title: Text('התראה'),
                                    content:Directionality(
                                    textDirection: TextDirection.rtl
                                    ,
                                        child:Text(
                                        'הבקשה שלך להוספת המורה תשלח אל השרת ורק לאחר אישור תיתווסף לאפליקציה')),
                                    actions: <Widget>[

                                      FlatButton(

                                        child: const Text('ביטול'),
                                        onPressed: () {


                                        },
                                      ),
                                      FlatButton(
                                        child: const Text('אישור'),
                                        onPressed: () {
                                          print("sadadasdasdas");
                                          AddDrivingInstructor();



                                        },
                                      )
                                    ],
                                  )
                                  );
                                }

                                AddDrivingInstructor();},
                              child: new Container(
                                  alignment: Alignment.center,
                                  height: 40.0,
                                  decoration: new BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                    new BorderRadius.circular(9.0),
                                  ),
                                  child: new Text("הוסף",
                                      style: new TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.black))),
                            ),
                          )),
                    )
                  ],
                ),
              ],
            )))));
  }

  Future<void> AddDrivingInstructor() async {
    print("asdasdasdasfdsafsadfdsfd");
    final _formState = _formKey.currentState;
    if (_formState.validate()) {
      _formState.save();

        String role=widget.userData.role;


      if(role.toLowerCase()=="admin") {
        Firestore.instance.runTransaction((transaction) async {
          DrivingInstructor u = new DrivingInstructor(
              phone_number: _phone_number,
              name: _name,
              price: _price,
              test_area: _test_area);
          await transaction.set(
              Firestore.instance.collection("DrivingInstructorsTemp").document(),
              u.toJson());
        });


        Navigator.of(context).pop();
        Navigator.pop(
            context);
      }
      else{
        Firestore.instance.runTransaction((transaction) async {
          DrivingInstructor u = new DrivingInstructor(
              phone_number: _phone_number,
              name: _name,
              price: _price,
              test_area: _test_area);
          await transaction.set(
              Firestore.instance.collection("DrivingInstructorsTemp").document(),
              u.toJson());
        });


        Navigator.of(context).pop();
        Navigator.pop(
            context);
      }
      }


    }
  }

