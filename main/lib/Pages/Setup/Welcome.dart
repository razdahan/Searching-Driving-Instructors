import 'package:flutter/material.dart';
import 'package:main/Pages/Setup/SignIn.dart';
import 'package:main/Pages/Setup/SignUp.dart';
import 'package:main/Pages/Setup/AddInstructor.dart';
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
          child: Text('התחברות'),
          ),
          RaisedButton(
            onPressed:(){navigateToSignUp();},
            child: Text('הרשמה'),
          ),
          RaisedButton(
            onPressed:(){navigateToAddInstructor();},
            child: Text('הוספת מורה נהיגה'),
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
  void navigateToAddInstructor(){
    Navigator.push(context,MaterialPageRoute(builder: (context)=>AddInstructor(),fullscreenDialog: true));
  }
}
