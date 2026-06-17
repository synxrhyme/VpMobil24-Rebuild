import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

Future<XmlDocument?> loadNewest(Map<String, dynamic> params) async {
  final String user = params["user"];
  final String password = params["password"];
  final String schoolNumber = params["school_number"];

  final basicAuth = 'Basic ${base64Encode(utf8.encode('$user:$password'))}';
  final url = Uri.parse("https://z2.stundenplan24.de/schulen/$schoolNumber/mobil/mobdaten/Klassen.xml");

  try {
    final response = await http.get(
      url,
      headers: {
        'authorization': basicAuth,
        'accept': 'application/xml',
      },
    );

    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      String xml = utf8.decode(bytes, allowMalformed: true);

      if (xml.startsWith('\uFEFF')) {
        xml = xml.substring(1);
      }

      final XmlDocument data = XmlDocument.parse(xml);
      return data;
    } else {
      debugPrint("Fehler: ${response.statusCode}");
      return null;
    }
  }
  catch (e) {
    debugPrint(e.toString());
    return null;
  }
}

Future<Map<DateTime, XmlDocument?>> fetchDates(List<DateTime> dates, String user, String password, String schoolNumber) async {
  final basicAuth = 'Basic ${base64Encode(utf8.encode('$user:$password'))}';
  final client = http.Client(); // Connection-Pooling

  try {
    final futures = dates.map((date) async {
      final formattedDate = "${date.year.toString().padLeft(4, '0')}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}";
      final url = Uri.parse("https://z2.stundenplan24.de/schulen/$schoolNumber/mobil/mobdaten/PlanKl$formattedDate.xml");

      try {
        final response = await client.get(url, headers: {
          'authorization': basicAuth,
          'accept': 'application/xml',
        });

        if (response.statusCode == 200) {
          final bytes = response.bodyBytes;
          String xml = utf8.decode(bytes, allowMalformed: true);

          if (xml.startsWith('\uFEFF')) xml = xml.substring(1);
          debugPrint("Daten für $formattedDate erfolgreich geladen");
          return MapEntry(date, XmlDocument.parse(xml));
        } else {
          debugPrint("Fehler $formattedDate: ${response.statusCode}");
          return MapEntry<DateTime, XmlDocument?>(date, null);
        }
      } catch (e) {
        debugPrint("Network error für $formattedDate: $e");
        return MapEntry<DateTime, XmlDocument?>(date, null);
      }
    });

    final results = await Future.wait(futures);
    return Map.fromEntries(results);
  } finally {
    client.close();
  }
}