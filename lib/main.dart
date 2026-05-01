import 'package:flutter/material.dart';
// Mengimpor file onboarding_screen.dart dari folder screens
import 'screens/onboarding_screen.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gubug Wayang',
      debugShowCheckedModeBanner: false, // Menghilangkan pita "DEBUG"
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3A3229)),
        useMaterial3: true,
      ),
      // Memanggil OnboardingScreen sebagai halaman pertama
      home: const OnboardingScreen(),
    );
  }
}