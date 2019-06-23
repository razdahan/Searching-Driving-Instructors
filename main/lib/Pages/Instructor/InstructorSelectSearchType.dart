import 'package:flutter/material.dart';
import 'package:main/main.dart';
import 'package:main/Pages/Instructor/SearchInstructorName.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:main/Pages/Instructor/InstructorSearchSort.dart';



class InstructorSelect extends StatefulWidget {
  @override
  _InstructorSelectState createState() => _InstructorSelectState();
  const InstructorSelect({Key key, this.user, this.userData}) : super(key: key);
  final FirebaseUser user;
  final userData;
}

class _InstructorSelectState extends State<InstructorSelect> {
  @override
  Widget build(BuildContext context) {
    return new Theme(
        data: new ThemeData(
          fontFamily: 'cour',
          hintColor: Colors.white,
          primaryColor: Colors.white,
          primaryColorDark: Colors.white,
        ),
        child: Scaffold(
            appBar: AppBar(
              title:Text(" בחר אחת מהאופציות ",
                  style: new TextStyle(color: Colors.black,fontSize: 16)),
              backgroundColor: Colors.white,
              elevation: 10,
              centerTitle: true,
              iconTheme: IconThemeData(
                color: Colors.black, //change your color here
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
                    padding:
                         EdgeInsets.only(left: 0, right: 0, top:10,),
                    child: Container(
                        alignment: Alignment.bottomCenter,
                        child: GridView.count(
                            childAspectRatio: 1.5,
                            crossAxisCount: 1,
                            mainAxisSpacing: 2,
                            children: <Widget>[
                              GestureDetector(
                                  onTap: () {
                                    navigateToViewReview(context);
                                  },
                                  child: Card(
                                      elevation: 15.0,
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Center(
                                              child: Icon(
                                                Icons.search,
                                                color: Colors.black,
                                                size: 60.0,
                                              ),
                                            ),
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 25.0),
                                                child: Text(
                                                  'חפש לפי שם',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w800),
                                                ))
                                          ]))),
                              GestureDetector(
                                  onTap: () {
                                    //navigateToViewReview(context);
                                    Navigator.push(context,  MaterialPageRoute(
                                        builder: (context) => Menu()
                                    ),);
                                  },
                                  child: Card(
                                      elevation: 15.0,
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Center(
                                              child: Icon(
                                                Icons.sort,
                                                color: Colors.black,
                                                size: 60.0,
                                              ),
                                            ),
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 25.0),
                                                child: Text(
                                                  'סנן מורים',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w800),
                                                ))
                                          ]))),

                            ]))))));
  }
  void navigateToViewReview(BuildContext context) {
    FirebaseAuth.instance.currentUser().then((firebaseUser) {

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SearchInstructor(
                user: firebaseUser,
                userData:widget.userData,
              ),
              fullscreenDialog: true));

    });
  }
}
