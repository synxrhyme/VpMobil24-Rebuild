import 'package:flutter/material.dart';

class LoadingService extends ChangeNotifier {
  bool _loading = false;

  bool get isLoading => _loading;

  void show() {
    _loading = true;
    notifyListeners();
  }

  void hide() {
    _loading = false;
    notifyListeners();
  }
}