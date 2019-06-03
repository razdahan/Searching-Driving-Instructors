import 'package:flutter/material.dart';
import 'package:main/Pages/Setup/SignIn.dart';
import 'package:main/Pages/Setup/SignUp.dart';
import 'package:main/Pages/Instructor/AddInstructor.dart';
import 'package:main/Pages/Reviews/AddReview.dart';
import 'package:main/Pages/Reviews/searchInstructor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:main/Pages/Setup/EditReview.dart';

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
            onPressed: () {
              navigateToSignIn();
            },
            child: Text('התחברות'),
          ),
          RaisedButton(
            onPressed: () {
              navigateToSignUp();
            },
            child: Text('הרשמה'),
          ),
          RaisedButton(
            onPressed: () {
              navigateToAddInstructor();
            },
            child: Text('הוספת מורה נהיגה'),
          ),
          RaisedButton(
            onPressed: () {
              navigateToAddReview();
            },
            child: Text('הוספת ביקורת על מורה נהיגה'),
          ),
          RaisedButton(
            onPressed: () {
              navigateToViewReview();
            },
            child: Text('ראה ביקורות'),
          ),
          RaisedButton(
            onPressed: () {
              navigateToEditReview();
            },
            child: Text('ערוך ביקורות'),
          ),
        ],
      ),
    );
  }

  void navigateToSignIn() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LoginPage(), fullscreenDialog: true));
  }

  void navigateToSignUp() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SignUp(), fullscreenDialog: true));
  }

  void navigateToAddInstructor() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddInstructor(), fullscreenDialog: true));
  }

  void navigateToAddReview() {
    FirebaseAuth.instance.currentUser().then((firebaseUser) {
      if (firebaseUser == null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddReview(user: null),
                fullscreenDialog: true));
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddReview(user: firebaseUser),
                fullscreenDialog: true));
      }
    });
  }

  void navigateToEditReview() {
    FirebaseAuth.instance.currentUser().then((firebaseUser) {
      if (firebaseUser == null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditReview(user: firebaseUser),
                fullscreenDialog: true));
      }
    });
  }

  void navigateToViewReview() {
    FirebaseAuth.instance.currentUser().then((firebaseUser) {
      if (firebaseUser == null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ViewReview(user: null),
                fullscreenDialog: true));
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ViewReview(user: firebaseUser),
                fullscreenDialog: true));
      }
    });
  }
}
