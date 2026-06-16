import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vpmobil_wrapper/pages/class_selector_list.dart';
import 'package:vpmobil_wrapper/pages/timetable_page.dart';
import 'package:vpmobil_wrapper/theme.dart';
import 'package:vpmobil_wrapper/utils/saved_classes_provider.dart';
import 'package:vpmobil_wrapper/utils/data_provider.dart';
import 'package:vpmobil_wrapper/utils/snackbar_utils.dart';

class BlankClassWidget extends StatelessWidget {
  final int index;
  final bool isSet;
  final String title;

  const BlankClassWidget({
    super.key,
    required this.index, required this.isSet, required this.title
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppColors>()!;

    return GestureDetector(
      onTap: () async {
        if (!context.mounted) return;

        if (context.read<DataProvider>().lastRefresh == null) {
          showErrorNoDataSnackbar();
          return;
        }

        List<String> classes = context.read<DataProvider>().classes;

        await Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => isSet ? TimetablePage(title: title) : ClassSelectorList(buttonSourceIndex: index, classList: classes),
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
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color: theme.surface,
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
                  color: theme.textPrimary,
                  fontSize: 21,
                  fontFamily: 'JetBrains Mono',
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () async {
                  if (!context.mounted) return;
                  context.read<SavedClassesProvider>().edit("$index", false);
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

        Icon(Icons.add_rounded, size: 38, color: theme.accent.withAlpha(100)),
      ),
    );
  }
}