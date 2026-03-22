import 'dart:convert';
import 'package:http/http.dart' as http;

//String uri = 'https://server.tja.dev.404.codes';
//String uri2 = 'ws://server.tja.dev.404.codes';
//String uri = 'http://172.93.163.231:3000';

String uri = 'http://192.168.0.11:3000';
String uri2 = uri;
//String uri2 = 'ws://192.168.0.10:3000';
//172.16.100.227:3000
//http://181.188.176.244
//String uri = 'http://192.168.0.10:3000';
//String uri2 = 'ws://192.168.0.10:3000';

String urlimagen = 'http://172.16.100.227/VichaBachePortal/file/reclamos/';

class ApiProvider {
  static const String _baseUrl = 'http://192.168.0.11:5202';
  static const String _apiKey = 'mi-api-key-secreta-2024';

  // ← Agrega timeout
  static const Duration _timeout = Duration(seconds: 10);

  static Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'X-Api-Key': _apiKey,
      };

  static Future<http.Response> get(String endpoint) async {
    try {
      print('🌐 GET: $_baseUrl$endpoint');
      final response = await http
          .get(
            Uri.parse('$_baseUrl$endpoint'),
            headers: _headers,
          )
          .timeout(_timeout);
      print(' Response ${response.statusCode}: ${response.body}');
      return response;
    } catch (e) {
      print(' GET Error: $e');
      rethrow;
    }
  }

  static Future<http.Response> post(
      String endpoint, Map<String, dynamic> body) async {
    try {
      print('🌐 POST: $_baseUrl$endpoint');
      print('📦 Body: ${jsonEncode(body)}');
      final response = await http
          .post(
            Uri.parse('$_baseUrl$endpoint'),
            headers: _headers,
            body: jsonEncode(body),
          )
          .timeout(_timeout);
      print(' Response ${response.statusCode}: ${response.body}');
      return response;
    } catch (e) {
      print(' POST Error: $e');
      rethrow;
    }
  }

  static Future<http.Response> patch(
      String endpoint, Map<String, dynamic> body) async {
    try {
      print('🌐 PATCH: $_baseUrl$endpoint');
      final response = await http
          .patch(
            Uri.parse('$_baseUrl$endpoint'),
            headers: _headers,
            body: jsonEncode(body),
          )
          .timeout(_timeout);
      print(' Response ${response.statusCode}: ${response.body}');
      return response;
    } catch (e) {
      print(' PATCH Error: $e');
      rethrow;
    }
  }

  static Future<http.Response> put(
      String endpoint, Map<String, dynamic> body) async {
    try {
      print('🌐 PUT: $_baseUrl$endpoint');
      final response = await http
          .put(
            Uri.parse('$_baseUrl$endpoint'),
            headers: _headers,
            body: jsonEncode(body),
          )
          .timeout(_timeout);
      print('Response ${response.statusCode}: ${response.body}');
      return response;
    } catch (e) {
      print(' PUT Error: $e');
      rethrow;
    }
  }

  static Future<http.Response> delete(String endpoint) async {
    try {
      print('🌐 DELETE: $_baseUrl$endpoint');
      final response = await http
          .delete(
            Uri.parse('$_baseUrl$endpoint'),
            headers: _headers,
          )
          .timeout(_timeout);
      print(' Response ${response.statusCode}: ${response.body}');
      return response;
    } catch (e) {
      print(' DELETE Error: $e');
      rethrow;
    }
  }
}
