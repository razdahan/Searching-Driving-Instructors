import 'package:flutter/material.dart';
import 'package:main/Pages/Setup/SignIn.dart';
import 'package:main/Pages/Setup/SignUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:main/Pages/Home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(Myapp());

class Review {
  const Review(
      {@required this.InstructorName,
      @required this.AuthorName,
      @required this.Text,
      @required this.Rating});

  final String InstructorName;
  final String AuthorName;
  final String Text;
  final int Rating;

  Map<String, dynamic> toJson() => {
        'InstructorName': InstructorName,
        'AuthorName': AuthorName,
        'text': Text,
        'rating': Rating
      };
}

class DrivingInstructor {
  const DrivingInstructor(
      {@required this.phone_number,
      @required this.name,
      @required this.price,
      @required this.test_area});

  final String test_area;
  final String price;
  final String name;
  final String phone_number;

  Map<String, dynamic> toJson() => {
        'phone_number': phone_number,
        'price': price,
        'name': name,
        'test_area': test_area
      };
}

class User {
  const User(
      {@required this.phone_number,
      @required this.age,
      @required this.name,
      @required this.role});

  final String name;
  final String age;
  final String phone_number;
  final String role;

  Map<String, dynamic> toJson() =>
      {'phone_number': phone_number, 'age': age, 'name': name, 'role': role};
}

class Myapp extends StatefulWidget {
  @override
  _MyappState createState() => _MyappState();
}

class _MyappState extends State<Myapp> {
  FirebaseUser user;
  String name;
  bool loading = true;

  void getUser() async {
    user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      final DocumentSnapshot result =
          await Firestore.instance.collection('users').document(user.uid).get();
      name = result.data['name'];
    }
    setState(() {
      loading = false;
    });
    print(name);
  }

  @override
  void initState() {
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? MaterialApp(home: LinearProgressIndicator())
        : user != null
            ? MaterialApp(
                home: Home(
                user: user,
              ))
            : MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  fontFamily: 'carilio',
                ),
                home: MyHomePage(user: user, username: name),
              );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key key, this.user, this.username}) : super(key: key);
  final FirebaseUser user;
  final String username;

  @override
  Widget build(BuildContext context) {
    print(username);
    return new Scaffold(
      body: Container(
        decoration: new BoxDecoration(
            gradient: new LinearGradient(
          colors: [Colors.white, Colors.lightBlue],
          begin: FractionalOffset.bottomCenter,
          end: FractionalOffset.topCenter,
        )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 100.0, right: 100.0, top: 300.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ));
                      },
                      child: new Container(
                          alignment: Alignment.center,
                          height: 40.0,
                          decoration: new BoxDecoration(
                              color: Colors.white,
                              borderRadius: new BorderRadius.circular(9.0)),
                          child: new Text("התחברות",
                              style: new TextStyle(
                                  fontSize: 20.0, color: Colors.black))),
                    ),
                  ),
                )
              ],
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 100.0, right: 100.0, top: 10.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUp(),
                            ));
                      },
                      child: new Container(
                          alignment: Alignment.center,
                          height: 40.0,
                          decoration: new BoxDecoration(
                              color: Colors.white,
                              borderRadius: new BorderRadius.circular(9.0)),
                          child: new Text("הרשמה",
                              style: new TextStyle(
                                  fontSize: 20.0, color: Colors.black))),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
