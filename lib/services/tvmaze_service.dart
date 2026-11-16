import 'dart:convert';

import 'package:http/http.dart' as http;

class TvMazeService {
  static const String _baseUrl = 'https://api.tvmaze.com';
  final http.Client _client;

  TvMazeService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<Map<String, dynamic>>> fetchShows() async {
    final uri = Uri.parse('$_baseUrl/shows');
    final response = await _client.get(uri).timeout(const Duration(seconds: 20));

    if (response.statusCode != 200) {
      throw Exception('Gagal mengambil daftar show (${response.statusCode}).');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! List) {
      throw const FormatException('Format data daftar show tidak sesuai.');
    }

    return decoded
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  Future<Map<String, dynamic>> fetchShowDetail(int id) async {
    final uri = Uri.parse('$_baseUrl/shows/$id');
    final response = await _client.get(uri).timeout(const Duration(seconds: 20));

    if (response.statusCode != 200) {
      throw Exception('Gagal mengambil detail show (${response.statusCode}).');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map) {
      throw const FormatException('Format data detail show tidak sesuai.');
    }

    return Map<String, dynamic>.from(decoded);
  }

  void dispose() => _client.close();
}
