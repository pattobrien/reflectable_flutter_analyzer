import 'package:flutter/material.dart';

// This is an example of a Flutter-based file that we would want to analyze

final white = Color(0xFFFFFFFF);

final red = Colors.red;

class MyWidget extends StatelessWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
    );
  }
}
