import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
//  VpMobil24 — Color System
//  Elevation-based dark/light + semantische
//  Vertretungsplan-Farben
// ─────────────────────────────────────────────

@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    // Elevation layers
    required this.base,
    required this.surface,
    required this.component,
    required this.raised,
    required this.border,

    // Text
    required this.textPrimary,
    required this.textSecondary,
    required this.textHint,

    // Accent
    required this.accent,
    required this.accentLight,
    required this.accentSubtle,
    required this.accentText,

    // Semantisch — Kernstück des Vertretungsplans
    required this.changed,
    required this.changedSubtle,
    required this.cancelled,
    required this.cancelledSubtle,
    required this.added,
    required this.addedSubtle,
    required this.notice,
    required this.noticeSubtle,
  });

  // Layers
  final Color base;
  final Color surface;
  final Color component;
  final Color raised;
  final Color border;

  // Text
  final Color textPrimary;
  final Color textSecondary;
  final Color textHint;

  // Accent
  final Color accent;
  final Color accentLight;
  final Color accentSubtle;
  final Color accentText;

  // Semantisch
  final Color changed;        // Vertretung — Vordergrund
  final Color changedSubtle;  // Vertretung — Hintergrund/Border
  final Color cancelled;      // Ausfall — Vordergrund
  final Color cancelledSubtle;
  final Color added;          // Zusatzstunde — Vordergrund
  final Color addedSubtle;
  final Color notice;         // Hinweis/Raumänderung — Vordergrund
  final Color noticeSubtle;

  // ── Convenience getters ──────────────────────

  /// Linker Rand + Hintergrund für geänderte Stunden
  Color get lessonChangedBg => changedSubtle;
  Color get lessonChangedBorder => changed;

  /// Linker Rand + Hintergrund für ausgefallene Stunden
  Color get lessonCancelledBg => cancelledSubtle;
  Color get lessonCancelledBorder => cancelled;

  /// Linker Rand + Hintergrund für Zusatzstunden
  Color get lessonAddedBg => addedSubtle;
  Color get lessonAddedBorder => added;

  /// Normaler Stunden-Hintergrund (auf surface)
  Color get lessonBg => component;

  /// Aktiver Tag-Tab Indikator
  Color get tabIndicator => accent;

  /// Online/aktuell-Badge
  Color get freshBadge => added;
  Color get freshBadgeBg => addedSubtle;

  // ── ThemeExtension boilerplate ───────────────

  @override
  AppColors copyWith({
    Color? base,
    Color? surface,
    Color? component,
    Color? raised,
    Color? border,
    Color? textPrimary,
    Color? textSecondary,
    Color? textHint,
    Color? accent,
    Color? accentLight,
    Color? accentSubtle,
    Color? accentText,
    Color? changed,
    Color? changedSubtle,
    Color? cancelled,
    Color? cancelledSubtle,
    Color? added,
    Color? addedSubtle,
    Color? notice,
    Color? noticeSubtle,
  }) {
    return AppColors(
      base: base ?? this.base,
      surface: surface ?? this.surface,
      component: component ?? this.component,
      raised: raised ?? this.raised,
      border: border ?? this.border,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textHint: textHint ?? this.textHint,
      accent: accent ?? this.accent,
      accentLight: accentLight ?? this.accentLight,
      accentSubtle: accentSubtle ?? this.accentSubtle,
      accentText: accentText ?? this.accentText,
      changed: changed ?? this.changed,
      changedSubtle: changedSubtle ?? this.changedSubtle,
      cancelled: cancelled ?? this.cancelled,
      cancelledSubtle: cancelledSubtle ?? this.cancelledSubtle,
      added: added ?? this.added,
      addedSubtle: addedSubtle ?? this.addedSubtle,
      notice: notice ?? this.notice,
      noticeSubtle: noticeSubtle ?? this.noticeSubtle,
    );
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) return this;
    return AppColors(
      base: Color.lerp(base, other.base, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      component: Color.lerp(component, other.component, t)!,
      raised: Color.lerp(raised, other.raised, t)!,
      border: Color.lerp(border, other.border, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textHint: Color.lerp(textHint, other.textHint, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentLight: Color.lerp(accentLight, other.accentLight, t)!,
      accentSubtle: Color.lerp(accentSubtle, other.accentSubtle, t)!,
      accentText: Color.lerp(accentText, other.accentText, t)!,
      changed: Color.lerp(changed, other.changed, t)!,
      changedSubtle: Color.lerp(changedSubtle, other.changedSubtle, t)!,
      cancelled: Color.lerp(cancelled, other.cancelled, t)!,
      cancelledSubtle: Color.lerp(cancelledSubtle, other.cancelledSubtle, t)!,
      added: Color.lerp(added, other.added, t)!,
      addedSubtle: Color.lerp(addedSubtle, other.addedSubtle, t)!,
      notice: Color.lerp(notice, other.notice, t)!,
      noticeSubtle: Color.lerp(noticeSubtle, other.noticeSubtle, t)!,
    );
  }
}

// ─────────────────────────────────────────────
//  Paletten
// ─────────────────────────────────────────────

const _vpDark = AppColors(
  // Elevation — fast neutral, nur ein Hauch Blau
  base:      Color(0xFF0E1117),
  surface:   Color(0xFF15171D),
  component: Color(0xFF1B1E26),
  raised:    Color(0xFF262A35),
  border:    Color(0xFF333845),

  // Text
  textPrimary:   Color(0xFFE2E4EE),
  textSecondary: Color(0xFF5C6080),
  textHint:      Color(0xFF3C4060),

  // Accent — kühles Indigo
  accent:       Color(0xFF7C8FFF),
  accentLight:  Color(0xFF9BAAFF),
  accentSubtle: Color(0x267C8FFF),  // 15% opacity
  accentText:   Color(0xFF0E1117),

  // Semantisch
  changed:         Color(0xFFE8853A),  // Orange — Vordergrund/Border
  changedSubtle:   Color(0x33C4621A),  // ~component-Helligkeit, kräftiger als vorher
  cancelled:       Color(0xFFE84B4B),  // Rot — Vordergrund/Border
  cancelledSubtle: Color(0x33C42020),  // ~component-Helligkeit, kräftiger als vorher
  added:           Color(0xFF4CAF6F),
  addedSubtle:     Color(0x1A4CAF6F),
  notice:          Color(0xFFD4A017),
  noticeSubtle:    Color(0x1AD4A017),
);

const _vpLight = AppColors(
  // Elevation
  base:      Color(0xFFF4F5F9),
  surface:   Color(0xFFFFFFFF),
  component: Color(0xFFF0F1F7),
  raised:    Color(0xFFFFFFFF),
  border:    Color(0xFFDDE0EE),

  // Text
  textPrimary:   Color(0xFF1A1D2E),
  textSecondary: Color(0xFF6B6F88),
  textHint:      Color(0xFFABAFC8),

  // Accent
  accent:       Color(0xFF4A5CFF),
  accentLight:  Color(0xFF6B7AFF),
  accentSubtle: Color(0x1A4A5CFF),
  accentText:   Color(0xFFFFFFFF),

  // Semantisch — etwas gedämpfter für hellen Hintergrund
  changed:         Color(0xFF7040E0),
  changedSubtle:   Color(0x157040E0),
  cancelled:       Color(0xFFCC3333),
  cancelledSubtle: Color(0x15CC3333),
  added:           Color(0xFF2E8A50),
  addedSubtle:     Color(0x152E8A50),
  notice:          Color(0xFFB58800),
  noticeSubtle:    Color(0x15B58800),
);

// ─────────────────────────────────────────────
//  ThemeData
// ─────────────────────────────────────────────

ThemeData vpDarkTheme() {
  const c = _vpDark;
  return ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: c.base,
    colorScheme: ColorScheme.dark(
      surface: c.surface,
      onSurface: c.textPrimary,
      primary: c.accent,
      onPrimary: c.accentText,
      secondary: c.accentLight,
      onSecondary: c.accentText,
      error: c.cancelled,
      outline: c.border,
      surfaceContainerHighest: c.raised,
    ),
    extensions: const [_vpDark],

    appBarTheme: AppBarTheme(
      backgroundColor: c.surface,
      foregroundColor: c.textPrimary,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(
        color: c.textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
      ),
      iconTheme: IconThemeData(color: c.textSecondary, size: 20),
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: c.surface,
      selectedItemColor: c.accent,
      unselectedItemColor: c.textHint,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
    ),

    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: c.surface,
      selectedIconTheme: IconThemeData(color: c.accent),
      unselectedIconTheme: IconThemeData(color: c.textHint),
      indicatorColor: c.accentSubtle,
    ),

    tabBarTheme: TabBarThemeData(
      labelColor: c.accent,
      unselectedLabelColor: c.textSecondary,
      indicatorColor: c.accent,
      indicatorSize: TabBarIndicatorSize.label,
      dividerColor: c.border,
      labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
      unselectedLabelStyle: const TextStyle(fontSize: 13),
    ),

    cardTheme: CardThemeData(
      color: c.component,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: c.border, width: 0.5),
      ),
      margin: EdgeInsets.zero,
    ),

    listTileTheme: ListTileThemeData(
      tileColor: Colors.transparent,
      selectedTileColor: c.accentSubtle,
      iconColor: c.textSecondary,
      textColor: c.textPrimary,
      subtitleTextStyle: TextStyle(fontSize: 12, color: c.textSecondary),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: c.raised,
      labelStyle: TextStyle(fontSize: 12, color: c.textSecondary),
      side: BorderSide(color: c.border, width: 0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
    ),

    dividerTheme: DividerThemeData(
      color: c.border,
      thickness: 0.5,
      space: 0,
    ),

    iconTheme: IconThemeData(color: c.textSecondary, size: 20),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(foregroundColor: c.textSecondary),
    ),

    textTheme: TextTheme(
      titleLarge: TextStyle(color: c.textPrimary, fontSize: 18, fontWeight: FontWeight.w500),
      titleMedium: TextStyle(color: c.textPrimary, fontSize: 15, fontWeight: FontWeight.w500),
      titleSmall: TextStyle(color: c.textPrimary, fontSize: 13, fontWeight: FontWeight.w500),
      bodyLarge: TextStyle(color: c.textPrimary, fontSize: 15),
      bodyMedium: TextStyle(color: c.textPrimary, fontSize: 13),
      bodySmall: TextStyle(color: c.textSecondary, fontSize: 12),
      labelSmall: TextStyle(color: c.textHint, fontSize: 11),
    ),
  );
}

