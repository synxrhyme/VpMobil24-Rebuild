import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';
import 'package:vpmobil_wrapper/main.dart' show user, password, school_number;

final basicAuth = 'Basic ${base64Encode(utf8.encode('$user:$password'))}';

Future<XmlDocument?> loadNewest(dynamic _) async {
  final url = Uri.parse("https://z2.stundenplan24.de/schulen/$school_number/mobil/mobdaten/Klassen.xml");

  try {
    final response = await http.get(
      url,
      headers: {
        'authorization': basicAuth,
        'accept': 'application/xml',
      },
    );

    if (response.statusCode == 200) {
      String xml = response.body;

      if (xml.startsWith('\uFEFF')) {
        xml = xml.substring(1);
      }

      final XmlDocument data = XmlDocument.parse(xml);

      debugPrint("Daten: ${data.toString()}");
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

Future<XmlDocument?> fetchDate(DateTime date) async {
  final String formattedDate = "${date.year.toString().padLeft(4, '0')}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}";
  debugPrint("Lade Daten für $formattedDate");
  final url = Uri.parse("https://z2.stundenplan24.de/schulen/$school_number/mobil/mobdaten/$formattedDate.xml");

  try {
    final response = await http.get(
      url,
      headers: {
        'authorization': basicAuth,
        'accept': 'application/xml',
      },
    );

    if (response.statusCode == 200) {
      String xml = response.body;

      if (xml.startsWith('\uFEFF')) {
        xml = xml.substring(1);
      }

      final XmlDocument data = XmlDocument.parse(xml);
      return data;
    } else {
      debugPrint("Fehler: ${response.statusCode}");
      return null;
    }
    
  } catch (e) {
    debugPrint("network error");
    return null;
  }
}

void printLongString(String text) {
  const int chunkSize = 200;
  for (var i = 0; i < text.length; i += chunkSize) {
    debugPrint(text.substring(i, i + chunkSize > text.length ? text.length : i + chunkSize));
  }
}