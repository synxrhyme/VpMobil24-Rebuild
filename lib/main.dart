import 'dart:async';
import 'dart:ui' show PlatformDispatcher;
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:vpmobil_wrapper/pages/home_page.dart';
import 'package:vpmobil_wrapper/utils/log_buffer.dart';
import 'package:vpmobil_wrapper/utils/saved_classes_provider.dart';
import 'package:vpmobil_wrapper/utils/data_provider.dart';
import 'package:vpmobil_wrapper/utils/init_service.dart';
import 'package:vpmobil_wrapper/utils/loading_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:vpmobil_wrapper/theme.dart';
import 'package:vpmobil_wrapper/utils/selected_class_subjects.dart';

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await initializeDateFormatting('de_DE', null);
      await dotenv.load();

      final initService = InitService();
      final dataProvider = DataProvider();
      final classesProvider = SavedClassesProvider();
      final selectedClassSubjects = SelectedClassSubjects();
      final loadingService = LoadingService();

      initService.register(dataProvider.ready);
      initService.register(classesProvider.ready);

      final readyFuture = initService.start();
      FlutterError.onError = (FlutterErrorDetails details) {
        FlutterError.presentError(details);
        debugPrint(details.exceptionAsString());
      };

      PlatformDispatcher.instance.onError = (error, stack) {
        LogBuffer.instance.add('Unbehandelter Fehler: $error\n$stack');
        return true;
      };

      runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: loadingService),
            ChangeNotifierProvider.value(value: dataProvider),
            ChangeNotifierProvider.value(value: classesProvider),
            ChangeNotifierProvider.value(value: selectedClassSubjects),
            Provider<Future<void>>.value(value: readyFuture),
          ],
          child: MyApp(),
        ),
      );
    },
    (error, stack) {
      LogBuffer.instance.add('Zonenfehler: $error\n$stack');
    },
    zoneSpecification: ZoneSpecification(
      print: (self, parent, zone, line) {
        LogBuffer.instance.add(line); // erfasst print UND debugPrint
        parent.print(zone, line); // zusätzlich weiter an logcat
      },
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
      builder: (context, child) {
        final theme = Theme.of(context).extension<AppColors>()!;

        return Stack(
          children: [
            if (child != null) child,

            Consumer<LoadingService>(
              builder: (context, loadingService, _) {
                if (!loadingService.isLoading) return const SizedBox.shrink();

                return IgnorePointer(
                  child: Container(
                    color: theme.base.withAlpha(200),
                    child: Center(
                      child: CircularProgressIndicator(color: theme.accent),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

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
              child: CircularProgressIndicator(color: theme.accent),
            ),
          );
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.read<SelectedClassSubjects>().reload(context);
        });

        return const HomePage();
      },
    );
  }
}
