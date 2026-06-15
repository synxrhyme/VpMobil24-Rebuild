import 'package:flutter/material.dart';
import 'package:vpmobil_wrapper/utils/preferences_utils.dart';

class SavedClassesProvider extends ChangeNotifier {
  late final Future<void> ready;

  String button1Title = "";
  String button2Title = "";
  String button3Title = "";
  String button4Title = "";

  bool button1Set = false;
  bool button2Set = false;
  bool button3Set = false;
  bool button4Set = false;

  SavedClassesProvider() {
    ready = _initialize();
  }

  Future<void> _initialize() async {
    await reload();
  }

  Future<void> reload() async {
    final t1 = await getString("selected_class_button_1");
    final t2 = await getString("selected_class_button_2");
    final t3 = await getString("selected_class_button_3");
    final t4 = await getString("selected_class_button_4");

    if (t1 != null) { button1Title = t1; button1Set = true;  }
    else            { button1Title = ""; button1Set = false; }

    if (t2 != null) { button2Title = t2; button2Set = true;  }
    else            { button2Title = ""; button2Set = false; }

    if (t3 != null) { button3Title = t3; button3Set = true;  }
    else            { button3Title = ""; button3Set = false; }

    if (t4 != null) { button4Title = t4; button4Set = true;  }
    else            { button4Title = ""; button4Set = false; }

    notifyListeners();
  }

  void edit(String button, bool isSet, [String title = ""]) {
    switch (button) {
      case "1": editBtn1(isSet, title);
      case "2": editBtn2(isSet, title);
      case "3": editBtn3(isSet, title);
      case "4": editBtn4(isSet, title);
    }
  }

  Future<void> editBtn1(bool isSet, [String title = ""]) async {
    if (!isSet) {
      deletePrefValue("selected_class_button_1");
    }
    else {
      setString("selected_class_button_1", title);
    }

    reload();
  }
  
  Future<void> editBtn2(bool isSet, String title) async {
    if (!isSet) {
      deletePrefValue("selected_class_button_2");
    }
    else {
      setString("selected_class_button_2", title);
    }

    reload();
  }

  Future<void> editBtn3(bool isSet, String title) async {
    if (!isSet) {
      deletePrefValue("selected_class_button_3");
    }
    else {
      setString("selected_class_button_3", title);
    }

    reload();
  }

  Future<void> editBtn4(bool isSet, String title) async {
    if (!isSet) {
      deletePrefValue("selected_class_button_4");
    }
    else {
      setString("selected_class_button_4", title);
    }

    reload();
  }
}