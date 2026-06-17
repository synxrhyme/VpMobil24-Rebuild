import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vpmobil_wrapper/components/weekday_page_view.dart';
import 'package:vpmobil_wrapper/pages/subject_select_page.dart';
import 'package:vpmobil_wrapper/theme.dart';
import 'package:vpmobil_wrapper/utils/data_provider.dart';
import 'package:vpmobil_wrapper/utils/time_utils.dart';
import 'package:vpmobil_wrapper/utils/loading_provider.dart';
import 'package:vpmobil_wrapper/utils/snackbar_utils.dart';

class TimetablePage extends StatefulWidget {
  final String title;

  const TimetablePage({super.key, required this.title});

  @override
  State<TimetablePage> createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  final ValueNotifier<int> currentPage = ValueNotifier(0);
  late final PageController _pageController;
  final GlobalKey<WeekdayPageViewState> childKey = GlobalKey<WeekdayPageViewState>();
  late final List<DateTime> weekdayDates;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    DataProvider dataProvider = context.read<DataProvider>();

    currentPage.value = _pageController.initialPage;
    _pageController.addListener(() {
      final page = _pageController.page?.round() ?? 0;

      if (page != currentPage.value) {
        setState(() {
          currentPage.value = page;
        });
      }
    });

    DateTime now = DateTime.now();
    DateTime mondayThisWeek = now.subtract(Duration(days: now.weekday - 1));
    DateTime fridayThisWeek = mondayThisWeek.add(const Duration(days: 4));

    if (dataProvider.newestKnownDate != null &&
        dataProvider.newestKnownDate!.isAfter(DateTime.now()) &&
        dataProvider.savedDates.isNotEmpty &&
        dataProvider.newestKnownDate!.isAfter(mondayThisWeek)
    ) {
      weekdayDates = dataProvider.savedDates;
    }
    else {
      weekdayDates = getWeekdays(mondayThisWeek, fridayThisWeek);
    }
  }

  void nextPage() {
    _pageController.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void previousPage() {
    _pageController.previousPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    currentPage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: Container(
            height: 1,
            color: theme.border
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: theme.textPrimary),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Stundenplan ${widget.title}', style: TextStyle(color: theme.textPrimary, fontFamily: "Geist", fontSize: 19, fontWeight: FontWeight.w500)),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.person, color: theme.accent, fontWeight: FontWeight.bold, size: 22),
                  onPressed: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) => SubjectSelectPage(title: widget.title),
                        transitionDuration: Duration(milliseconds: 300),
                        reverseTransitionDuration: Duration(milliseconds: 300),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          // Animation beim Rein- und Rausgehen
                          final inAnimation = Tween<Offset>(
                            begin: Offset(0.0, 1.0),
                            end: Offset.zero,
                          ).chain(CurveTween(curve: Curves.easeInOut));

                          final outAnimation = Tween<Offset>(
                            begin: Offset.zero,
                            end: Offset(0.0, 1.0),
                          ).chain(CurveTween(curve: Curves.easeInOut));

                          return SlideTransition(
                            position: animation.drive(inAnimation),
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.refresh_rounded, color: theme.accent, fontWeight: FontWeight.w600, size: 22),
                  onPressed: () async {
                    if (!context.mounted) return;
                    context.read<LoadingService>().show();

                    bool success = await context.read<DataProvider>().reload();

                    if (!success && context.mounted) {
                      showErrorNoDataSnackbar();
                    }

                    if (!context.mounted) return;
                    context.read<LoadingService>().hide();
                  },
                ),
              ],
            )
          ],
        ),
        backgroundColor: theme.surface
      ),
      backgroundColor: theme.base,
      body: Column(
        children: [
          Container(
            height: 65,
            padding: EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
              color: theme.base,
            ),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Material(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        _pageController.previousPage(duration: Duration(milliseconds: 250), curve: Curves.easeOut);
                      },
                      borderRadius: BorderRadius.circular(10),
                      splashColor: Color.fromARGB(255, 55, 55, 55),
                      child: Ink(
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 17),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: theme.raised,
                        ),
                        child: Icon(Icons.arrow_left, color: theme.textPrimary),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    child: ValueListenableBuilder<int>(
                      valueListenable: currentPage,
                      builder: (context, index, child) {
                        final date = weekdayDates[index];
                        final weekdayName = DateFormat('EEEE', 'de_DE').format(date);
                        final readableFormattedDate = DateFormat('dd.MM.yyyy').format(date);
                    
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              weekdayName,
                              style: const TextStyle(fontSize: 20),
                            ),
                            Text(
                              readableFormattedDate,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Material(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        _pageController.nextPage(duration: Duration(milliseconds: 250), curve: Curves.easeOut);
                      },
                      borderRadius: BorderRadius.circular(10),
                      splashColor: Color.fromARGB(255, 55, 55, 55),
                      child: Ink(
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 17),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: theme.raised,
                        ),
                        child: Icon(Icons.arrow_right, color: theme.textPrimary),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: WeekdayPageView(weekdayDates: weekdayDates, pageController: _pageController, title: widget.title, key: childKey),
          ),
        ],
      ),
    );
  }
}
