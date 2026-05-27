import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get baseUrl {
    final url = dotenv.env['API_URL'];

    if (url == null || url.isEmpty) {
      throw Exception("API_URL is missing in .env file");
    }

    return url;
  }
}