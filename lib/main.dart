//main

// Flutter関連のインポート / Import Flutter packages
import 'package:flutter/material.dart';
// Firebase関連のインポート / Import Firebase packages
import 'package:firebase_core/firebase_core.dart';
// Provider関連のインポート / Import Provider
import 'package:provider/provider.dart';
// PostProviderを含むモデル / Model file containing PostProvider
import 'models/post_model.dart';
// Firebase設定ファイル / Firebase configuration file
import 'firebase_options.dart';
// ホーム画面 / Home screen
import 'home_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'language_provider.dart';
import 'package:workmanager/workmanager.dart';
import 'package:river_stream_unlimited_tech/generated/l10n.dart';
import 'package:river_stream_unlimited_tech/services/notifications_services.dart.dart';
import 'package:river_stream_unlimited_tech/services/getlocation.dart';
import 'package:river_stream_unlimited_tech/services/getbeststation.dart';
import 'package:river_stream_unlimited_tech/services/getobservations.dart';
import 'package:river_stream_unlimited_tech/services/getweekresume.dart';
import 'package:river_stream_unlimited_tech/services/ai_risk_calculation.dart';
import 'package:river_stream_unlimited_tech/settings_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  // Flutterエンジンを初期化 / Initialize the Flutter engine
  WidgetsFlutterBinding.ensureInitialized();

  // Firebaseを初期化 / Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Cargar preferencias de usuario
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isBackgroundTaskEnabled = prefs.getBool('background_task') ?? false;

  // Inicializar WorkManager solo si la opción está activada
  await Workmanager().initialize(callbackDispatcher);

  if (isBackgroundTaskEnabled) {
    await Workmanager().registerPeriodicTask(
      "task",
      "task",
      frequency: Duration(minutes: 180),
    );
  }

  // PostProviderを使うためにChangeNotifierProviderでラップ / Wrap with ChangeNotifierProvider to use PostProvider
  LanguageProvider languageProvider = LanguageProvider();
  await languageProvider.loadLanguage(); // Cargar idioma guardado

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PostProvider()),
        ChangeNotifierProvider(create: (_) => languageProvider),
        ChangeNotifierProvider(create: (_) => SettingsProvider()), // Agregado
      ],
      child: const MyApp(),
    ),
  );
}

// メインアプリウィジェット / Main app widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        final _currentLocale = languageProvider.currentLocale;
        return MaterialApp(
          title: 'River App',
          theme: ThemeData(primarySwatch: Colors.blue),
          locale: _currentLocale,
          localizationsDelegates: [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'), // English
            Locale('es'), // Spanish
            Locale('ja'),
          ],
          debugShowCheckedModeBanner: false,
          home: const HomePage(),
        );
      },
    );
  }
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      print('starting');
      await getUserPosition();
      print('ubicación obtenida');
      await getNearestUserStation();
      print('estación meteorológica obtenida');
      await getuserobservations();
      print('obtenidos datos de las estaciones meteorológicas');
      await getUserWeekData();
      print('datos obtenidos de la semana');
      await loadModel();
      print('el modelo se cargó correctamente');
      await calculateRisk();
      print('riesgo calculado correctamente');

      if (risk.isNotEmpty && risk == 'HIGH') {
        await showNotification();
      } else {
        print('error');
      }

      return Future.value(true);
    } catch (e) {
      print("error: $e");
      return Future.value(false);
    }
  });
}
