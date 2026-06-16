import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vpmobil_wrapper/utils/data_provider.dart';
import 'package:vpmobil_wrapper/utils/preferences_utils.dart';

class SelectedClassSubjects {
  // singleton!!
  Map<String, Map<int, bool>> visibleSubjectsForClasses = {};

  Future<void> reload(BuildContext context) async {
    for (String className in context.read<DataProvider>().classes) {
      // load saved config from mem
    }

    Map<String, dynamic>? visibleSubjectsMap = await loadJson("visibleSubjectsString");
    if (visibleSubjectsMap == null) return;
  }

  Future<void> saveData() async {
    // save config to mem
    // needs convertion into suitable type for prefs
  }
}