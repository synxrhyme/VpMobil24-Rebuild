import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

Future<XmlDocument?> loadKlassen(Map<String, dynamic> params) async {
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