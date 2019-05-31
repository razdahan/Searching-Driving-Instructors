import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:main/Pages/Setup/SignIn.dart';


class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}
class User{


  const  User({
    @required this.phone_number,
    @required this.age,
    @required this.name,
  });
  final  String name;
   final  String age;
   final String phone_number;

  Map<String, dynamic> toJson() =>
      {
        'phone_number': phone_number,
        'age': age,
        'name':name
      };

  }
class _SignUpState extends State<SignUp> {
  String _email, _password,_name,_age,_phone_number;
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
                      return 'כתובת האימייל שלך חסרה';
                    }
                  },

                  onSaved: (input) => _email = input,
                  decoration: InputDecoration(
                      labelText: 'אימייל'
                  ),
                ),
                TextFormField(
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'השם שלך חסר';
                    }
                  },

                  onSaved: (input) => _name = input,
                  decoration: InputDecoration(
                      labelText: 'שם'
                  ),
                ),
                TextFormField(
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'הגיל שלך חסר';
                    }
                  },

                  onSaved: (input) => _age = input,
                  decoration: InputDecoration(
                      labelText: 'גיל'
                  ),
                ),
                TextFormField(
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'הטלפון שלך חסר';
                    }
                  },

                  onSaved: (input) => _phone_number = input,
                  decoration: InputDecoration(
                      labelText: 'מספר טלפון'
                  ),
                ),
                TextFormField(
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'הסיסמא שלך חסרה';
                    }
                    if (input.length < 6) {
                      return 'Please Type Password more then 6 Characters';
                    }
                  },

                  onSaved: (input) => _password = input,
                  decoration: InputDecoration(
                      labelText: 'סיסמא'
                  ),
                  obscureText: true,
                ),
                RaisedButton(
                  onPressed:signUp,
                  child: Text('הרשמה'),
                )

              ],
            )
        )
    );
  }
  Future<void> signUp() async {

    final _formState=_formKey.currentState;
    if(_formState.validate()){
      _formState.save();
      try {
       FirebaseUser user= await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password);
         Firestore.instance.runTransaction((transaction) async {
          User u=new User(phone_number: _phone_number, age: _age, name: _name);
           await transaction.set(Firestore.instance.collection("users").document(user.uid), u.toJson());
         });

        //TODO Change email
        Navigator.of(context).pop();
        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>LoginPage()));
      }catch(e){
        print(e.message);
      }

    }

    //TODO Connect Firebase
  }
}
