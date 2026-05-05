import 'package:flutter/material.dart';
import 'screens/onboarding_screen.dart';
import 'provider/language_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LanguageProvider().loadSavedLanguage();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final LanguageProvider _languageProvider = LanguageProvider();

  @override
  void dispose() {
    _languageProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LanguageScope(
      provider: _languageProvider,
      child: MaterialApp(
        title: 'Gubug Wayang',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1B233A)),
          useMaterial3: true,
          fontFamily: 'Inter',
        ),
        home: const OnboardingScreen(),
      ),
    );
  }
}
