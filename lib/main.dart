import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';

import 'screens/home/splash_screen.dart';

import 'providers/category_provider.dart';
import 'repositories/category_repository.dart';
import 'services/category_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// =========================
  /// LOAD ENV FILE SAFELY
  /// =========================
  try {
    await dotenv.load(fileName: ".env");
    debugPrint("✅ ENV loaded successfully");
  } catch (e) {
    debugPrint("❌ ENV load error: $e");
  }

  /// =========================
  /// VALIDATE API URL
  /// =========================
  final apiUrl = dotenv.env['API_URL'];

  if (apiUrl == null || apiUrl.isEmpty) {
    throw Exception("❌ API_URL is missing in .env file");
  }

  debugPrint("🌐 API URL: $apiUrl");

  /// =========================
  /// SETUP DIO
  /// =========================
  final dio = Dio(
    BaseOptions(
      baseUrl: apiUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  /// =========================
  /// LAYERS
  /// =========================
  final categoryService = CategoryService(dio: dio);
  final categoryRepository =
      CategoryRepository(categoryService: categoryService);

  /// =========================
  /// RUN APP
  /// =========================
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CategoryProvider(
            repository: categoryRepository,
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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