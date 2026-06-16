import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vpmobil_wrapper/components/class_button.dart';
import 'package:vpmobil_wrapper/theme.dart';
import 'package:vpmobil_wrapper/utils/data_provider.dart';
import 'package:vpmobil_wrapper/utils/loading_provider.dart';
import 'package:vpmobil_wrapper/utils/saved_classes_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final LoadingService loader;
  late final DataProvider dataProvider;
  String lastUpdate = "";

  @override
  void initState() {
    super.initState();
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
    final theme = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: Container(
            height: 1,
            color: theme.border
          ),
        ),
        backgroundColor: theme.surface,
        title: Row(
          children: [
            Expanded(child: 
              Container(
                margin: EdgeInsets.only(bottom: 10, top: 15),
                child: Text(
                  'Vertretungspläne',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    color: theme.accent,
                    fontFamily: "Space Grotesk"
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: theme.base,
      body: Container(
        margin: EdgeInsets.only(bottom: 140, top: 80),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Consumer<SavedClassesProvider>(
                  builder: (context, savedClassesProvider, _) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        BlankClassWidget(index: 1, isSet: savedClassesProvider.button1Set, title: savedClassesProvider.button1Title),
                        BlankClassWidget(index: 2, isSet: savedClassesProvider.button2Set, title: savedClassesProvider.button2Title),
                      ],
                    );
                  }
                ),
                SizedBox(
                  height: 40,
                ),
                Consumer<SavedClassesProvider>(
                  builder: (context, savedClassesProvider, _) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        BlankClassWidget(index: 3, isSet: savedClassesProvider.button3Set, title: savedClassesProvider.button3Title),
                        BlankClassWidget(index: 4, isSet: savedClassesProvider.button4Set, title: savedClassesProvider.button4Title),
                      ],
                    );
                  }
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Consumer<DataProvider>(
                  builder: (context, dataProvider, _) {
                    if (dataProvider.lastRefresh == null) return Text("Daten wurden noch nicht geladen", textAlign: TextAlign.center, style: TextStyle(fontSize: 15, color: Colors.white, fontFamily: "Geist"));
        
                    String formattedDate = "${dataProvider.lastRefresh!.day.toString().padLeft(2, '0')}.${dataProvider.lastRefresh!.month.toString().padLeft(2, '0')}.${dataProvider.lastRefresh!.year.toString()} ${dataProvider.lastRefresh!.hour.toString().padLeft(2, '0')}:${dataProvider.lastRefresh!.minute.toString().padLeft(2, '0')}:${dataProvider.lastRefresh!.second.toString().padLeft(2, '0')}";
                    return Text("Letzte Aktualisierung: $formattedDate", textAlign: TextAlign.center, style: TextStyle(fontSize: 15, color: Colors.white, fontFamily: "Geist"));
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
                    backgroundColor: theme.component,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text("Aktualisieren", style: TextStyle(fontFamily: "Geist", fontSize: 15, letterSpacing: 0.5)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}