import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vpmobil_wrapper/components/saved_class_list_tile.dart';
import 'package:vpmobil_wrapper/theme.dart';
import 'package:vpmobil_wrapper/utils/choosable_subject.dart';
import 'package:vpmobil_wrapper/utils/data_provider.dart';
import 'package:vpmobil_wrapper/utils/selected_class_subjects.dart';

class SubjectSelectPage extends StatefulWidget {
  final String title;
  
  const SubjectSelectPage({super.key, required this.title});
  
  @override
  State<SubjectSelectPage> createState() => _SubjectSelectPageState();
}

class _SubjectSelectPageState extends State<SubjectSelectPage> {
  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await context.read<SelectedClassSubjects>().reload(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: theme.textPrimary),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Fächer auswählen für ${widget.title}', style: TextStyle(color: theme.textPrimary, fontFamily: "Geist", fontSize: 19, fontWeight: FontWeight.w500)),
        backgroundColor: theme.surface,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: Container(
            height: 1,
            color: theme.border
          ),
        ),
      ),
      backgroundColor: theme.base,
      body: Column(
        children: [
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 120,
                child: ElevatedButton(
                  onPressed: () {
                    SelectedClassSubjects selectedClassSubjects = context.read<SelectedClassSubjects>();
                    selectedClassSubjects.setAllInClass(context, widget.title, true);
                    selectedClassSubjects.saveData(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.component,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  child: Text("Alle", style: TextStyle(color: theme.accent, fontFamily: "Geist", fontSize: 19, fontWeight: FontWeight.w500))),
              ),
              SizedBox(
                width: 120,
                child: ElevatedButton(
                  onPressed: () {
                    SelectedClassSubjects selectedClassSubjects = context.read<SelectedClassSubjects>();
                    selectedClassSubjects.setAllInClass(context, widget.title, false);
                    selectedClassSubjects.saveData(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.component,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  child: Text("Keine", style: TextStyle(color: theme.accent, fontFamily: "Geist", fontSize: 19, fontWeight: FontWeight.w500))),
              )
            ],
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 30, left: 10, right: 10),
              child: Consumer<DataProvider>(
                builder: (context, dataProvider, _) {
                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 2 Spalten
                      childAspectRatio: 3, // Breite/Höhe anpassen
                    ),
                    itemCount: dataProvider.subjectsForClasses[widget.title]?.length ?? 0,
                    itemBuilder: (context, index) {
                      final ChoosableSubject subject = dataProvider.subjectsForClasses[widget.title]![index];
                      return SavedClassListTile(title: widget.title, fachKuerzel: subject.fachKuerzel, lehrerKuerzel: subject.lehrerKuerzel, nummer: subject.nummer, index: index);
                    },
                  );
                }
              ),
            )
          )
        ]
      )
    );
  }
}