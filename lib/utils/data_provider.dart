import 'package:vpmobil_wrapper/utils/api_utils.dart';
import 'package:vpmobil_wrapper/utils/preferences_utils.dart';
import 'package:vpmobil_wrapper/utils/time_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:vpmobil_wrapper/utils/persistent_storage_utils.dart';
import 'package:xml/xml.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DataProvider extends ChangeNotifier {
  late final Future<void> ready;

  Map<DateTime, XmlDocument?> _data = {};
  List<DateTime> _savedDates = [];
  List<String> _klassen = [];

  DateTime? _lastRefresh;
  DateTime? _newestKnownDate;

  Map<DateTime, XmlDocument?> get data => _data;
  List<DateTime> get savedDates => _savedDates;
  List<String> get classes => _klassen;

  DateTime? get lastRefresh => _lastRefresh;
  DateTime? get newestKnownDate => _newestKnownDate;

  DataProvider() {
    ready = _initialize();
  }

  Future<void> _initialize() async {
    debugPrint("initializing data provider...");

    String? lastRefreshString = await getString("last_refresh");
    if (lastRefreshString != null) _lastRefresh = DateTime.parse(lastRefreshString);

    String? newestKnownDateString = await getString("newest_known_date");
    if (newestKnownDateString != null) _newestKnownDate = DateTime.parse(newestKnownDateString);
    debugPrint("newest known date: $newestKnownDateString");

    List<String>? savedDateStrings = await loadList("saved_dates");
    if (savedDateStrings != null) _savedDates = savedDateStrings.map((dateString) => DateTime.parse(dateString)).toList();
    debugPrint("saved dates: $savedDateStrings");

    List<String>? klassen = await loadList("classes");
    if (klassen != null) _klassen = klassen;

    _data = {};
    for (DateTime date in _savedDates) {
      debugPrint("loading from memory: ${date.toIso8601String()}");
      _data[date] = await loadPersistentData(date.toIso8601String());
    }

    notifyListeners();
  }

  Future<bool> reload() async { // bool: success   
    try {
      final String user = dotenv.get("user");
      final String password = dotenv.get("password");
      final String schoolNumber = dotenv.get("school_number");

      final XmlDocument? newestData = await loadNewest({"user": user, "password": password, "school_number": schoolNumber});
      if (newestData == null) {
        debugPrint("Fehler beim Laden der Daten: Fehler bei der Netzwerkanfrage");
        return false;
      }

      List<DateTime>? requiredDates = await getRequiredDates(newestData);
      if (requiredDates == null) return false;

      List<String>? klassen = await getClasses(newestData);
      if (klassen == null) return false;

      await saveList("classes", klassen);
      List<String>? loadedKlassen = await loadList("classes");
      if (loadedKlassen != null) _klassen = loadedKlassen;

      await ensureRequired(requiredDates);

      final Map<DateTime, XmlDocument?> allData = await fetchDates(requiredDates, user, password, schoolNumber);

      for (MapEntry<DateTime, XmlDocument?> entry in allData.entries) {
        if (entry.value == null) continue;
        await savePersistentData(entry.key.toIso8601String(), entry.value!);
        
        if (!_savedDates.contains(entry.key)) _savedDates.add(entry.key);
        List<String> savedDatesStringList = _savedDates.map((dateTime) => dateTime.toIso8601String()).toList();
        debugPrint("saved_dates_list: $savedDatesStringList");
        await saveList("saved_dates", savedDatesStringList);
      }

      _data = {};
      for (DateTime date in _savedDates) {
        _data[date] = await loadPersistentData(date.toIso8601String());
      }

      await setString("last_refresh", DateTime.now().toIso8601String());
      String? loadedLastRefresh = await getString("last_refresh");
      if (loadedLastRefresh != null) _lastRefresh = DateTime.parse(loadedLastRefresh);
      
      String? loadedNewestKnownDate = await getString("newest_known_date");
      if (loadedNewestKnownDate != null) _newestKnownDate = DateTime.parse(loadedNewestKnownDate);
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
      final String newestDateFromXml = data.getElement('VpMobil')!.getElement('Kopf')!.getElement('DatumPlan')!.innerText.toString();
      newestDate = parseGermanDate(newestDateFromXml);
      setString("newest_known_date", newestDate.toIso8601String());
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
  
  Future<void> ensureRequired(List<DateTime> requiredDates) async {
    for (DateTime date in _savedDates) {
      bool isRequired = requiredDates.contains(date);

      if (!isRequired) {
        deletePersistentData(date.toIso8601String());

        _savedDates.remove(date);
        saveList("saved_dates", _savedDates.map((dateTime) => dateTime.toIso8601String()).toList());

        _data = {};
        for (DateTime date in _savedDates) {
          _data[date] = await loadPersistentData(date.toIso8601String());
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