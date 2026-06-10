import 'package:flutter/material.dart';
import 'package:vpmobil_wrapper/components/weekday_page_view.dart';
import 'package:vpmobil_wrapper/pages/subject_select_page.dart';

class TimetablePage extends StatefulWidget {
  final int index;
  final String title;

  const TimetablePage({super.key, required this.index, required this.title});

  @override
  State<TimetablePage> createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  late final PageController _pageController;
  final GlobalKey<WeekdayPageViewState> childKey = GlobalKey<WeekdayPageViewState>();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {    
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: Colors.white.withAlpha(200)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            Text('Stundenplan ${widget.title}', style: TextStyle(color: Colors.white.withAlpha(200), fontWeight: FontWeight.w500)),
            IconButton(
              icon: Icon(Icons.home_rounded),
              onPressed: () {
                childKey.currentState?.jumpToToday();
              },
            ),
          ],
        ),
        backgroundColor: Color.fromARGB(255, 15, 15, 15),
      ),
      backgroundColor: Color.fromARGB(255, 5, 5, 5),
      body: Column(
        children: [
          Container(
            height: 65,
            padding: EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 15, 15, 15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromARGB(255, 25, 25, 25),
                      ),
                      child: Text("letzter tag", style: TextStyle(color: Colors.white.withAlpha(200))),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    await Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) => SubjectSelectPage(class_: widget.title),
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
                            child: SlideTransition(
                              position: secondaryAnimation.drive(outAnimation),
                              child: child,
                            ),
                          );
                        },
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 25, 25, 25),
                      shape: BoxShape.circle
                    ),
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.person_rounded, color: Colors.white.withAlpha(200), size: 25),
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
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromARGB(255, 25, 25, 25),
                      ),
                      child: Text("nächster tag", style: TextStyle(color: Colors.white.withAlpha(200))),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: WeekdayPageView(pageController: _pageController, title: widget.title, key: childKey),
          ),
        ],
      ),
    );
  }
}