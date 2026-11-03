class PlanFileEntry {
  final String fileName;    // z. B. "PlanKl20261028.xml"
  final DateTime? planDate; // Tag, für den der Plan gilt (null bei Klassen.xml)
  final DateTime? modified; // letzte Änderung laut Server

  const PlanFileEntry({
    required this.fileName,
    this.planDate,
    this.modified,
  });

  bool get isClassesFile => fileName == 'Klassen.xml';

  static final _fileDate = RegExp(r'^PlanKl(\d{4})(\d{2})(\d{2})\.xml$');
  static final _stamp =
      RegExp(r'^(\d{2})\.(\d{2})\.(\d{4})\s+(\d{2}):(\d{2})$');

  factory PlanFileEntry.fromParts(String fileName, String stamp) {
    DateTime? planDate;
    final f = _fileDate.firstMatch(fileName);
    if (f != null) {
      planDate = DateTime(
        int.parse(f[1]!),
        int.parse(f[2]!),
        int.parse(f[3]!),
      );
    }

    DateTime? modified;
    final s = _stamp.firstMatch(stamp);
    if (s != null) {
      modified = DateTime(
        int.parse(s[3]!),
        int.parse(s[2]!),
        int.parse(s[1]!),
        int.parse(s[4]!),
        int.parse(s[5]!),
      );
    }

    return PlanFileEntry(
      fileName: fileName,
      planDate: planDate,
      modified: modified,
    );
  }
}

List<PlanFileEntry> parsePlanDirectory(String body) {
  final parts = body
      .split(';')
      .map((s) => s.trim())
      .where((s) => s.isNotEmpty)
      .toList();

  final entries = <PlanFileEntry>[];
  for (var i = 0; i + 1 < parts.length; i += 2) {
    entries.add(PlanFileEntry.fromParts(parts[i], parts[i + 1]));
  }
  return entries;
}