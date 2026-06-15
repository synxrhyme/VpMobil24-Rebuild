import 'package:flutter/material.dart';
import 'package:vpmobil_wrapper/theme.dart';
import 'package:vpmobil_wrapper/utils/vpmobil_parser.dart';

class PeriodWidget extends StatelessWidget {
  final List<Period> periods; // ← statt einzelner Period

  const PeriodWidget({super.key, required this.periods});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppColors>()!;
    final first = periods.first;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        color: theme.component,
        borderRadius: BorderRadius.circular(10)
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight( // ← passt Höhe dynamisch an
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: theme.border,
                  ),
                  left: BorderSide(
                    color: theme.border,
                  ),
                  bottom: BorderSide(
                    color: theme.border,
                  ),
                ),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), topLeft: Radius.circular(10))
              ),
              width: 100,
              padding: EdgeInsets.only(top: 7, bottom: 7),
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
        
            // Trennlinie zwischen Links und Rechts
            //VerticalDivider(color: theme.border, width: 1, thickness: 1),
        
            // Rechte Spalte: Ein Block pro Fach
            Expanded(
              child: Column(
                children: [
                  for (int i = 0; i < periods.length; i++) ...[
                    if (i > 0) Divider(color: theme.border, height: 1, thickness: 1),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
                          color: rowColor(periods[i], theme)["background"]!,
                          border: Border.all(color: rowColor(periods[i], theme)["border"]!, width: 1)
                        ),
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: periods[i].lehrerKuerzel.isNotEmpty && periods[i].raum.isNotEmpty ?
                                  MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: periods[i].lehrerKuerzel.isNotEmpty && periods[i].raum.isNotEmpty ? EdgeInsets.only(left: 20) : null,
                                    child: Text(periods[i].fachKuerzel, style: TextStyle(color: theme.textPrimary))
                                  ),
                                  if (periods[i].lehrerKuerzel.isNotEmpty) Text(periods[i].lehrerKuerzel, style: TextStyle(color: theme.textSecondary)),
                                  if (periods[i].raum.isNotEmpty) Container(
                                    padding: EdgeInsets.only(right: 20),
                                    child: Text(periods[i].raum, style: TextStyle(color: theme.textSecondary), textAlign: TextAlign.center, )
                                  ),
                                ],
                              ),
                              if (periods[i].hinweis.isNotEmpty) Text(periods[i].hinweis, style: TextStyle(color: theme.textPrimary))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}