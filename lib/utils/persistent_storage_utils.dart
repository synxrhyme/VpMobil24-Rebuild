import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:xml/xml.dart';

Future<File> _getFile(String name) async {
  final dir = await getApplicationDocumentsDirectory();
  return File("${dir.path}/$name.txt");
}

Future<void> savePersistentData(String key, XmlDocument xml) async {
  final file = await _getFile(key);
  final xmlString = xml.toXmlString();
  await file.writeAsString(xmlString);
}

Future<XmlDocument?> loadPersistentData(String key) async {
  try {
    final File file = await _getFile(key);
    final String xmlString = await file.readAsString();

    return XmlDocument.parse(xmlString);
  } catch (e) {
    return null;
  }
}

void deletePersistentData(String key) async {
  File file = await _getFile(key);

  if (await file.exists()) file.delete();
}