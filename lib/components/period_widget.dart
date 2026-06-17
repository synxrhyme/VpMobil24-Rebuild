import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vpmobil_wrapper/theme.dart';
import 'package:vpmobil_wrapper/utils/selected_class_subjects.dart';
import 'package:vpmobil_wrapper/utils/vpmobil_parser.dart';

class PeriodWidget extends StatelessWidget {
  final String title;
  final List<Period> periods;

  const PeriodWidget({super.key, required this.title, required this.periods});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppColors>()!;
    final first = periods.first;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        color: theme.component,
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Linke Spalte: Stunde + Zeit
            Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: theme.border),
                  top: BorderSide(color: theme.border),
                  bottom: BorderSide(color: theme.border),
                ),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
              ),
              width: 100,
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("${first.stunde}", style: TextStyle(color: theme.textPrimary)),
                  Text(
                    "${first.beginn.hour.toString().padLeft(2, '0')}:${first.beginn.minute.toString().padLeft(2, '0')}"
                    " / ${first.ende.hour.toString().padLeft(2, '0')}:${first.ende.minute.toString().padLeft(2, '0')}",
                    style: TextStyle(color: theme.textSecondary),
                  ),
                ],
              ),
            ),

            // Rechte Spalte: ein Block pro gleichzeitigem Fach, jeweils natürlich groß
            Consumer<SelectedClassSubjects>(
              builder: (context, selectedClassSubjects, _) {
                final visiblePeriods = [
                  for (final p in periods)
                    if (selectedClassSubjects.visibleSubjectsForClasses[title]?[p.unterrichtNummer] ?? true) p
                ];

                return Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (visiblePeriods.isEmpty)
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: theme.component,
                              border: Border.all(color: theme.border),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                            ),
                            child: Center(child: Text("---", style: TextStyle(color: theme.textPrimary))),
                          ),
                        )
                      else
                        for (int i = 0; i < visiblePeriods.length; i++)
                          Builder(
                            builder: (context) {
                              final period = visiblePeriods[i];

                              final child = Container(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                decoration: BoxDecoration(
                                  color: rowColor(period, theme)["background"],
                                  borderRadius: BorderRadius.only(
                                    topRight: i == 0 ? const Radius.circular(10) : Radius.zero,
                                    bottomRight: i == visiblePeriods.length - 1 ? const Radius.circular(10) : Radius.zero,
                                  ),
                                  border: Border(
                                    left: BorderSide(color: rowColor(period, theme)["border"]!),
                                    right: BorderSide(color: rowColor(period, theme)["border"]!),
                                    top: BorderSide(color: rowColor(period, theme)["border"]!),
                                    bottom: i == visiblePeriods.length - 1
                                        ? BorderSide(color: rowColor(period, theme)["border"]!)
                                        : BorderSide.none, // wird von der nächsten Zeile als top übernommen
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: period.lehrerKuerzel.isNotEmpty || period.raum.isNotEmpty
                                          ? MainAxisAlignment.spaceBetween
                                          : MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: period.lehrerKuerzel.isNotEmpty || period.raum.isNotEmpty
                                            ? const EdgeInsets.only(left: 20)
                                            : null,
                                          child: SizedBox(
                                            width: 50,
                                            child: Text(period.fachKuerzel, style: TextStyle(color: theme.textPrimary))
                                          ),
                                        ),
                                        if (period.lehrerKuerzel.isNotEmpty)
                                          Container(
                                            width: 50,
                                            padding: EdgeInsets.only(left: 10),
                                            child: Text(period.lehrerKuerzel, style: TextStyle(color: rowColor(period, theme)["text"]))
                                          ),
                                        if (period.raum.isNotEmpty || (period.lehrerKuerzel.isNotEmpty && period.lehrerKuerzel.isNotEmpty && period.raum.isEmpty))
                                          SizedBox(
                                            width: 75,
                                            child: Container(
                                              padding: const EdgeInsets.only(right: 20),
                                              child: Text(
                                                period.raum,
                                                style: TextStyle(color: rowColor(period, theme)["text"]),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    if (period.hinweis.isNotEmpty)
                                      Text(period.hinweis, style: TextStyle(color: theme.textPrimary)),
                                  ],
                                ),
                              );

                              return visiblePeriods.length == 1 ? Expanded(child: child) : child;
                            }
                          )
                    ],
                  ),
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}