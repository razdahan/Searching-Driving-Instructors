import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:main/Pages/Home.dart';
import 'package:main/Pages/Setup/SignIn.dart';
class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String _Email, _Password;
  final GlobalKey<FormState> _Formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Sign Up'),
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
                  onPressed:SignUp,
                  child: Text('Sign Up'),
                )

              ],
            )
        )
    );
  }
  Future<void> SignUp() async {
    final _FormState=_Formkey.currentState;
    if(_FormState.validate()){
      _FormState.save();
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _Email, password: _Password);

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
