import 'dart:convert';
import 'dart:developer';

import 'definitions.dart';
import 'exceptions.dart';

T parseItem<T>(String data, ParserMethod<T> method) {
  return method(jsonDecode(data));
}

List<T> parseList<T>(String data, ParserMethod<T> method) {
  return List<Map<String, dynamic>>.from(jsonDecode(data))
      .map<T>(method)
      .toList();
}

Future<T> tryParse<T>(TryParserMethod method) async {
  T result;
  try {
    result = await method();
  } catch (e) {
    log(e.toString());
    throw NetworkError('NetworkError: Parser exception.\nException: $e');
  }
  return result;
}

void printResponse(String method, String path, int statusCode, String data) {
  try {
    // A pretty print json function
    var prettyData = JsonEncoder.withIndent('    ').convert(
      JsonDecoder().convert(data),
    );
    log(
      'Response $method: $path\n\t\t'
      'Status: $statusCode\n\t\t'
      'Data: $prettyData',
    );
  } catch (_) {
    log(
      'Response $method: $path\n\t\t'
      'Status: $statusCode\n\t\t'
      'Data: $data',
    );
  }
}
