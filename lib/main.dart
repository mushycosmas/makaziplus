// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';  // ✅ Riverpod only
import 'package:dio/dio.dart';

import 'screens/home/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");
    debugPrint("✅ ENV loaded successfully");
  } catch (e) {
    debugPrint("❌ ENV load error: $e");
  }

  final apiUrl = dotenv.env['API_URL'];
  if (apiUrl == null || apiUrl.isEmpty) {
    throw Exception("❌ API_URL is missing in .env file");
  }
  debugPrint("🌐 API URL: $apiUrl");

  runApp(
    /// ✅ WRAP WITH ProviderScope FOR RIVERPOD
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MakaziPlus',
      theme: ThemeData(
        primaryColor: const Color(0xFF22C55E),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF22C55E),
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}