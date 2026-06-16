import 'package:flutter/material.dart';
import 'package:vpmobil_wrapper/theme.dart';

class SavedClassListTile extends StatelessWidget {
  final String fachKuerzel;
  final String lehrerKuerzel;
  final int nummer;

  const SavedClassListTile({super.key, required this.fachKuerzel, required this.lehrerKuerzel, required this.nummer});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppColors>()!;

    return Row(
      children: [
        Text(fachKuerzel, style: TextStyle(fontFamily: "Geist", fontSize: 15, letterSpacing: 0.5, color: theme.textPrimary)),
        Text(lehrerKuerzel, style: TextStyle(fontFamily: "Geist", fontSize: 15, letterSpacing: 0.5, color: theme.textPrimary)),
        //RadioMenuButton(value: value, groupValue: groupValue, onChanged: onChanged, child: child)
      ],
    );
  }
}