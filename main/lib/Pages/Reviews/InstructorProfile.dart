import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:main/main.dart';
import 'package:main/Pages/Reviews/AddReview.dart';
import 'package:main/Pages/Reviews/EditReview.dart';
class InstructorProfile extends StatefulWidget {
  @override
  _InstructorProfileState createState() => _InstructorProfileState();

  const InstructorProfile({Key key, this.user, this.Instructor,this.userData})
      : super(key: key);
  final FirebaseUser user;
  final DrivingInstructor Instructor;
  final User userData;
}

class _InstructorProfileState extends State<InstructorProfile> {
  List<ListTile> reviews = new List<ListTile>();
  List<TextEditingController> controllers = new List<TextEditingController>();

  bool loading = true;

  void getInstructors() async {
    final QuerySnapshot result = await Firestore.instance
        .collection('Reviews')
        .where('InstructorName', isEqualTo: widget.Instructor.name)
        .getDocuments();

    final List<DocumentSnapshot> documents = result.documents;
    reviews = new List<ListTile>();
    print(widget.Instructor.name);
    for (int i = 0; i < documents.length; i++) {
      Review r = new Review(
        AuthorName: documents[i].data['AuthorName'],
        InstructorName: documents[i].data['InstructorName'],
        Rating: documents[i].data['rating'],
        Text: documents[i].data['text'],
        reviewKey: documents[i].documentID
      );

      var textEditingController = new TextEditingController(text: r.Text);
      controllers.add(textEditingController);
      reviews.add(new ListTile(
        onTap: (){
          if(widget.user!=null)
            if(widget.userData.role=="admin")
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditReview(user: widget.user,userData:widget.userData ,review: r,instructor: widget.Instructor,),
                      fullscreenDialog: true));
        },
          trailing: Icon(Icons.rate_review),
          leading: new Text(r.Rating.toString() + "  דירוג"),
          title: new Directionality(
              textDirection: TextDirection.rtl, child: Text(r.AuthorName)),
          subtitle: new Directionality(
              textDirection: TextDirection.rtl, child: Text(r.Text))));
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
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
    child:Scaffold(
        floatingActionButton: prefix0.FloatingActionButton(
          child:Icon(Icons.add),
          onPressed: (){
            navigateToAddReview(context);

          },
        ),
        appBar: AppBar(
          title: Text(widget.Instructor.name, style: new TextStyle(color: Colors.white)),
          backgroundColor:HexColor("#51C5EF"),
          centerTitle: true,
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
        ),
        body: loading
            ? LinearProgressIndicator()
            : Container(
            decoration: new BoxDecoration(
                gradient: new LinearGradient(
                  colors: [HexColor("#1895C2"), HexColor("#51C5EF")],
                  begin: FractionalOffset.bottomCenter,
                  end: FractionalOffset.topCenter,
                )),
            child: ListView(

                children: reviews,
              ))));
  }

  void navigateToAddReview(BuildContext context) {
    FirebaseAuth.instance.currentUser().then((firebaseUser) {
      if (firebaseUser == null) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => AddReview(user: null,userData: null,),
                fullscreenDialog: true));
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => AddReview(user: firebaseUser,instructor:widget.Instructor,userData:widget.userData ,),
                fullscreenDialog: true));
      }
    });
  }
}
