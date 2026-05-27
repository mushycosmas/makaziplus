import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';

import 'screens/home/splash_screen.dart';

import 'providers/category_provider.dart';
import 'providers/property_provider.dart';

import 'repositories/category_repository.dart';
import 'repositories/property_repository.dart';

import 'services/category_service.dart';
import 'services/property_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// =========================
  /// LOAD ENV FILE
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
  /// DIO SETUP
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
  /// SERVICES
  /// =========================
  final categoryService = CategoryService(dio: dio);
  final propertyService = PropertyService(dio: dio);

  /// =========================
  /// REPOSITORIES
  /// =========================
  final categoryRepository =
      CategoryRepository(categoryService: categoryService);

  final propertyRepository =
      PropertyRepository(service: propertyService);

  /// =========================
  /// RUN APP
  /// =========================
  runApp(
    MultiProvider(
      providers: [
        /// CATEGORY PROVIDER
        ChangeNotifierProvider(
          create: (_) => CategoryProvider(
            repository: categoryRepository,
          ),
        ),

        /// PROPERTY PROVIDER (🔥 FIXED)
        ChangeNotifierProvider(
          create: (_) => PropertyProvider(
            repository: propertyRepository,
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