import 'package:flutter/material.dart';
import 'package:vpmobil_wrapper/components/class_list_tile.dart';

class ClassSelectorList extends StatelessWidget {
  final int buttonSourceIndex;
  final List<String> classList;

  const ClassSelectorList({super.key, required this.buttonSourceIndex, required this.classList});

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
        title: Text('Klasse auswählen', style: TextStyle(color: Colors.white.withAlpha(200)),),
        backgroundColor: Color.fromARGB(255, 15, 15, 15)
      ),
      backgroundColor: Color.fromARGB(255, 5, 5, 5),
      body: Center(
        child: ListView.builder(
          itemCount: classList.length,
          itemBuilder: (context, index) {
            final String className = classList[index];

            return ClassListTile(title: className, buttonSourceIndex: buttonSourceIndex);
          },
        )
      ),
    );
  }
}