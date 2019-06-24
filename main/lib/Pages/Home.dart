import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main/Pages/Instructor/InstructorSelectSearchType.dart';
import 'package:main/Pages/Instructor/AddInstructor.dart';
import 'package:main/Pages/Setup/SignIn.dart';
import 'package:main/Pages/Setup/SignUp.dart';
import 'package:main/main.dart';
import 'package:main/Pages/User/Profile.dart';

class Home extends StatelessWidget {
  const Home({Key key, this.user, this.userData}) : super(key: key);
  final FirebaseUser user;
  final User userData;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return new Theme(
        data: new ThemeData(
          fontFamily: 'cour',
          hintColor: Colors.white,
          primaryColor: Colors.white,
          primaryColorDark: Colors.white,
        ),
        child: Scaffold(
            appBar: AppBar(
              title: userData != null
                  ? Text(" שלום ${userData.name} ",
                      style: new TextStyle(color: Colors.black))
                  : Text(" שלום  ", style: new TextStyle(color: Colors.black)),
              backgroundColor: Colors.white,
              elevation: 10,
              centerTitle: true,
              iconTheme: IconThemeData(
                color: Colors.black, //change your color here
              ),
            ),
            body: Stack(children: <Widget>[
              Container(
                  decoration: new BoxDecoration(
                      gradient: new LinearGradient(
                    colors: [HexColor("#1895C2"), HexColor("#51C5EF")],
                    begin: FractionalOffset.bottomCenter,
                    end: FractionalOffset.topCenter,
                  )),
                  child: Padding(
                      padding:
                          EdgeInsets.only(left: 0, right: 0, top: height / 4),
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
                                                  Icons.person_add,
                                                  color: Colors.green,
                                                  size: 60.0,
                                                ),
                                              ),
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 25.0),
                                                  child: Text(
                                                    'הוסף מורה',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w800),
                                                  ))
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
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 25.0),
                                                  child: Text(
                                                    'חפש מורה',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w800),
                                                  ))
                                            ]))),
                                GestureDetector(
                                    onTap: userData != null
                                        ? () {
                                            navigateToMyProfile(context);
                                          }
                                        : () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      SignUp(),
                                                ));
                                          },
                                    child: Card(
                                        elevation: 5.0,
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Center(
                                                child: userData != null
                                                    ? Icon(
                                                        Icons.account_circle,
                                                        color: Colors.black,
                                                        size: 60.0,
                                                      )
                                                    : Icon(
                                                        Icons.account_circle,
                                                        color: Colors.black,
                                                        size: 60.0,
                                                      ),
                                              ),
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 25.0),
                                                  child: userData != null
                                                      ? Text(
                                                          'פרופיל',
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800),
                                                        )
                                                      : Text(
                                                          'הרשמה',
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800),
                                                        ))
                                            ]))),
                                GestureDetector(
                                    onTap: userData != null
                                        ? () {
                                            logout();
                                            Navigator.pop(context);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Myapp(),
                                                    fullscreenDialog: true));
                                          }
                                        : () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        LoginPage(),
                                                    fullscreenDialog: true));
                                          },
                                    child: Card(
                                        elevation: 5.0,
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Center(
                                                child: userData != null
                                                    ? Icon(
                                                        Icons
                                                            .power_settings_new,
                                                        color: Colors.black,
                                                        size: 60.0,
                                                      )
                                                    : Icon(
                                                        Icons.exit_to_app,
                                                        color: Colors.black,
                                                        size: 60.0,
                                                      ),
                                              ),
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 25.0),
                                                  child: userData != null
                                                      ? Text(
                                                          'התנתקות',
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800),
                                                        )
                                                      : Text(
                                                          'התחברות',
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800),
                                                        ))
                                            ]))),
                              ])))),
              Padding(
                  padding: EdgeInsets.only(top: height / 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      
                    userData != null? Text(
                        setHeader() + ' ' + userData.name.split(" ")[0],
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            color: Colors.white),
                      ):
                      Text(
                        setHeader(),
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            color: Colors.white),
                      )
                      ,
                    ],
                  ))
            ])));
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
  }

  String setHeader() {
    DateTime time = DateTime.now();
    if (time.hour <= 12 && time.hour >= 6) {
      return 'בוקר טוב';
    }
    if (time.hour >= 12 && time.hour <= 14) {
      return 'צהריים טובים';
    }
    if (time.hour > 14 && time.hour < 20) {
      return 'ערב טוב';
    }
    return 'לילה טוב';
  }

  void navigateToViewReview(BuildContext context) {
    FirebaseAuth.instance.currentUser().then((firebaseUser) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => InstructorSelect(
                    user: firebaseUser,
                    userData: userData == null
                        ? new User(
                            name: "",
                            role: "member",
                            age: "",
                            email: "",
                            phoneNumber: "")
                        : userData,
                  ),
              fullscreenDialog: true));
    });
  }

  void navigateToAddInstructor(BuildContext context) {
    FirebaseAuth.instance.currentUser().then((firebaseUser) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddInstructor(
                    user: firebaseUser,
                    userData: userData == null
                        ? new User(
                            name: "",
                            role: "member",
                            age: "",
                            email: "",
                            phoneNumber: "")
                        : userData,
                  ),
              fullscreenDialog: true));
    });
  }

  void navigateToMyProfile(BuildContext context) {
    FirebaseAuth.instance.currentUser().then((firebaseUser) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Profile(
                    user: firebaseUser,
                    userData: userData,
                  ),
              fullscreenDialog: true));
    });
  }
}
