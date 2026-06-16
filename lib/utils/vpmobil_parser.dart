import 'package:flutter/material.dart';
import 'package:vpmobil_wrapper/theme.dart';
import 'package:xml/xml.dart';

class Period {
  final int stunde;
  final TimeOfDay beginn;
  final TimeOfDay ende;

  final String lehrerKuerzel;
  final String fachKuerzel;

  final String raum;
  final int unterrichtNummer;

  final SubjectChange fachAenderung;
  final TeacherChange? lehrerAenderung;
  final RoomChange? raumAenderung;

  final String? geaendertesFach;
  final String? geaenderterLehrer;
  final String? geaenderterRaum;

  final String hinweis;

  Period({
    required this.stunde,
    required this.beginn,
    required this.ende,
    required this.lehrerKuerzel,
    required this.fachKuerzel,
    required this.raum,
    required this.unterrichtNummer,
    required this.fachAenderung,
    this.lehrerAenderung,
    this.raumAenderung,
    this.geaendertesFach,
    this.geaenderterLehrer,
    this.geaenderterRaum,
    this.hinweis = "",
  });
}

SubjectChange parseFaAe(XmlElement period) {
  if (period.getElement("Fa")!.getAttribute("FaAe") == "FaGeaendert" && period.getElement("Fa")!.value == "---") {
    return SubjectChange.entfallen;
  }

  else if (period.getElement("Fa")!.getAttribute("FaAe") == "FaGeaendert") {
    return SubjectChange.geaendert;
  }
  
  else {
    return SubjectChange.normal;
  }
}

TeacherChange? parseLeAe(XmlElement period) {
  if (period.getElement("Le") == null) {
    return null;
  }

  else {
    if (period.getElement("Le")!.getAttribute("LeAe") == "LeGeaendert") {
      return TeacherChange.geaendert;
    }

    else {
      return TeacherChange.normal;
    }
  }
}

RoomChange? parseRaAe(XmlElement period) {
  if (period.getElement("Ra") == null) {
    return null;
  }

  else {
    if (period.getElement("Ra")!.getAttribute("RaAe") == "RaGeaendert") {
      return RoomChange.geaendert;
    }

    else {
      return RoomChange.normal;
    }
  }
}

enum SubjectChange {
  normal,
  geaendert,
  entfallen,
}

enum TeacherChange {
  normal,
  geaendert,
}

enum RoomChange {
  normal,
  geaendert,
}

extension StringX on String {
  bool get isBlank => trim().isEmpty;
}

Map<String, Color> rowColor(Period period, AppColors theme) {
  if (period.fachAenderung == SubjectChange.entfallen) {
    return { "background": Colors.pinkAccent, "border": Colors.pinkAccent, "text": theme.lessonCancelledText };
  }

  if (period.fachAenderung == SubjectChange.geaendert ||
      period.lehrerAenderung == TeacherChange.geaendert ||
      period.raumAenderung == RoomChange.geaendert) {
    return { "background": theme.lessonChangedBg, "border": theme.lessonChangedBorder, "text": theme.lessonChangedText };
  }
  
  return { "background": theme.component, "border": theme.border, "text": theme.textSecondary };
}