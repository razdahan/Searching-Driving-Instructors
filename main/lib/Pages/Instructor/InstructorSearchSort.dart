import 'package:flutter/material.dart';
import 'package:main/main.dart';
import "package:autocomplete_textfield/autocomplete_textfield.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import "package:collection/collection.dart";
import 'dart:math';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  String oldval;
  String sortType;
  AutoCompleteTextField search;
  GlobalKey<AutoCompleteTextFieldState<DrivingInstructor>> key =
      new GlobalKey();
  static List<DrivingInstructor> instructorList = new List<DrivingInstructor>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<GestureDetector> list = new List<GestureDetector>();
  bool loading = true;
  String currentCity;
  List<DropdownMenuItem> listDrop = new List<DropdownMenuItem>();
  void getInstructors() async {
    final QuerySnapshot result = await Firestore.instance
        .collection('DrivingInstructors')
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    instructorList = new List<DrivingInstructor>();

    for (int i = 0; i < documents.length; i++) {
      DrivingInstructor d = new DrivingInstructor(
          phoneNumber: documents[i].data['phoneNumber'],
          name: documents[i].data['name'],
          price: documents[i].data['price'],
          testArea: documents[i].data['testArea']);

      instructorList.add(d);
    }

    if (mounted) {
      setState(() {
        loading = false;
      });
    } else
      return;
  }

  @override
  void initState() {
    super.initState();
    sortType = 'none';
    oldval = "ללא";
    getInstructors();
    generateDrivers();
  }

  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  var arr = [
    "ללא",
    "עכו",
    "אופקים",
    "אילת",
    "באר-שבע",
    "דימונה",
    "מצפה רמון",
    "נתיבות",
    "ערד",
    "קרית גת",
    "רהט",
    "שדרות",
    "בית שאן",
    "חדרה",
    "חיפה",
    "טבריה",
    "יוקנעם",
    "כרמיאל",
    "מעלות",
    "נהריה",
    "נצרת עילית",
    "נתניה",
    "עפולה",
    "צפת",
    "קרית אליעזר",
    "קרית שמונה",
    "שפרעם",
    "אשדוד",
    "אשקלון",
    "בית שמש",
    "ירושלים",
    "מודיעין",
    "קרית מלאכי",
    "אריאל",
    "הרצליה",
    "חולון",
    "יבנה",
    "כפר סבא",
    "לוד",
    "פתח-תקוה",
    "ראשון לציון",
    "רחובות",
    "רמלה",
    "תל אביב"
  ];
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        endDrawer: drawer2(), // left side
        //endDrawer: new AppDrawer(), // right side
        appBar: new AppBar(
          title: Text(" מיון מורים ",
              style: new TextStyle(color: Colors.black, fontSize: 16)),
          backgroundColor: Colors.white,
          elevation: 10,
          centerTitle: true,
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
                child: LinearProgressIndicator())
            : Container(
                decoration: new BoxDecoration(
                    gradient: new LinearGradient(
                  colors: [HexColor("#1895C2"), HexColor("#51C5EF")],
                  begin: FractionalOffset.bottomCenter,
                  end: FractionalOffset.topCenter,
                )),
                child: Container(
                    alignment: Alignment.bottomCenter,
                    child: GridView.count(
                        childAspectRatio: 3,
                        crossAxisCount: 1,
                        mainAxisSpacing: 2,
                        children: list))));
  }

  Widget drawer2() {
    return Drawer(
      child: Directionality(
          textDirection: TextDirection.rtl,
          child: ListView(
            children: <Widget>[
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                      value: oldval,
                      onChanged: (String newValue) {
                        setState(() {
                          oldval = newValue;
                          getInstructors();
                          generateDrivers();
                        });

                        print("changed to ${oldval}");
                      },
                      items: arr.map((String value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    )),
                  ]),
              ListTile(
                title: Row(children: <Widget>[
                  Text('מיון מחיר מהזול ליקר'),
                  sortType == 'priceLH'
                      ? Icon(
                          Icons.done,
                          color: Colors.green,
                        )
                      : Icon(
                          Icons.done,
                        ),
                ]),
                onTap: () {
                  if (sortType == "priceLH")
                    setState(() {
                      sortType = "none";
                      getInstructors();
                      generateDrivers();
                    });
                  else
                    setState(() {
                      sortType = "priceLH";
                      getInstructors();
                      generateDrivers();
                    });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Row(children: <Widget>[
                  Text('מיון מחיר מהיקר לזול'),
                  sortType == 'priceHL'
                      ? Icon(
                          Icons.done,
                          color: Colors.green,
                        )
                      : Icon(
                          Icons.done,
                        ),
                ]),
                onTap: () {
                  print(sortType);
                  if (sortType == "priceHL")
                    setState(() {
                      sortType = "none";
                      getInstructors();
                      generateDrivers();
                    });
                  else
                    setState(() {
                      sortType = "priceHL";
                      getInstructors();
                      generateDrivers();
                    });
                  Navigator.pop(context);
                },
              ),
            ],
          )),
    );
  }

  void generateDrivers() {
    print('haloo');
    String state = oldval;
    list = new List<GestureDetector>();
    List<DrivingInstructor> tmp = new List<DrivingInstructor>();
    tmp = instructorList;
    print(tmp);
    setState(() {
      loading = true;
    });

    if (sortType == "priceHL") {
      tmp.sort((a, b) {
        return b.price.compareTo(b.price);
      });
    } else {
      if (sortType == "priceLH") {
        tmp.sort((a, b) {
          return b.price.compareTo(b.price);
        });
      } else {
        if (sortType == "none") {
          tmp = shuffle(tmp);
        }
      }
    }
    if (state != "ללא") {
      tmp.removeWhere((item) {
        return item.testArea != oldval;
      });
    }
    if (sortType == "priceLH") {
      for (var i = tmp.length - 1; i >= 0; i--) {
        list.add(profileRow(context, tmp[i]));
      }
    }
    if (sortType == "priceHL") {
      for (var i = 0; i < tmp.length; i++) {
        list.add(profileRow(context, tmp[i]));
      }
    }
    print(sortType);
    if (sortType == "none") {
      for (var i = tmp.length - 1; i >= 0; i--) {
        list.add(profileRow(context, tmp[i]));
      }
    }

    setState(() {
      loading = false;
    });
  }

  List<DrivingInstructor> shuffle(  List<DrivingInstructor> items) {
    var random = new Random();

    // Go through all elements.
    for (var i = items.length - 1; i > 0; i--) {
      // Pick a pseudorandom number according to the list length
      var n = random.nextInt(i + 1);

      var temp = items[i];
      items[i] = items[n];
      items[n] = temp;
    }

    return items;
  }

  Widget profileRow(BuildContext context, DrivingInstructor instructor) {
    double avg = 0;
    return new GestureDetector(
        child: Card(
      elevation: 15.0,
      child: Center(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
            Directionality(
                textDirection: TextDirection.rtl,
                child: Center(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                      Text(
                        instructor.name,
                        style: new TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
                            color: Colors.black),
                      ),
                    ]))),
            Directionality(
                textDirection: TextDirection.rtl,
                child: Center(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                      Text(
                        'דירוג ממוצע:',
                        style: new TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
                            color: Colors.black),
                      ),
                      SmoothStarRating(
                          allowHalfRating: true,
                          starCount: 5,
                          rating: avg,
                          size: 20.0,
                          color: HexColor("#51C5EF"),
                          borderColor: Colors.black,
                          spacing: 0.0)
                    ]))),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Text(
                ' מחיר:' + instructor.price + '|',
                style: new TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                    color: Colors.black),
              ),
              Text(
                ' אזור-טסטים:' + instructor.testArea,
                style: new TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                    color: Colors.black),
              ),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Text(
                instructor.phoneNumber,
                style: new TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                    color: Colors.lightBlueAccent),
              ),
            ])
          ])),
    ));
  }
}
