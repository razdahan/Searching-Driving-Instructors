import 'package:flutter/material.dart';
import 'package:main/Pages/Setup/Welcome.dart';
void main() =>runApp(Myapp());

class Myapp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: new Welcome(),
    );
  }
}