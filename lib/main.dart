import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:vpmobil_wrapper/pages/home_page.dart';
import 'package:vpmobil_wrapper/utils/saved_classes_provider.dart';
import 'package:vpmobil_wrapper/utils/data_provider.dart';
import 'package:vpmobil_wrapper/utils/init_service.dart';
import 'package:vpmobil_wrapper/utils/loading_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:vpmobil_wrapper/theme.dart';
import 'package:vpmobil_wrapper/utils/selected_class_subjects.dart';

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
final GlobalKey<NavigatorState> navigatorKey                     = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('de_DE', null);

  await dotenv.load();

  final initService = InitService();
  final dataProvider = DataProvider();
  final classesProvider = SavedClassesProvider();
  final loadingService = LoadingService();

  initService.register(dataProvider.ready);
  initService.register(classesProvider.ready);

  final readyFuture = initService.start();

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint(details.exceptionAsString());
  };

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: loadingService),
        ChangeNotifierProvider.value(value: dataProvider),
        ChangeNotifierProvider.value(value: classesProvider),
        Provider<Future<void>>.value(value: readyFuture),
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
      theme: vpLightTheme(),
      darkTheme: vpDarkTheme(),
      home: const AppRoot(),
    );
  }
}

class AppRoot extends StatelessWidget {
  const AppRoot({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.read<Future<void>>(),
      builder: (context, asyncSnapshot) {
        final theme = Theme.of(context).extension<AppColors>()!;
        
        if (asyncSnapshot.connectionState != ConnectionState.done) {
          return Container(
            color: theme.base,
            child: Center(
              child: CircularProgressIndicator(
                color: theme.accent,
              ),
            ),
          );
        }

        final visibleClassesProvider = SelectedClassSubjects();
        visibleClassesProvider.reload(context);
    
        return Stack(
          children: [
            HomePage(),
            
            Consumer<LoadingService>(
              builder: (context, loadingService, _) {
                if (!loadingService.isLoading) return const SizedBox.shrink();
          
                return Container(
                  color: theme.base.withAlpha(200),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: theme.accent,
                    ),
                  ),
                );
              },
            ),
          ],
        );
      }
    );
  }
}