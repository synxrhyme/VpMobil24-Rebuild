import 'package:flutter/material.dart';

class SubjectSelectPage extends StatefulWidget {
  final String class_;
  
  const SubjectSelectPage({super.key, required this.class_});
  
  @override
  State<SubjectSelectPage> createState() => _SubjectSelectPageState();
}

class _SubjectSelectPageState extends State<SubjectSelectPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: Colors.white.withAlpha(200)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Fächer auswählen', style: TextStyle(color: Colors.white.withAlpha(200)),),
        backgroundColor: Color.fromARGB(255, 15, 15, 15)
      ),
    );
  }
}