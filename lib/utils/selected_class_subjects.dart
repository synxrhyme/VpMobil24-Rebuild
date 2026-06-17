import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vpmobil_wrapper/utils/data_provider.dart';
import 'package:vpmobil_wrapper/utils/preferences_utils.dart';

class SelectedClassSubjects extends ChangeNotifier {
  Map<String, Map<int, bool>> visibleSubjectsForClasses = {};

  Future<void> reload(BuildContext context) async {
    final dataProvider = context.read<DataProvider>();
    visibleSubjectsForClasses = {};

    for (String className in dataProvider.classes) {
      Map<String, dynamic>? saved = await loadJson("subjects_$className");
      Map<int, bool> classMap = {};

      if (saved != null) {
        saved.forEach((key, value) {
          final number = int.tryParse(key);
          if (number != null && value is bool) classMap[number] = value;
        });
      }

      visibleSubjectsForClasses[className] = classMap;
    }

    notifyListeners();
  }

  bool isSelected(String className, int nummer) {
    return visibleSubjectsForClasses[className]?[nummer] ?? true;
  }

  void setSelected(String className, int nummer, bool value) {
    visibleSubjectsForClasses.putIfAbsent(className, () => {});
    visibleSubjectsForClasses[className]![nummer] = value;
    notifyListeners();
  }

  Future<void> saveData(BuildContext context) async {
    for (final entry in visibleSubjectsForClasses.entries) {
      final Map<String, dynamic> jsonMap = {
        for (final e in entry.value.entries) e.key.toString(): e.value
      };
      await setString("subjects_${entry.key}", jsonEncode(jsonMap));
    }
  }

  void setAllInClass(BuildContext context, String className, bool value) {
    final dataProvider = context.read<DataProvider>();
    final allSubjects = dataProvider.subjectsForClasses[className] ?? [];

    visibleSubjectsForClasses.putIfAbsent(className, () => {});

    for (final subject in allSubjects) {
      visibleSubjectsForClasses[className]![subject.nummer] = value;
    }

    notifyListeners();
  }
}