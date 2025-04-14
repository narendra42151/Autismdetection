import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

// Default URL as fallback
const String defaultApiUrl = 'http://127.0.0.1:5000/predict';

// Cache the fetched URL to avoid too many requests
String? _cachedApiUrl;

Future<String> fetchApiBaseUrl() async {
  // Return cached URL if available
  if (_cachedApiUrl != null) {
    return _cachedApiUrl!;
  }

  try {
    // Replace with YOUR actual GitHub username and repository
    final apiConfigUrl = 'https://tanuj-saini.github.io/app-config/config.txt';
    final response = await http.get(Uri.parse(apiConfigUrl));

    if (response.statusCode == 200) {
      // Cache the URL and return it
      _cachedApiUrl = response.body.trim();
      debugPrint('Fetched API URL: $_cachedApiUrl/predict');
      return _cachedApiUrl!;
    } else {
      debugPrint('Failed to load API URL: ${response.statusCode}');
      return defaultApiUrl;
    }
  } catch (e) {
    debugPrint('Error fetching API URL: $e');
    return defaultApiUrl;
  }
}

// Getter for use where Future isn't convenient
String get apiUrl => _cachedApiUrl ?? defaultApiUrl;
