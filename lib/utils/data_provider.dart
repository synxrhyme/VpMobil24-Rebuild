import 'dart:convert';
import 'package:vpmobil_wrapper/utils/choosable_subject.dart';
import 'package:vpmobil_wrapper/utils/fetch_dates.dart';
import 'package:vpmobil_wrapper/utils/fetch_klassen.dart';
import 'package:vpmobil_wrapper/utils/fetch_dir.dart';
import 'package:vpmobil_wrapper/utils/plan_file_entry.dart';
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

  Map<String, List<ChoosableSubject>>? _subjectsForClasses;

  Map<DateTime, XmlDocument?> get data => _data;
  List<DateTime> get savedDates => _savedDates;

  Map<DateTime, DateTime> _modifiedDates = {};
  Map<DateTime, DateTime> get modifiedDates => _modifiedDates;
  String _modifiedKey(DateTime date) => "${date.toIso8601String()} - modified";

  List<String> get classes => _klassen;
  Map<String, List<ChoosableSubject>> get subjectsForClasses =>
      _subjectsForClasses ?? {};

  DateTime? get lastRefresh => _lastRefresh;
  DateTime? get newestKnownDate => _newestKnownDate;

  DataProvider() {
    ready = _initialize();
  }

  Future<void> _initialize() async {
    debugPrint("Data provider initialisieren...");

    String? lastRefreshString = await getString("last_refresh");
    if (lastRefreshString != null)
      _lastRefresh = DateTime.parse(lastRefreshString);

    String? newestKnownDateString = await getString("newest_known_date");
    if (newestKnownDateString != null)
      _newestKnownDate = DateTime.parse(newestKnownDateString);
    debugPrint(
      "Neuestes bekanntes Datum: ${newestKnownDate!.day}.${newestKnownDate!.month}.${newestKnownDate!.year}",
    );

    List<String>? savedDateStrings = await loadList("saved_dates");
    if (savedDateStrings != null)
      _savedDates = savedDateStrings
          .map((dateString) => DateTime.parse(dateString))
          .toList();

    debugPrint("Gespeicherte Pläne:");
    for (DateTime date in _savedDates) {
      debugPrint("${date.day}.${date.month}.${date.year}");
    }

    List<String>? klassen = await loadList("classes");
    if (klassen != null) _klassen = klassen;

    Map<String, List<ChoosableSubject>> subjectsForClasses = {};

    for (String klasse in _klassen) {
      final int maxIndex = await getInt("maxIndex_$klasse") ?? 0;
      List<ChoosableSubject> dataForClass = [];

      for (int index = 0; index < maxIndex; index++) {
        String? rawData = await getString("subject_${index}_$klasse");
        if (rawData == null) continue;

        Map<String, dynamic> dataForSubject = jsonDecode(rawData);
        ChoosableSubject subject = ChoosableSubject(
          lehrerKuerzel: dataForSubject["lehrerKuerzel"],
          fachKuerzel: dataForSubject["fachKuerzel"],
          nummer: dataForSubject["nummer"],
        );
        dataForClass.add(subject);
      }

      subjectsForClasses[klasse] = dataForClass;
    }

    _subjectsForClasses = subjectsForClasses;

    _data = {};
    _modifiedDates = {};
    for (DateTime date in _savedDates) {
      debugPrint("Aus dem Speicher laden: ${date.day}.${date.month}.${date.year}");
      _data[date] = await loadPersistentData(date.toIso8601String());

      final String? modifiedString = await getString(_modifiedKey(date));
      final DateTime? modified = modifiedString == null
          ? null
          : DateTime.tryParse(modifiedString);
      if (modified != null) _modifiedDates[date] = modified;
    }

    notifyListeners();
  }

  Future<void> reload() async {
    try {
      final String user = dotenv.get("user");
      final String password = dotenv.get("password");
      final String schoolNumber = dotenv.get("school_number");

      final List<PlanFileEntry> availableFiles = await fetchPlanDirectory({
        "user": user,
        "password": password,
        "school_number": schoolNumber,
      });

      final XmlDocument? klassenFile = await loadKlassen({
        "user": user,
        "password": password,
        "school_number": schoolNumber,
      });

      if (klassenFile == null) {
        debugPrint("klassenFile is null");
        return;
      }

      List<String>? classes = await getClasses(klassenFile);
      if (classes == null) {
        debugPrint("classes is null");
        return;
      }

      Map<String, List<ChoosableSubject>>? subjectsForClasses =
          await getSubjectsForClasses(klassenFile);
      if (subjectsForClasses == null) {
        debugPrint("subjectsForClasses is null");
        return;
      }
      _subjectsForClasses = subjectsForClasses;

      for (MapEntry<String, List<ChoosableSubject>> entry
          in subjectsForClasses.entries) {
        for (int index = 0; index < entry.value.length; index++) {
          final subject = entry.value[index];
          Map<String, dynamic> data = {
            "fachKuerzel": subject.fachKuerzel,
            "lehrerKuerzel": subject.lehrerKuerzel,
            "nummer": subject.nummer,
          };
          await setString("subject_${index}_${entry.key}", jsonEncode(data));
        }

        final int maxIndex = entry.value.length;
        setInt("maxIndex_${entry.key}", maxIndex);
      }

      await saveList("classes", classes);
      List<String>? loadedClasses = await loadList("classes");
      if (loadedClasses != null) _klassen = loadedClasses;

      final PlanFileEntry latestFile =
          availableFiles[availableFiles.length - 1];
      DateTime? newestDate = latestFile.planDate;
      if (newestDate == null) {
        final String newestDateFromXml = klassenFile
            .getElement('VpMobil')!
            .getElement('Kopf')!
            .getElement('DatumPlan')!
            .innerText
            .toString();
        newestDate = parseGermanDate(newestDateFromXml);
      }

      setString("newest_known_date", newestDate.toIso8601String());
      _newestKnownDate = newestDate;

      final List<DateTime> datesToFetch = [];

      for (final e in availableFiles) {
        final DateTime? date = e.planDate;
        if (date == null) continue;

        final DateTime? stored = _modifiedDates[date];

        if (stored == null) {
          debugPrint(
            "NEU          ${e.fileName}: kein lokaler Stempel, remote=${e.modified}",
          );
          datesToFetch.add(date);
        } else if (e.modified == null || e.modified!.isAfter(stored)) {
          debugPrint(
            "GEÄNDERT     ${e.fileName}: lokal=$stored, remote=${e.modified}",
          );
          datesToFetch.add(date);
        } else {
          debugPrint(
            "UNVERÄNDERT  ${e.fileName}: lokal=$stored, remote=${e.modified}",
          );
        }
      }

      debugPrint(
        "Sync: ${datesToFetch.length} von ${availableFiles.length} Dateien geladen",
      );

      final Map<DateTime, XmlDocument?> allData = await fetchDates(
        datesToFetch,
        user,
        password,
        schoolNumber,
      );

      for (MapEntry<DateTime, XmlDocument?> entry in allData.entries) {
        if (entry.value == null) continue;
        await savePersistentData(entry.key.toIso8601String(), entry.value!);
        final matchingPlanFileEntry = availableFiles
            .where((e) => e.planDate == entry.key)
            .firstOrNull;
        if (matchingPlanFileEntry != null &&
            matchingPlanFileEntry.planDate != null &&
            matchingPlanFileEntry.modified != null) {
          await setString(
            _modifiedKey(matchingPlanFileEntry.planDate!),
            matchingPlanFileEntry.modified!.toIso8601String(),
          );
          _modifiedDates[entry.key] = matchingPlanFileEntry.modified!;
        } else {
          debugPrint(
            "matchingPlanFileEntry or matchingPlanFileEntry.planDate or matchingPlanFileEntry.modified == null",
          );
        }

        if (!_savedDates.contains(entry.key)) _savedDates.add(entry.key);
        List<String> savedDatesStringList = _savedDates
            .map((dateTime) => dateTime.toIso8601String())
            .toList();

        await saveList("saved_dates", savedDatesStringList);
      }

      List<String>? savedDates = await loadList("saved_dates");
      debugPrint("Gespeicherte Pläne: ");

      if (savedDates == null) {
        debugPrint("savedDates == null");
      } else {
        for (DateTime date in _savedDates) {
          debugPrint("${date.day}.${date.month}.${date.year}");
        }
      }

      _data = {};
      for (DateTime date in _savedDates) {
        _data[date] = await loadPersistentData(date.toIso8601String());
      }

      await setString("last_refresh", DateTime.now().toIso8601String());
      String? loadedLastRefresh = await getString("last_refresh");
      if (loadedLastRefresh != null)
        _lastRefresh = DateTime.parse(loadedLastRefresh);

      final List<DateTime> requiredDates = await getRequiredDates(
        newestDate,
      ); // monday last week -> today
      await ensureRequired(requiredDates);
    } catch (error) {
      debugPrint("$error");
      return null;
    }

    notifyListeners();
    return null;
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
    } catch (error) {
      debugPrint("Fehler beim Laden der Klassen: $error");
      return null;
    }
  }

  Future<Map<String, List<ChoosableSubject>>?> getSubjectsForClasses(
    XmlDocument data,
  ) async {
    final Map<String, List<ChoosableSubject>> result = {};

    try {
      final vpMobil = data.getElement('VpMobil');
      for (final kl in vpMobil!.findAllElements('Kl')) {
        final kurz = kl.getElement('Kurz')?.innerText ?? "";

        final subjects = <ChoosableSubject>[];

        final unterricht = kl.getElement('Unterricht');
        if (unterricht != null) {
          for (final ueNr in unterricht.findAllElements('UeNr')) {
            subjects.add(
              ChoosableSubject(
                lehrerKuerzel: ueNr.getAttribute('UeLe') ?? '',
                fachKuerzel: ueNr.getAttribute('UeGr') ?? '',
                nummer: int.parse(ueNr.innerText),
              ),
            );
          }
        }

        result[kurz] = subjects;
      }

      return result;
    } catch (error) {
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
        saveList(
          "saved_dates",
          _savedDates.map((dateTime) => dateTime.toIso8601String()).toList(),
        );

        _modifiedDates.remove(date);
        deletePrefValue(_modifiedKey(date));

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
