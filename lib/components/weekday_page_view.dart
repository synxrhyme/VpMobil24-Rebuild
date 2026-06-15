import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vpmobil_wrapper/components/period_widget.dart';
import 'package:vpmobil_wrapper/theme.dart';
import 'package:vpmobil_wrapper/utils/data_provider.dart';
import 'package:vpmobil_wrapper/utils/time_utils.dart';
import 'package:vpmobil_wrapper/utils/vpmobil_parser.dart';
import 'package:xml/xml.dart';

class WeekdayPageView extends StatefulWidget {
  final PageController pageController;
  final List<DateTime> weekdayDates;
  final String title;

  const WeekdayPageView({super.key, required this.weekdayDates, required this.pageController, required this.title});

  @override
  State<WeekdayPageView> createState() => WeekdayPageViewState();
}

class WeekdayPageViewState extends State<WeekdayPageView> {
  Map<DateTime, XmlDocument?> data = {};  

  @override
  void initState() {
    super.initState();
    jumpToToday();
  }

  void jumpToToday() {
    final DateTime today = DateTime.now();
    int initialPage = 0;

    if (today.weekday != DateTime.saturday && today.weekday != DateTime.sunday) {
      initialPage = widget.weekdayDates.indexWhere((day) =>
        day.year == today.year &&
        day.month == today.month &&
        day.day == today.day
      );
    }
    else if (today.weekday == DateTime.saturday) {
      initialPage = widget.weekdayDates.indexWhere((day) =>
        day.year == today.year &&
        day.month == today.month &&
        day.day == today.day + 2
      );
    }
    else if (today.weekday == DateTime.sunday) {
      initialPage = widget.weekdayDates.indexWhere((day) =>
        day.year == today.year &&
        day.month == today.month &&
        day.day == today.day + 1
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (initialPage != -1) widget.pageController.jumpToPage(initialPage);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppColors>()!;

    return PageView.builder(
      controller: widget.pageController,
      itemCount: widget.weekdayDates.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Consumer<DataProvider>(
          builder: (context, dataProvider, child) {
            return Container(
              margin: const EdgeInsets.only(top: 10),
              child: dataProvider.data.containsKey(widget.weekdayDates[index]) ?
                  Consumer<DataProvider>(
                    builder: (context, dataProvider, _) {
                      int page = (widget.pageController.page ?? 0).round();
                      DateTime date = widget.weekdayDates[page];

                      XmlDocument? dayPlan = dataProvider.data[date];
                      if (dayPlan == null) return Text("fuck yourself");

                      final XmlElement klasse = dayPlan
                          .getElement('VpMobil')!
                          .getElement('Klassen')!
                          .findElements('Kl')
                          .where((element) { return element.getElement("Kurz")!.innerText == widget.title; }).first;

                      List<Period> periods = [];

                      for (XmlElement period in klasse.getElement("Pl")!.findElements("Std")) {
                        final SubjectChange fachAenderung = parseFaAe(period);
                        final TeacherChange? lehrerAenderung = parseLeAe(period);
                        final RoomChange? raumAenderung = parseRaAe(period);

                        final Period createdPeriod = Period(
                          stunde: int.parse(period.getElement('St')!.innerText),
                          beginn: parseTimeOfDay(period.getElement('Beginn')!.innerText),
                          ende: parseTimeOfDay(period.getElement('Ende')!.innerText),
                          fachKuerzel: period.getElement('Fa')!.innerText,
                          lehrerKuerzel: period.getElement('Le')!.innerText,
                          raum: period.getElement('Ra')!.innerText,
                          unterrichtNummer: int.parse(period.getElement('Nr')?.innerText ?? "0"),

                          fachAenderung: fachAenderung,
                          lehrerAenderung: lehrerAenderung,
                          raumAenderung: raumAenderung,

                          geaendertesFach: period.getElement('Fa')?.getAttribute('FaAe'),
                          geaenderterLehrer: period.getElement('Le')?.getAttribute('LeAe'),
                          geaenderterRaum: period.getElement('Ra')?.getAttribute('RaAe'),

                          hinweis: period.getElement('If')?.innerText ?? "",
                        );

                        periods.add(createdPeriod);
                      }

                      final Map<int, List<Period>> grouped = {};
                      for (final period in periods) {
                        grouped.putIfAbsent(period.stunde, () => []).add(period);
                      }

                      final List<List<Period>> groupedPeriods = grouped.values.toList();
                      
                      return ListView.builder(
                        physics: ScrollPhysics(),
                        itemCount: groupedPeriods.length,
                        itemBuilder: (context, periodIndex) {
                          return PeriodWidget(periods: groupedPeriods[periodIndex]);
                        },
                      );
                    },
                  )
                  
                  :
                  
                  Center(
                    child: Container(
                      width: 275,
                      height: 100,
                      margin: const EdgeInsets.only(bottom: 200),
                      decoration: BoxDecoration(
                        color: theme.surface,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 25),
                            child: Icon(
                              Icons.warning_rounded,
                              color: theme.notice,
                              size: 35,
                            ),
                          ),
                          Text(
                            "Keine Daten geladen",
                            style: TextStyle(
                              color: theme.notice,
                              fontFamily: "Space Grotesk",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            );
          },
        );
      },
    );
  }
}