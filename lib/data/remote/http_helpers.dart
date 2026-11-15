import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'price_source.dart';

/// GET + JSON decoding with uniform error handling.
Future<Map<String, dynamic>> getJson(
  http.Client client,
  Uri uri, {
  Map<String, String>? headers,
}) async {
  try {
    final response = await client
        .get(uri, headers: headers)
        .timeout(const Duration(seconds: 20));
    if (response.statusCode == 429) {
      throw const ApiException('API rate limit reached. Try again later.');
    }
    if (response.statusCode != 200) {
      throw ApiException('Server error (${response.statusCode}).');
    }
    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const ApiException('Unexpected response format.');
    }
    return decoded;
  } on ApiException {
    rethrow;
  } on TimeoutException {
    throw const ApiException('The request timed out.');
  } on SocketException {
    throw const ApiException('No internet connection.');
  } on http.ClientException {
    throw const ApiException('No internet connection.');
  } on FormatException {
    throw const ApiException('Unexpected response format.');
  }
}
