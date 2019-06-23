import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main/Pages/Home.dart';
import 'package:main/Pages/Setup/SignIn.dart';
import 'package:main/Pages/Setup/SignUp.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';

void main() => runApp(Myapp());

class DrivingInstructor {
  final String testArea;

  final String price;
  final String name;
  final String phoneNumber;
  const DrivingInstructor(
      {@required this.phoneNumber,
      @required this.name,
      @required this.price,
      @required this.testArea});

  Map<String, dynamic> toJson() => {
        'phoneNumber': phoneNumber,
        'price': price,
        'name': name,
        'testArea': testArea
      };
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}

class Myapp extends StatefulWidget {
  @override
  _MyappState createState() => _MyappState();
}

class MyHomePage extends StatelessWidget {
  final FirebaseUser user;
  const MyHomePage({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [HexColor("#1895C2"), HexColor("#51C5EF")],
          begin: FractionalOffset.bottomCenter,
          end: FractionalOffset.topCenter,
        )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(children: <Widget>[
              Expanded(
                  child: Padding(
                      padding: EdgeInsets.only(left: 100.0, right: 100.0),
                      child: Image.asset('assets/logo.png')))
            ]),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Padding(
                      padding: EdgeInsets.only(left: 100.0, right: 100.0),
                      child: Card(
                        elevation: 15.0,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginPage(),
                                ));
                          },
                          child: Container(
                              alignment: Alignment.center,
                              height: 40.0,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(9.0)),
                              child: Text("התחברות",
                                  style: TextStyle(
                                      fontSize: 20.0, color: Colors.black))),
                        ),
                      )),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.only(
                          left: 100.0, right: 100.0, top: 30.0),
                      child: Card(
                        elevation: 15.0,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignUp(),
                                ));
                          },
                          child: Container(
                              alignment: Alignment.center,
                              height: 40.0,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(9.0)),
                              child: Text("הרשמה",
                                  style: TextStyle(
                                      fontSize: 20.0, color: Colors.black))),
                        ),
                      )),
                )
              ],
            ),
            Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: width / 2,
                            right: 0.0,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Home(
                                          user: null,
                                          userData: null,
                                        ),
                                  ));
                            },
                            child: Container(
                                color: Colors.transparent,
                                alignment: Alignment.center,
                                height: 40.0,
                                child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Text("כניסה ללא התחברות",
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.black)))),
                          ),
                        ),
                      )
                    ],
                  )
                ]),
          ],
        ),
      ),
    );
  }
}

class Review {
  final String instructorName;

  final String authorName;
  final String text;
  final double rating;
  final String reviewKey;
  final String userId;
  const Review(
      {@required this.instructorName,
      @required this.authorName,
      @required this.text,
      @required this.rating,
      this.reviewKey,
      this.userId});

  Map<String, dynamic> toJson() => {
        'instructorName': instructorName,
        'authorName': authorName,
        'text': text,
        'rating': rating,
        'userId': userId
      };
}

class User {
  final String email;
  final String name;
  final String age;
  final String phoneNumber;
  final String role;
  const User(
      {@required this.phoneNumber,
      @required this.age,
      @required this.name,
      @required this.role,
      @required this.email});

  Map<String, dynamic> toJson() => {
        'phoneNumber': phoneNumber,
        'age': age,
        'name': name,
        'role': role,
        'email': email
      };
}

class _MyappState extends State<Myapp> {
  FirebaseUser user;
  User u;
  bool loading = true;

  @override
  Widget build(BuildContext context) {
    return loading
        ? MaterialApp(home: LinearProgressIndicator())
        : user != null
            ? MaterialApp(
                home: Home(
                user: user,
                userData: u,
              ))
            : MaterialApp(
                theme: ThemeData(
                  fontFamily: 'Cour',
                ),
                home: MyHomePage(user: user),
              );
  }

  void getUser() async {
    user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      final DocumentSnapshot result =
          await Firestore.instance.collection('users').document(user.uid).get();
      User u = new User(
          phoneNumber: result.data['phoneNumber'],
          age: result.data['age'],
          name: result.data['name'],
          role: result.data['role'],
          email: result.data['email']);
      this.u = u;
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }
}
