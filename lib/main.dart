import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'core/theme/thebes_theme.dart';
import 'core/localization/locale_provider.dart';
import 'core/di/service_locator.dart';
import 'features/student/presentation/controllers/student_controller.dart';
import 'features/app/presentation/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServiceLocator();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => sl<StudentController>()),
      ],
      child: const ThebesAcademyApp(),
    ),
  );
}

class ThebesAcademyApp extends StatelessWidget {
  const ThebesAcademyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();

    return MaterialApp(
      title: 'أكاديمية طيبة - Thebes Academy',
      debugShowCheckedModeBanner: false,
      locale: localeProvider.locale,
      themeMode: localeProvider.themeMode,
      theme: ThebesTheme.lightTheme,
      darkTheme: ThebesTheme.darkTheme,
      supportedLocales: const [
        Locale('ar', ''),
        Locale('en', ''),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const SplashScreen(),
    );
  }
}
