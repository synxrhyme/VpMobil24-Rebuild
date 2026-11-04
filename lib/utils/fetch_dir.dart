import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:vpmobil_wrapper/utils/plan_file_entry.dart';

Future<List<PlanFileEntry>> fetchPlanDirectory(
  Map<String, dynamic> params,
) async {
  final String user = params["user"];
  final String password = params["password"];
  final String schoolNumber = params["school_number"];

  final request = http.MultipartRequest(
    'POST',
    Uri.https(
      'z2.stundenplan24.de',
      '/schulen/$schoolNumber/mobil/_phpmob/vpdir.php',
    ),
  );

  request.headers['Authorization'] =
      'Basic ${base64Encode(utf8.encode('$user:$password'))}';
  request.fields['pw'] = "I N D I W A R E";
  request.fields['art'] = 'mobk';

  final streamed = await request.send().timeout(const Duration(seconds: 15));
  final response = await http.Response.fromStream(streamed);

  if (response.statusCode != 200) {
    throw Exception('vpdir.php: HTTP ${response.statusCode}');
  }

  final body = utf8.decode(response.bodyBytes, allowMalformed: true);
  final preview = body.length > 200 ? body.substring(0, 200) : body;

  debugPrint('vpdir.php: Planverzeichnis erfolgreich geladen');

  if (body.trim().isEmpty) {
    throw Exception('vpdir.php: leere Antwort (pw oder Zugangsdaten falsch?)');
  }

  final all = parsePlanDirectory(body);
  final entries = all.where((e) => e.planDate != null).toList();

  if (entries.isEmpty) {
    throw Exception(
      'vpdir.php: ${all.length} Einträge geparst, aber keine Plandatei. '
      'Antwortbeginn: $preview',
    );
  }

  entries.sort((a, b) => a.planDate!.compareTo(b.planDate!));
  debugPrint('vpdir.php: ${entries.length} Plandateien verfügbar');
  return entries;
}
