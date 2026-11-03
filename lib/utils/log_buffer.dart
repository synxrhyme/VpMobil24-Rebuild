import 'dart:async';
import 'package:flutter/foundation.dart';

class LogBuffer extends ChangeNotifier {
  LogBuffer._();
  static final LogBuffer instance = LogBuffer._();

  static const int maxLines = 500;
  final List<String> _lines = [];

  String get text => _lines.join('\n');

  void add(String line) {
    final n = DateTime.now();
    String two(int v) => v.toString().padLeft(2, '0');
    _lines.add('[${two(n.hour)}:${two(n.minute)}:${two(n.second)}] $line');

    if (_lines.length > maxLines) {
      _lines.removeRange(0, _lines.length - maxLines);
    }
    // Microtask, damit nie mitten in einem build() benachrichtigt wird
    scheduleMicrotask(notifyListeners);
  }

  void clear() {
    _lines.clear();
    notifyListeners();
  }
}