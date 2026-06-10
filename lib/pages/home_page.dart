import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vpmobil_wrapper/components/class_widget.dart';
import 'package:vpmobil_wrapper/utils/data_provider.dart';
import 'package:vpmobil_wrapper/utils/loading_provider.dart';
import 'package:vpmobil_wrapper/utils/preferences_utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final LoadingService loader;
  late final DataProvider dataProvider;
  String lastUpdate = "";

  String button1Title = "";
  String button2Title = "";
  String button3Title = "";
  String button4Title = "";

  bool button1Set = false;
  bool button2Set = false;
  bool button3Set = false;
  bool button4Set = false;

  void reloadButtonTitles() async {
    final t1 = await getString("selected_class_button_1");
    final t2 = await getString("selected_class_button_2");
    final t3 = await getString("selected_class_button_3");
    final t4 = await getString("selected_class_button_4");

    setState(() {
      button1Title = t1;
      button1Set   = t1 != "";

      button2Title = t2;
      button2Set   = t2 != "";

      button3Title = t3;
      button3Set   = t3 != "";

      button4Title = t4;
      button4Set   = t4 != "";
    });
  }

  @override
  void initState() {
    super.initState();
    reloadButtonTitles();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    dataProvider = context.read<DataProvider>();
    loader = context.read<LoadingService>();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: Color.fromARGB(255, 15, 15, 15),
        title: Row(
          children: [
            Expanded(child: 
              Container(
                margin: EdgeInsets.only(bottom: 10, top: 15),
                child: Text(
                  'Vertretungspläne',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 23,
                    color: const Color.fromARGB(255, 208, 255, 0).withAlpha(200),
                    fontFamily: "Space Grotesk"
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Color.fromARGB(255, 5, 5, 5),
      body: Column(
        children: [
          SizedBox(
            height: 100,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BlankClassWidget(index: 1, title: button1Title, isSet: button1Set, onClassChanged: reloadButtonTitles),
              BlankClassWidget(index: 2, title: button2Title, isSet: button2Set, onClassChanged: reloadButtonTitles),
            ],
          ),
          SizedBox(
            height: 100,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BlankClassWidget(index: 3, title: button3Title, isSet: button3Set, onClassChanged: reloadButtonTitles),
              BlankClassWidget(index: 4, title: button4Title, isSet: button4Set, onClassChanged: reloadButtonTitles),
            ],
          ),
          SizedBox(
            height: 100,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Consumer<DataProvider>(
                builder: (context, dataProvider, _) {
                  return Text("Letzte Aktualisierung: $lastUpdate", textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: Colors.white, fontFamily: "Space Grotesk"));
                }
              ),
              SizedBox(height: 25),
              ElevatedButton(
                onPressed: () async {
                  loader.show();
                  await dataProvider.reload();
                  loader.hide();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 20, 20, 20),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text("Aktualisieren", style: TextStyle(fontFamily: "Space Grotesk")),
              )
            ],
          )
        ],
      ),
    );
  }
}