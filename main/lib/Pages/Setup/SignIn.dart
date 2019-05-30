import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:main/Pages/Home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _Email, _Password;
  final GlobalKey<FormState> _Formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Sign In'),
        ),
        body: Form(
            key: _Formkey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'Please Type Email';
                    }
                  },

                  onSaved: (input) => _Email = input,
                  decoration: InputDecoration(
                      labelText: 'Email'
                  ),
                ),
                TextFormField(
                  validator: (input) {
                    if (input.length < 6) {
                      return 'Please Type Password more then 6 Characters';
                    }
                  },

                  onSaved: (input) => _Password = input,
                  decoration: InputDecoration(
                      labelText: 'Password'
                  ),
                  obscureText: true,
                ),
                RaisedButton(
                  onPressed:SignIn,
                  child: Text('Sign In'),
                )

              ],
            )
        )
    );
  }

  Future<void> SignIn() async {
    final _FormState=_Formkey.currentState;
    if(_FormState.validate()){
      _FormState.save();
      try {
        FirebaseUser User = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _Email, password: _Password);
        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>Home(user:User)));

      }catch(e){
        print(e.message);
      }

    }

    //TODO Connect Firebase
  }
}