import 'package:flutter/material.dart';
import 'package:main/Pages/Setup/Welcome.dart';
void main() =>runApp(Myapp());

class Review {
  const Review(
      {@required this.InstructorName,
        @required this.AuthorName,
        @required this.Text,
        @required this.Rating});

  final String InstructorName;
  final String AuthorName;
  final String Text;
  final int Rating;

  Map<String, dynamic> toJson() => {
    'InstructorName': InstructorName,
    'AuthorName': AuthorName,
    'text': Text,
    'rating': Rating
  };
}

class DrivingInstructor {
  const DrivingInstructor(
      {@required this.phone_number,
        @required this.name,
        @required this.price,
        @required this.test_area});

  final String test_area;
  final String price;
  final String name;
  final String phone_number;

  Map<String, dynamic> toJson() => {
    'phone_number': phone_number,
    'price': price,
    'name': name,
    'test_area': test_area
  };
}
class Myapp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: new Welcome(),
    );
  }
}