ThemeData vpLightTheme() {
  const c = _vpLight;
  return ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: c.base,
    colorScheme: ColorScheme.light(
      surface: c.surface,
      onSurface: c.textPrimary,
      primary: c.accent,
      onPrimary: c.accentText,
      secondary: c.accentLight,
      onSecondary: c.accentText,
      error: c.cancelled,
      outline: c.border,
      surfaceContainerHighest: c.raised,
    ),
    extensions: const [_vpLight],

    appBarTheme: AppBarTheme(
      backgroundColor: c.surface,
      foregroundColor: c.textPrimary,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      shadowColor: c.border,
      titleTextStyle: TextStyle(
        color: c.textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      iconTheme: IconThemeData(color: c.textSecondary, size: 20),
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: c.surface,
      selectedItemColor: c.accent,
      unselectedItemColor: c.textHint,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
    ),

    tabBarTheme: TabBarThemeData(
      labelColor: c.accent,
      unselectedLabelColor: c.textSecondary,
      indicatorColor: c.accent,
      indicatorSize: TabBarIndicatorSize.label,
      dividerColor: c.border,
      labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
      unselectedLabelStyle: const TextStyle(fontSize: 13),
    ),

    cardTheme: CardThemeData(
      color: c.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: c.border, width: 0.5),
      ),
      margin: EdgeInsets.zero,
    ),

    listTileTheme: ListTileThemeData(
      tileColor: Colors.transparent,
      selectedTileColor: c.accentSubtle,
      iconColor: c.textSecondary,
      textColor: c.textPrimary,
      subtitleTextStyle: TextStyle(fontSize: 12, color: c.textSecondary),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: c.component,
      labelStyle: TextStyle(fontSize: 12, color: c.textSecondary),
      side: BorderSide(color: c.border, width: 0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
    ),

    dividerTheme: DividerThemeData(
      color: c.border,
      thickness: 0.5,
      space: 0,
    ),

    iconTheme: IconThemeData(color: c.textSecondary, size: 20),

    textTheme: TextTheme(
      titleLarge: TextStyle(color: c.textPrimary, fontSize: 18, fontWeight: FontWeight.w500),
      titleMedium: TextStyle(color: c.textPrimary, fontSize: 15, fontWeight: FontWeight.w500),
      titleSmall: TextStyle(color: c.textPrimary, fontSize: 13, fontWeight: FontWeight.w500),
      bodyLarge: TextStyle(color: c.textPrimary, fontSize: 15),
      bodyMedium: TextStyle(color: c.textPrimary, fontSize: 13),
      bodySmall: TextStyle(color: c.textSecondary, fontSize: 12),
      labelSmall: TextStyle(color: c.textHint, fontSize: 11),
    ),
  );
}

