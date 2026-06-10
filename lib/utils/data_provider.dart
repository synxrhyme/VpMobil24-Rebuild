import 'package:vpmobil_wrapper/utils/api_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:vpmobil_wrapper/utils/persistent_storage_utils.dart';
import 'package:xml/xml.dart';

class DataProvider extends ChangeNotifier {
  Map<DateTime, XmlDocument?> _data = {};
  // ignore: prefer_final_fields
  List<DateTime> _savedDates = [];
  List<String> _klassen = [];

  DateTime? _lastRefresh;

  Map<DateTime, XmlDocument?> get data => _data;
  List<String> get classes => _klassen;
  DateTime? get lastRefresh => _lastRefresh;

  DataProvider() {
    reload();
  }

  Future<bool> reload() async { // bool: success   
    try {
      final XmlDocument? data = await compute(loadNewest, null);
      if (data == null) {
        debugPrint("Fehler beim Laden der Daten: Fehler bei der Netzwerkanfrage");
        return false;
      }

      List<DateTime>? requiredDates = await getRequiredDates(data);
      if (requiredDates == null) return false;

      List<String>? klassen = await getClasses(data);
      if (klassen == null) return false;
      _klassen = klassen;

      ensureRequired(requiredDates);

      for (DateTime date in requiredDates) {
        final XmlDocument? data = await compute(fetchDate, date);

        if (data != null) {
          final String formattedDate = "${date.year.toString().padLeft(4, '0')}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}";
          savePersistentData(formattedDate, data);

          if (!_savedDates.contains(date)) _savedDates.add(date);
        }
        else {
          throw Exception("Fehler beim Laden der Daten für $date");
        }
      }

      _data = {};
      for (DateTime date in _savedDates) {
        final String formattedDate = "${date.year.toString().padLeft(4, '0')}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}";
        _data[date] = await loadPersistentData(formattedDate);
      }

      _lastRefresh = DateTime.now();
    }
    catch (error) {
      debugPrint("$error");
      return false;
    }

    notifyListeners();
    return true;
  }

  Future<List<DateTime>?> getRequiredDates(XmlDocument data) async {
    DateTime now = DateTime.now();
    DateTime newestDate = now;

    try {
      printLongString(data.toString());
      final String newestDateFromXml = data.getElement('VpMobil')!.getElement('Kopf')!.getElement('DatumPlan')!.innerText.toString();
      newestDate = DateTime.parse(newestDateFromXml);
    }
    catch (error) {
      debugPrint("Fehler beim Laden der benötigten Tage: $error");
      return null;
    }

    DateTime mondayThisWeek = now.subtract(Duration(days: now.weekday - 1));
    List<DateTime> requiredDates = getWeekdays(mondayThisWeek, newestDate);
    return requiredDates;
  }

  Future<List<String>?> getClasses(XmlDocument data) async {
    try {
      final vpMobil = data.getElement('VpMobil');
      final kurzListe = vpMobil!
        .findAllElements('Kl')
        .map((k) => k.getElement('Kurz')?.innerText)
        .whereType<String>()
        .toList();
      return kurzListe;
    }
    catch (error) {
      debugPrint("Fehler beim Laden der Klassen: $error");
      return null;
    }
  }

  List<DateTime> getWeekdays(DateTime start, DateTime end) {
    List<DateTime> days = [];

    DateTime current = DateTime(start.year, start.month, start.day);
    DateTime last = DateTime(end.year, end.month, end.day);

    while (!current.isAfter(last)) {
      if (current.weekday >= DateTime.monday &&
          current.weekday <= DateTime.friday) {
        days.add(current);
      }

      current = current.add(Duration(days: 1));
    }

    return days;
  }
  
  Future<void> ensureRequired(List<DateTime> requiredDates) async {
    for (DateTime date in _savedDates) {
      bool isRequired = requiredDates.contains(date);

      if (!isRequired) {
        final String formattedDate = "${date.year.toString().padLeft(4, '0')}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}";
        deletePersistentData(formattedDate);

        _savedDates.remove(date);

        _data = {};
        for (DateTime date in _savedDates) {
          final String formattedDate = "${date.year.toString().padLeft(4, '0')}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}";
          _data[date] = await loadPersistentData(formattedDate);
        }
      }
    }
  }

  List<String> parseKurzList(XmlDocument document) {
    return document
        .findAllElements('Kl')
        .map((kl) => kl.getElement('Kurz')?.innerText)
        .where((value) => value != null)
        .cast<String>()
        .toList();
  }
}