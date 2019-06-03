import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:main/Pages/Reviews/searchInstructor.dart';
import 'package:main/Pages/Reviews/AddReview.dart';
import 'package:main/Pages/Instructor/AddInstructor.dart';
import 'package:main/main.dart';

class Home extends StatelessWidget {
  const Home({Key key, this.user, this.name}) : super(key: key);
  final FirebaseUser user;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
              Text("  ${name} שלום", style: new TextStyle(color: Colors.white)),
          backgroundColor: HexColor("#51C5EF"),
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
        ),
        body: Container(
            decoration: new BoxDecoration(
                gradient: new LinearGradient(
              colors: [HexColor("#1895C2"), HexColor("#51C5EF")],
              begin: FractionalOffset.bottomCenter,
              end: FractionalOffset.topCenter,
            )),
            child: Padding(
                padding: const EdgeInsets.only(left: 0, right: 0, top: 180.0),
                child: Container(
                    alignment: Alignment.bottomCenter,
                    child: GridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 2,
                        children: <Widget>[
                          GestureDetector(
                              onTap: () {
                                navigateToViewReview(context);
                              },
                              child: Card(
                                  elevation: 5.0,
                                  child: new Center(
                                    child: new Text('חפש ביקורות '),
                                  ))),
                          GestureDetector(
                              onTap: () {
                                navigateToViewReview(context);
                              },
                              child: Card(
                                  elevation: 5.0,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Center(

                                              child: Icon(
                                                Icons.thumbs_up_down,
                                                color: Colors.redAccent,
                                                size: 60.0,
                                              ),

                                        ),
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                top: 25.0),
                                            child: Text('חפש מורה',style: TextStyle(fontSize: 18,fontWeight:FontWeight.w900),))
                                      ]))),
                          GestureDetector(
                              onTap: () {
                                navigateToAddReview(context);
                                print("add reviews");
                              },
                              child: Card(
                                  elevation: 5.0,
                                  child: new Center(
                                    child: new Text('tile '),
                                  ))),
                          GestureDetector(
                              onTap: () {
                                logout();
                                Navigator.pop(context);
                                Navigator.push(context,MaterialPageRoute(
                                    builder: (context) => Myapp(),
                                    fullscreenDialog: true));

                              },
                              child: Card(
                                  elevation: 5.0,
                                  child: new Center(
                                    child: new Text('התנתק '),
                                  ))),
                        ])))));
  }

  Center checkRole(DocumentSnapshot snapshot) {
    if (snapshot.data == null) {
      return Center(
        child: Text('no data set in the userId document in firestore'),
      );
    }
    if (snapshot.data['role'] == 'admin') {
      return adminPage(snapshot);
    } else {
      return userPage(snapshot);
    }
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Center adminPage(DocumentSnapshot snapshot) {
    return Center(
        child: Text('${snapshot.data['role']} ${snapshot.data['name']}'));
  }

  Center userPage(DocumentSnapshot snapshot) {
    return Center(child: Text(snapshot.data['name']));
  }

  void navigateToViewReview(BuildContext context) {
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

  void navigateToAddReview(BuildContext context) {
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

  void navigateToAddInstructor(BuildContext context) {
    FirebaseAuth.instance.currentUser().then((firebaseUser) {
      if (firebaseUser == null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddInstructor(user: null),
                fullscreenDialog: true));
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddInstructor(user: firebaseUser),
                fullscreenDialog: true));
      }
    });
  }
}
