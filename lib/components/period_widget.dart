import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vpmobil_wrapper/theme.dart';
import 'package:vpmobil_wrapper/utils/selected_class_subjects.dart';
import 'package:vpmobil_wrapper/utils/vpmobil_parser.dart';

class PeriodWidget extends StatelessWidget {
  final List<Period> periods;

  const PeriodWidget({super.key, required this.periods});

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
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (int i = 0; i < periods.length; i++)
                    //if (context.read<SelectedClassSubjects>().visibleSubjectsForClasses[periods[i].unterrichtNummer] ?? true)
                    Builder(
                      builder: (context) {
                        final child = Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: rowColor(periods[i], theme)["background"],
                            borderRadius: BorderRadius.only(
                              topRight: i == 0 ? const Radius.circular(10) : Radius.zero,
                              bottomRight: i == periods.length - 1 ? const Radius.circular(10) : Radius.zero,
                            ),
                            border: Border(
                              left: BorderSide(color: rowColor(periods[i], theme)["border"]!),
                              right: BorderSide(color: rowColor(periods[i], theme)["border"]!),
                              top: BorderSide(color: rowColor(periods[i], theme)["border"]!),
                              bottom: i == periods.length - 1
                                  ? BorderSide(color: rowColor(periods[i], theme)["border"]!)
                                  : BorderSide.none, // wird von der nächsten Zeile als top übernommen
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: periods[i].lehrerKuerzel.isNotEmpty && periods[i].raum.isNotEmpty
                                    ? MainAxisAlignment.spaceBetween
                                    : MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: periods[i].lehrerKuerzel.isNotEmpty && periods[i].raum.isNotEmpty
                                        ? const EdgeInsets.only(left: 20)
                                        : null,
                                    child: Text(periods[i].fachKuerzel, style: TextStyle(color: theme.textPrimary)),
                                  ),
                                  if (periods[i].lehrerKuerzel.isNotEmpty)
                                    Text(periods[i].lehrerKuerzel, style: TextStyle(color: theme.textSecondary)),
                                  if (periods[i].raum.isNotEmpty)
                                    Container(
                                      padding: const EdgeInsets.only(right: 20),
                                      child: Text(
                                        periods[i].raum,
                                        style: TextStyle(color: theme.textSecondary),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                ],
                              ),
                              if (periods[i].hinweis.isNotEmpty)
                                Text(periods[i].hinweis, style: TextStyle(color: theme.textPrimary)),
                            ],
                          ),
                        );

                        return periods.length == 1
                          ? Expanded(child: child)
                          : child;
                      }
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}