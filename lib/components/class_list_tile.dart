import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vpmobil_wrapper/theme.dart';
import 'package:vpmobil_wrapper/utils/saved_classes_provider.dart';

class ClassListTile extends StatelessWidget {
  final String title;
  final int buttonSourceIndex;
  const ClassListTile({super.key, required this.title, required this.buttonSourceIndex});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppColors>()!;

    return ListTile(
      title: Text(title, style: TextStyle(color: theme.textPrimary, fontFamily: "Geist", fontSize: 16)),
      onTap: () {
        context.read<SavedClassesProvider>().edit("$buttonSourceIndex", true, title);
        Navigator.pop(context);
      },
      trailing: Icon(Icons.arrow_right_rounded, size: 30, color: theme.textPrimary),
    );
  }
}