// ─────────────────────────────────────────────
//  Einbindung
// ─────────────────────────────────────────────
//
//  MaterialApp(
//    theme: vpLightTheme(),
//    darkTheme: vpDarkTheme(),
//    themeMode: ThemeMode.system,
//  )
//
//  Im Widget:
//  final c = Theme.of(context).extension<AppColors>()!;
//
//  ── Typische Nutzung ──────────────────────────
//
//  Scaffold:         color: c.base
//  Sidebar/Drawer:   color: c.surface
//  AppBar/BottomBar: color: c.component  (automatisch via Theme)
//  Stunden-Card:     color: c.component
//  Input-Felder:     color: c.raised
//
//  Vertretungs-Tile:
//  Container(
//    decoration: BoxDecoration(
//      color: c.lessonChangedBg,
//      border: Border(left: BorderSide(color: c.lessonChangedBorder, width: 3)),
//      borderRadius: BorderRadius.circular(10),
//    ),
//  )
//
//  Ausfall-Tile:
//  Container(
//    decoration: BoxDecoration(
//      color: c.lessonCancelledBg,
//      border: Border(left: BorderSide(color: c.lessonCancelledBorder, width: 3)),
//      borderRadius: BorderRadius.circular(10),
//    ),
//  )
//
//  "aktuell"-Badge:
//  Container(
//    color: c.freshBadgeBg,
//    child: Text('aktuell', style: TextStyle(color: c.freshBadge)),
//  )