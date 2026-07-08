import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AgentPropertiesApi {
  static const String baseUrl = "https://makazi.nono.co.tz";

  // =========================
  // PRIVATE GET
  // =========================
  static Future<http.Response> _get(
    String endpoint, {
    String? token,
  }) async {
    try {
      final url = Uri.parse("$baseUrl$endpoint");

      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      return await http
          .get(
            url,
            headers: headers,
          )
          .timeout(const Duration(seconds: 30));
    } catch (e) {
      rethrow;
    }
  }

  // =========================
  // GET AGENT DETAILS
  // =========================
  static Future<Map<String, dynamic>> getAgent(
    int agentId, {
    String? token,
  }) async {
    try {
      if (kDebugMode) {
        print("📥 Fetching agent: $agentId");
      }

      final response = await _get(
        "/agents/$agentId",
        token: token,
      );

      if (kDebugMode) {
        print("📡 Status: ${response.statusCode}");
        print("📡 Body: ${response.body}");
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return {
          "success": true,
          "data": data,
        };
      }

      if (response.statusCode == 404) {
        return {
          "success": false,
          "message": "Agent not found",
        };
      }

      return {
        "success": false,
        "message": "Failed to load agent details",
      };
    } catch (e) {
      if (kDebugMode) {
        print("❌ Error: $e");
      }

      return {
        "success": false,
        "message": e.toString(),
      };
    }
  }

  // =========================
  // GET AGENT PROPERTIES
  // =========================
  static Future<Map<String, dynamic>> getAgentProperties(
    int agentId, {
    int page = 1,
    int limit = 20,
    String? token,
  }) async {
    try {
      final query = Uri(
        queryParameters: {
          "page": page.toString(),
          "limit": limit.toString(),
        },
      ).query;

      final endpoint =
          "/agents/$agentId/properties${query.isNotEmpty ? '?$query' : ''}";

      if (kDebugMode) {
        print("📥 Fetching properties of agent $agentId");
      }

      final response = await _get(
        endpoint,
        token: token,
      );

      if (kDebugMode) {
        print("📡 Status: ${response.statusCode}");
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return {
          "success": true,
          "data": data["data"] ?? [],
          "total": data["total"] ?? 0,
          "page": data["page"] ?? page,
          "lastPage": data["lastPage"] ?? 1,
        };
      }

      return {
        "success": false,
        "message": "Failed to load agent properties",
      };
    } catch (e) {
      if (kDebugMode) {
        print("❌ Error: $e");
      }

      return {
        "success": false,
        "message": e.toString(),
      };
    }
  }
}