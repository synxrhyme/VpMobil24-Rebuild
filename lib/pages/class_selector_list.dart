import 'package:flutter/material.dart';
import 'package:vpmobil_wrapper/components/class_list_tile.dart';
import 'package:vpmobil_wrapper/theme.dart';

class ClassSelectorList extends StatelessWidget {
  final int buttonSourceIndex;
  final List<String> classList;

  const ClassSelectorList({super.key, required this.buttonSourceIndex, required this.classList});

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
        title: Text('Klasse auswählen', style: TextStyle(color: theme.textPrimary),),
        backgroundColor: theme.surface
      ),
      backgroundColor: theme.base,
      body: Center(
        child: ListView.separated(
          itemCount: classList.length,
          itemBuilder: (context, index) {
            final String className = classList[index];
            return ClassListTile(title: className, buttonSourceIndex: buttonSourceIndex);
          },
          separatorBuilder: (context, index) {
            final theme = Theme.of(context).extension<AppColors>()!;
            return Align(
              alignment: Alignment.center,
              child: FractionallySizedBox(
                widthFactor: 1,
                child: Divider(
                  height: 1,
                  thickness: 0.5,
                  color: theme.border,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}