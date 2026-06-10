import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:vpmobil_wrapper/pages/home_page.dart';
import 'package:vpmobil_wrapper/utils/data_provider.dart';
import 'package:vpmobil_wrapper/utils/loading_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final String user = dotenv.get("user");
final String password = dotenv.get("password");
final String school_number = dotenv.get("school_number");

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
final GlobalKey<NavigatorState> navigatorKey                     = GlobalKey<NavigatorState>();

final LoadingService loader = LoadingService();
late final DataProvider dataProvider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('de_DE', null);

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint(details.exceptionAsString());
  };

  dataProvider = DataProvider();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: loader),
        ChangeNotifierProvider.value(value: dataProvider),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      navigatorKey: navigatorKey,
      title: 'Stundenplan',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      home: Stack(
        children: [
          HomePage(),

          Consumer<LoadingService>(
            builder: (context, loadingService, _) {
              if (!loadingService.isLoading) return const SizedBox.shrink();
        
              return Container(
                color: Colors.black54,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.blueAccent,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}