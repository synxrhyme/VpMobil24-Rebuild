import 'package:flutter/material.dart';
import 'package:vpmobil_wrapper/utils/preferences_utils.dart';

class ClassListTile extends StatelessWidget {
  final String title;
  final int buttonSourceIndex;
  const ClassListTile({super.key, required this.title, required this.buttonSourceIndex});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title, style: TextStyle(color: Colors.white.withAlpha(200))),
      onTap: () {
        setString("selected_class_button_$buttonSourceIndex", title);
        Navigator.pop(context);
      },
      trailing: Icon(Icons.arrow_right_rounded, size: 30, color: Colors.white.withAlpha(200)),
    );
  }
}