import 'package:flutter/material.dart';
import 'package:vpmobil_wrapper/pages/class_selector_list.dart';
import 'package:vpmobil_wrapper/pages/timetable_page.dart';
import 'package:vpmobil_wrapper/utils/preferences_utils.dart';
import 'package:vpmobil_wrapper/utils/snackbar_utils.dart';

class BlankClassWidget extends StatelessWidget {
  final int index;
  final String title;
  final bool isSet;

  final VoidCallback onClassChanged;

  const BlankClassWidget({
    super.key,
    required this.index,
    required this.title,
    required this.isSet,
    required this.onClassChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (await getString("last_update") == "") {
          showErrorNoDataSnackbar();
          return;
        }

        List<String> classes = await loadList("classes");

        await Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => isSet ? TimetablePage(index: index, title: title) : ClassSelectorList(buttonSourceIndex: index, classList: classes),
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

        onClassChanged();
      },
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 15, 15, 15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: isSet 
      
        ?

        Stack(
          children: [
            Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withAlpha(230),
                  fontSize: 21,
                  fontFamily: 'Space Grotesk',
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () async {
                  await setString("selected_class_button_$index", "");
                  onClassChanged();
                },
                child: Container(
                  padding: EdgeInsets.all(5),
                  color: Colors.transparent,
                  child: Icon(Icons.close_rounded, size: 35, color: const Color.fromARGB(255, 236, 49, 35))
                ),
              ),
            ),
          ],
        )

        :

        Container(
          padding: EdgeInsets.only(bottom: 20),
          child: Column(
            children: [
              Expanded(child: Icon(Icons.add_rounded, size: 50, color: Colors.white.withAlpha(200))),
              Text(
                'Klasse auswählen',
                style: TextStyle(
                  color: Colors.white.withAlpha(230),
                  fontSize: 12,
                  fontFamily: 'Space Grotesk',
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}