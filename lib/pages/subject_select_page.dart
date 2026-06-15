import 'package:flutter/material.dart';
import 'package:vpmobil_wrapper/theme.dart';

class SubjectSelectPage extends StatefulWidget {
  final String class_;
  
  const SubjectSelectPage({super.key, required this.class_});
  
  @override
  State<SubjectSelectPage> createState() => _SubjectSelectPageState();
}

class _SubjectSelectPageState extends State<SubjectSelectPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: theme.textPrimary),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Fächer auswählen', style: TextStyle(color: theme.textPrimary),),
        backgroundColor: Color.fromARGB(255, 15, 15, 15)
      ),
    );
  }
}