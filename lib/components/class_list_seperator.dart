import 'package:flutter/material.dart';

class ClassListSeperator extends StatelessWidget {
  const ClassListSeperator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: const Color.fromARGB(255, 80, 80, 80),
      margin: EdgeInsets.symmetric(horizontal: 10),
    );
  }
}