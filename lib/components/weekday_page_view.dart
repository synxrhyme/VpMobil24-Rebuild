import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vpmobil_wrapper/components/period_widget.dart';
import 'package:vpmobil_wrapper/utils/data_provider.dart';
import 'package:xml/xml.dart';

class WeekdayPageView extends StatefulWidget {
  final PageController pageController;
  final String title;

  const WeekdayPageView({super.key, required this.pageController, required this.title});

  @override
  State<WeekdayPageView> createState() => WeekdayPageViewState();
}

class WeekdayPageViewState extends State<WeekdayPageView> {
  Map<DateTime, XmlDocument?> data = {};
  late final List<DateTime> weekdayDates;

  @override
  void initState() {
    super.initState();
    data = context.read<DataProvider>().data;

    //final DateTime today = DateTime.now();
    //final DateTime startDate = today.subtract(Duration(days: 10));
    //if (today.weekday == DateTime.saturday) startDate.subtract(Duration(days: 1));
    //if (today.weekday == DateTime.sunday)   startDate.subtract(Duration(days: 2));
    //final DateTime endDate = today.add(Duration(days: 7));

    //weekdayDates = generateWeekdaysInRange(startDate, endDate);
  }

  void jumpToToday() {
    final DateTime today = DateTime.now();
    int initialPage = 0;

    if (today.weekday != DateTime.saturday && today.weekday != DateTime.sunday) {
      initialPage = weekdayDates.indexWhere((day) =>
        day.year == today.year &&
        day.month == today.month &&
        day.day == today.day
      );
    }
    else if (today.weekday == DateTime.saturday) {
      initialPage = weekdayDates.indexWhere((day) =>
        day.year == today.year &&
        day.month == today.month &&
        day.day == today.day + 2
      );
    }
    else if (today.weekday == DateTime.sunday) {
      initialPage = weekdayDates.indexWhere((day) =>
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
    return PageView.builder(
      controller: widget.pageController,
      itemCount: weekdayDates.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final date = weekdayDates[index];
        final weekdayName = DateFormat('EEEE', 'de_DE').format(date);
        final readableFormattedDate = DateFormat('dd.MM.yyyy').format(date);
        final formattedDate = DateFormat("yyyyMMdd").format(date);
    
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 15),
              height: 80,
              color: Color.fromARGB(255, 15, 15, 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ShaderMask(
                    blendMode: BlendMode.srcATop,
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [
                        const Color.fromARGB(255, 0, 255, 30).withAlpha(125),
                        const Color.fromARGB(255, 242, 255, 0).withAlpha(125),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds),
                    child: Text(
                      weekdayName,
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontFamily: "Space Grotesk",
                      ),
                    ),
                  ),
                  Text(
                    readableFormattedDate,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white.withAlpha(200),
                      fontFamily: "Space Grotesk",
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 10),
                child: data.containsKey(formattedDate) ?
                
                Consumer<DataProvider>(
                  builder: (context, dataProvider, child) {
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: dataProvider.classes.length,
                      itemBuilder: (context, periodIndex) {
                        return PeriodWidget(
                          period: periodIndex + 1,
                          className: widget.title,
                        );
                      },
                    );
                  },
                )

                :

                Center(
                  child: Container(
                    width: 275,
                    height: 100,
                    margin: EdgeInsets.only(bottom: 200),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 20, 20, 20),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 25),
                          child: Icon(
                            Icons.warning_rounded,
                            color: Colors.orange,
                            size: 35
                          ),
                        ),
                        Text(
                          "Keine Daten geladen",
                          style: TextStyle(
                            color: Colors.white.withAlpha(200),
                            fontFamily: "Space Grotesk"
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ),
            ),
          ],
        );
      },
    );
  }
}