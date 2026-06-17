import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vpmobil_wrapper/theme.dart';
import 'package:vpmobil_wrapper/utils/selected_class_subjects.dart';

class SavedClassListTile extends StatelessWidget {
  final String title;
  final String fachKuerzel;
  final String lehrerKuerzel;
  final int nummer;
  final int index;

  const SavedClassListTile({super.key, required this.title, required this.fachKuerzel, required this.lehrerKuerzel, required this.nummer, required this.index});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppColors>()!;

    return Consumer<SelectedClassSubjects>(
      builder: (context, selectedClassSubjects, _) {
        return GestureDetector(
          onTap: () async {
            selectedClassSubjects.setSelected(title, nummer, !selectedClassSubjects.isSelected(title, nummer));
            await selectedClassSubjects.saveData(context);
          },
          child: Container(
            child: index == 0 || index % 2 == 0 ? 
              Container(
                padding: EdgeInsets.only(right: 15),
                decoration: BoxDecoration(
                  border: Border(right: BorderSide(color: theme.border, width: 0.5))
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("$fachKuerzel ($lehrerKuerzel)", style: TextStyle(fontFamily: "Geist", fontSize: 16, letterSpacing: 0.5, color: theme.textPrimary)),
                    SizedBox(width: 7),
                    Checkbox(value: selectedClassSubjects.isSelected(title, nummer),
                      onChanged: (event) async {
                        selectedClassSubjects.setSelected(title, nummer, !selectedClassSubjects.isSelected(title, nummer));
                        await selectedClassSubjects.saveData(context);
                      },
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ],
                ),
              )
          
              :
          
              Container(
                padding: EdgeInsets.only(left: 15),
                decoration: BoxDecoration(
                  border: Border(left: BorderSide(color: theme.border, width: 0.5))
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(value: selectedClassSubjects.isSelected(title, nummer),
                      onChanged: (event) async {
                        selectedClassSubjects.setSelected(title, nummer, !selectedClassSubjects.isSelected(title, nummer));
                        await selectedClassSubjects.saveData(context);
                      },
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    SizedBox(width: 7),
                    Text("$fachKuerzel ($lehrerKuerzel)", style: TextStyle(fontFamily: "Geist", fontSize: 16, letterSpacing: 0.5, color: theme.textPrimary)),
                  ],
                ),
              )
          ),
        );
      }
    );
  }
}