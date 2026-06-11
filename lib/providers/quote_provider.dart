import 'package:flutter/foundation.dart';
import '../models/quote.dart';
import '../services/quote_api_service.dart';

class QuoteProvider with ChangeNotifier {
  final QuoteApiService _apiService = QuoteApiService();
  
  Quote? _currentQuote;
  bool _isLoading = false;
  String? _errorMessage;

  Quote? get currentQuote => _currentQuote;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  QuoteProvider() {
    fetchQuote();
  }

  Future<void> fetchQuote() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentQuote = await _apiService.fetchRandomQuote();
    } catch (e) {
      _errorMessage = 'Couldn\'t load quote';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
