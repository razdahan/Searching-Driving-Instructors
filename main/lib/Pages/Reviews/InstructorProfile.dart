import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:main/main.dart';
import 'package:main/Pages/Reviews/AddReview.dart';
import 'package:main/Pages/Reviews/EditReview.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class InstructorProfile extends StatefulWidget {
  @override
  _InstructorProfileState createState() => _InstructorProfileState();

  const InstructorProfile({Key key, this.user, this.instructor, this.userData})
      : super(key: key);
  final FirebaseUser user;
  final DrivingInstructor instructor;
  final User userData;
}

class _InstructorProfileState extends State<InstructorProfile> {
  List<GestureDetector> reviews = new List<GestureDetector>();
  List<TextEditingController> controllers = new List<TextEditingController>();

  bool loading = true;

  Widget reviewWidget(BuildContext context, Review r) {
    return new GestureDetector(
        onTap: () {
          if (widget.user != null) if (widget.userData.role == "admin")
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditReview(
                          user: widget.user,
                          userData: widget.userData,
                          review: r,
                          instructor: widget.instructor,
                        ),
                    fullscreenDialog: true));
        },
        child: Container(
            height: 1000,
            child: Card(
              elevation: 15.0,
              child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: ListTile(
                    title: Row(children: <Widget>[
                      Icon(
                        Icons.account_circle,
                        color: Colors.black,
                        size: 60.0,
                      ),
                      SmoothStarRating(
                          allowHalfRating: false,
                          starCount: 5,
                          rating: r.rating,
                          size: 20.0,
                          color: HexColor("#51C5EF"),
                          borderColor: Colors.black,
                          spacing: 0.0)
                    ]),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Text(
                        r.text + '-' + r.authorName,
                        style: new TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 12,
                            color: Colors.black),
                      ),
                    ),
                    dense: true,
                  ),
                )
              ),
            ));
  }

  Widget profileRow(BuildContext context,double avg) {
    return new GestureDetector(
        child: Container(
            height: 1000,
            child: Card(
              elevation: 15.0,
              child: ListView(children: [
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: ListTile(
                    title: Row(children: <Widget>[

                      Icon(
                        Icons.school,
                        color: Colors.black,
                        size: 40.0,
                      ),

                      Text(
                        'דירוג ממוצע:',
                        style: new TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 12,
                            color: Colors.black),

                      ),
                      SmoothStarRating(
                          allowHalfRating: false,
                          starCount: 5,
                          rating: avg,
                          size: 20.0,
                          color: HexColor("#51C5EF"),
                          borderColor: Colors.black,
                          spacing: 0.0)
                    ]),


                    subtitle:Row(
                        children:<Widget>[

                          Text(
                      ' מחיר:' + widget.instructor.price+'|',
                        style: new TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 10,
                            color: Colors.black),

                      ),

                          Text(
                            ' אזור-טסטים:' + widget.instructor.testArea+'|',
                            style: new TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 10,
                                color: Colors.black),

                          ),



                        ]
                    ),

                )
                )]),
            )));
  }

  void getInstructors() async {
    final QuerySnapshot result = await Firestore.instance
        .collection('Reviews')
        .where('instructorName', isEqualTo: widget.instructor.name)
        .getDocuments();
    double sum = 0;

    final List<DocumentSnapshot> documents = result.documents;
    reviews = new List<GestureDetector>();

    print(widget.instructor.name);
    for (int i = 0; i < documents.length; i++) {
      sum += documents[i].data['rating'];
    }
    double avg=0;
    if (documents.length != 0)
       avg = sum / documents.length;
    else
       avg = 0;
    reviews.add(profileRow(context,avg));
    for (int i = 0; i < documents.length; i++) {
      reviews.add(reviewWidget(
          context,
          new Review(
              authorName: documents[i].data['authorName'],
              instructorName: documents[i].data['instructorName'],
              rating: documents[i].data['rating'],
              text: documents[i].data['text'],
              reviewKey: documents[i].documentID)));
    }
    print(loading);
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getInstructors();
  }

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
            floatingActionButton: FloatingActionButton(
              backgroundColor: HexColor("#1895C2"),
              child: Icon(Icons.add,color:Colors.white,),
              onPressed: () {
                navigateToAddReview(context);
              },
            ),
            appBar: AppBar(
              title: Text(widget.instructor.name,
                  style: new TextStyle(color: Colors.black)),
              backgroundColor: Colors.white,
              centerTitle: true,
              elevation: 10,
              iconTheme: IconThemeData(
                color: Colors.black, //change your color here
              ),
            ),
            body: loading
                ? Container(
                decoration: new BoxDecoration(
                    gradient: new LinearGradient(
                      colors: [HexColor("#1895C2"), HexColor("#51C5EF")],
                      begin: FractionalOffset.bottomCenter,
                      end: FractionalOffset.topCenter,
                    )),
                child:LinearProgressIndicator()
            )
                : Container(
                    decoration: new BoxDecoration(
                        gradient: new LinearGradient(
                      colors: [HexColor("#1895C2"), HexColor("#51C5EF")],
                      begin: FractionalOffset.bottomCenter,
                      end: FractionalOffset.topCenter,
                    )),
                    child: Padding(
                        padding:
                            const EdgeInsets.only(left: 0, right: 0, top: 0.0),
                        child: Container(
                            alignment: Alignment.bottomCenter,
                            child: GridView.count(
                                childAspectRatio: 3,
                                crossAxisCount: 1,
                                mainAxisSpacing: 2,
                                children: reviews))))));
  }

  void navigateToAddReview(BuildContext context) {
    FirebaseAuth.instance.currentUser().then((firebaseUser) {

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddReview(
                      user: firebaseUser,
                      instructor: widget.instructor,
                      userData: widget.userData,
                    ),
                fullscreenDialog: true));

    });
  }
}
