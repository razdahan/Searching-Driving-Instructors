import 'package:flutter/material.dart';
import 'package:main/Pages/Setup/SignIn.dart';
import 'package:main/Pages/Setup/SignUp.dart';
class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dargu App'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          RaisedButton(
          onPressed:(){navigateToSignIn();},
          child: Text('Sign In'),
          ),
          RaisedButton(
            onPressed:(){navigateToSignUp();},
            child: Text('Sign Up'),
          ),

        ],
      ),
    );

  }
  void navigateToSignIn(){
    Navigator.push(context,MaterialPageRoute(builder: (context)=>LoginPage(),fullscreenDialog: true));
  }
  void navigateToSignUp(){
    Navigator.push(context,MaterialPageRoute(builder: (context)=>SignUp(),fullscreenDialog: true));
  }
}
