import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:main/Pages/Setup/Welcome.dart';
import 'package:main/main.dart';
class AddInstructor extends StatefulWidget {
  @override
  _AddInstructorState createState() => _AddInstructorState();
  const AddInstructor({Key key, this.user}) : super(key: key);
  final FirebaseUser user;
}



class _AddInstructorState extends State<AddInstructor> {
  String _name, _test_area, _phone_number, _price;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Sign Up'),
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
                  },
                  onSaved: (input) => _name = input,
                  decoration: InputDecoration(labelText: 'שם המורה'),
                ),
                TextFormField(
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'אזור טסטים של המורה חסר';
                    }
                  },
                  onSaved: (input) => _test_area = input,
                  decoration: InputDecoration(labelText: 'אזור טסטים'),
                ),
                TextFormField(
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'הטלפון של המורה חסר';
                    }
                  },
                  onSaved: (input) => _phone_number = input,
                  decoration: InputDecoration(labelText: 'מספר טלפון'),
                ),
                TextFormField(
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'המחיר לשיעור חסר';
                    }
                  },
                  onSaved: (input) => _price = input,
                  decoration: InputDecoration(labelText: 'מחיר לשיעור'),
                ),
                RaisedButton(
                  onPressed: AddDrivingInstructor,
                  child: Text('הוספה'),
                )
              ],
            )));
  }

  Future<void> AddDrivingInstructor() async {
    final _formState = _formKey.currentState;
    if (_formState.validate()) {
      _formState.save();
      final DocumentSnapshot result = await Firestore.instance
          .collection('users').document(widget.user.uid).get();
        String role=result.data['role'];


      if(role.toLowerCase()=="admin") {
        Firestore.instance.runTransaction((transaction) async {
          DrivingInstructor u = new DrivingInstructor(
              phone_number: _phone_number,
              name: _name,
              price: _price,
              test_area: _test_area);
          await transaction.set(
              Firestore.instance.collection("DrivingInstructors").document(),
              u.toJson());
        });


        Navigator.of(context).pop();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Welcome()));
      }
      else{

      }


    }
  }
}
