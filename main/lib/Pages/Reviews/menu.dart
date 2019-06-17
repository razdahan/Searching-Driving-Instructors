import 'package:flutter/material.dart';
import 'package:main/main.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  String currentProfilePic =
      "https://avatars3.githubusercontent.com/u/16825392?s=460&v=4";
  String otherProfilePic =
      "https://yt3.ggpht.com/-2_2skU9e2Cw/AAAAAAAAAAI/AAAAAAAAAAA/6NpH9G8NWf4/s900-c-k-no-mo-rj-c0xffffff/photo.jpg";

  void switchAccounts() {
    String picBackup = currentProfilePic;
    this.setState(() {
      currentProfilePic = otherProfilePic;
      otherProfilePic = picBackup;
    });
  }

  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        endDrawer: new AppDrawer(), // left side
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
        body: Container(
          decoration: new BoxDecoration(
              gradient: new LinearGradient(
            colors: [HexColor("#1895C2"), HexColor("#51C5EF")],
            begin: FractionalOffset.bottomCenter,
            end: FractionalOffset.topCenter,
          )),
          child: new ListView(children: <Widget>[
            new Directionality(
                textDirection: TextDirection.rtl,
                child: Text(
                  "תוסף זה נמצא בפיתוח כרגע!",
                  style: new TextStyle(fontSize: 50,fontWeight: FontWeight.w900),
                ))
          ]),
        ));
  }
}

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => new _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: new ListView(
        children: <Widget>[],
      ),
    );
  }
}
