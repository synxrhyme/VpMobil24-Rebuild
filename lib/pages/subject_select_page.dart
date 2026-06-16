import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vpmobil_wrapper/components/saved_class_list_tile.dart';
import 'package:vpmobil_wrapper/theme.dart';
import 'package:vpmobil_wrapper/utils/choosable_subject.dart';
import 'package:vpmobil_wrapper/utils/data_provider.dart';

class SubjectSelectPage extends StatefulWidget {
  final String title;
  
  const SubjectSelectPage({super.key, required this.title});
  
  @override
  State<SubjectSelectPage> createState() => _SubjectSelectPageState();
}

class _SubjectSelectPageState extends State<SubjectSelectPage> {
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
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.component,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
                child: Text("Alle", style: TextStyle(color: theme.accent, fontFamily: "Geist", fontSize: 19, fontWeight: FontWeight.w500))),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.component,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
                child: Text("Keine", style: TextStyle(color: theme.accent, fontFamily: "Geist", fontSize: 19, fontWeight: FontWeight.w500)))
            ],
          ),
          Expanded(
            child: ListView.separated(
              itemCount: context.read<DataProvider>().subjectsForClasses.length,
              itemBuilder: (context, index) {
                final ChoosableSubject subject = context.read<DataProvider>().subjectsForClasses[widget.title]?[index] ?? ChoosableSubject(lehrerKuerzel: "lehrerKuerzel", fachKuerzel: "fachKuerzel", nummer: 123);
                return SavedClassListTile(fachKuerzel: subject.fachKuerzel, lehrerKuerzel: subject.lehrerKuerzel, nummer: subject.nummer);
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
          )
        ],
      )
    );
  }
}