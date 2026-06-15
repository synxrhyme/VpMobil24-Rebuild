import 'package:flutter/material.dart';
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

  final String? hinweis;

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
    this.hinweis,
  });
}

SubjectChange parseFaAe(XmlElement period) {
  if (period.getElement("Fa")!.getAttribute("FaAe") == "---") {
    return SubjectChange.entfallen;
  }

  else if (period.getElement("Fa")!.getAttribute("FaAe") != null) {
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
    if (period.getElement("Le")!.getAttribute("RaAe") != null) {
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
    if (period.getElement("Ra")!.getAttribute("RaAe") != null) {
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