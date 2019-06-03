import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:main/Pages/Reviews/searchInstructor.dart';
import 'package:main/Pages/Reviews/AddReview.dart';
import 'package:main/Pages/Instructor/AddInstructor.dart';
import 'package:main/main.dart';

class Home extends StatelessWidget {
  const Home({Key key, this.user, this.userData}) : super(key: key);
  final FirebaseUser user;
  final User userData;

  @override
  Widget build(BuildContext context) {
    return new Theme(
        data: new ThemeData(
        fontFamily: 'cour',
        hintColor: Colors.white,
        primaryColor: Colors.white,
        primaryColorDark: Colors.white,
    ),
    child:Scaffold(
        appBar: AppBar(
          title:
              Text("  ${userData.name} שלום", style: new TextStyle(color: Colors.white)),
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
                                navigateToAddInstructor(context);
                              },
                              child: Card(
                                  elevation: 5.0,
                                  child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: <Widget>[
                                        Center(

                                          child: Icon(
                                            Icons.plus_one,
                                            color: Colors.green,
                                            size: 60.0,
                                          ),

                                        ),
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                top: 25.0),
                                            child: Text('הוסף מורה',style: TextStyle(fontSize: 18,fontWeight:FontWeight.w800),))
                                      ]))),
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
                                            child: Text('חפש מורה',style: TextStyle(fontSize: 18,fontWeight:FontWeight.w800),))
                                      ]))),
                          GestureDetector(
                              onTap: () {

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
                                    child: new Text('התנתק'),
                                  ))),
                        ]))))));
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


  void navigateToAddInstructor(BuildContext context) {
    FirebaseAuth.instance.currentUser().then((firebaseUser) {
      if (firebaseUser == null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddInstructor(user: null,userData: null,),
                fullscreenDialog: true));
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddInstructor(user: firebaseUser,userData: userData,),
                fullscreenDialog: true));
      }
    });
  }
}
