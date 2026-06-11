import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quote.dart';

class QuoteApiService {
  static const String _baseUrl = 'https://dummyjson.com/quotes/random';

  Future<Quote> fetchRandomQuote() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        if (data is List && data.isNotEmpty) {
          return Quote.fromJson(data[0]);
        } else if (data is Map<String, dynamic>) {
          return Quote.fromJson(data);
        } else {
           throw Exception('Unexpected data format');
        }
      } else {
        throw Exception('Failed to load quote. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }
}
