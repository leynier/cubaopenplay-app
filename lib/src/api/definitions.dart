import 'package:http/http.dart' as http;

typedef RequestMethod = Future<http.Response> Function(
  String url,
  dynamic body,
  Map<String, String> headers,
  http.Client,
);

typedef ProcessResponseMethod = Future<void> Function(http.Response response);

typedef ParserMethod<T> = T Function(Map<String, dynamic> data);

typedef TryParserMethod<T> = T Function();
