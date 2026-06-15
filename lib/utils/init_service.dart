import 'package:flutter/foundation.dart';

class InitService extends ChangeNotifier {
  final List<Future<void>> _tasks = [];
  bool _isReady = false;

  bool get isReady => _isReady;

  void register(Future<void> task) {
    assert(!_isReady, 'register() nach start() aufgerufen — zu spät.');
    _tasks.add(task);
  }

  Future<void> start() async {
    await Future.wait(_tasks);
    _isReady = true;
    notifyListeners();
  }
}