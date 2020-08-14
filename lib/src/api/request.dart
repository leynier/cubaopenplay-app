import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import 'definitions.dart';
import 'utils.dart';

class Request {
  static String _apiUrl;
  static Map<String, String> _defaultHeaders;
  static ProcessResponseMethod _processResponseMethod;
  static bool _initialized = false;

  static bool checkInitialization() {
    if (!_initialized) {
      throw new Exception('Request is not initialized.');
    }
    return _initialized;
  }

  static void init(
    String authority,
    Map<String, String> headers,
    ProcessResponseMethod processResponseMethod,
  ) {
    _apiUrl = authority;
    _defaultHeaders = {};
    _defaultHeaders.addAll(headers);
    _processResponseMethod = processResponseMethod;
    _initialized = true;
  }

  static Future<http.Response> _method({
    String path,
    body,
    RequestMethod requestMethod,
    ProcessResponseMethod processResponseMethod,
    Map<String, String> queryParameters,
    Map<String, String> headers,
    String authority,
    String nameOfMethod,
    http.Client client,
  }) async {
    checkInitialization();
    var uri = Uri.https(authority ?? _apiUrl, path, queryParameters);
    log(
      'Request $nameOfMethod: $uri\n\t\t'
      '${body != null ? 'Body: $body' : ''}',
    );
    var _headers = Map<String, String>();
    _headers.addAll(_defaultHeaders);
    _headers.addAll(headers ?? {});
    var response = await requestMethod(uri.toString(), body, _headers, client);
    printResponse(nameOfMethod, path, response.statusCode, response.body);
    if (processResponseMethod != null) {
      await processResponseMethod(response);
    } else if (_processResponseMethod != null) {
      await _processResponseMethod(response);
    }
    return response;
  }

  static Future<http.Response> _get(
    String url,
    dynamic body,
    Map<String, String> headers,
    http.Client client,
  ) {
    if (client == null) return http.get(url, headers: headers);
    return client.get(url, headers: headers);
  }

  static Future<http.Response> get(
    String path, {
    ProcessResponseMethod processResponseMethod,
    Map<String, String> queryParameters,
    Map<String, String> headers,
    String authority,
    http.Client client,
  }) {
    return _method(
      path: path,
      body: null,
      requestMethod: _get,
      processResponseMethod: processResponseMethod,
      queryParameters: queryParameters,
      headers: headers,
      authority: authority,
      nameOfMethod: 'GET',
      client: client,
    );
  }

  static Future<http.Response> _post(
    String url,
    dynamic body,
    Map<String, String> headers,
    http.Client client,
  ) {
    if (client == null)
      return http.post(url, body: jsonEncode(body), headers: headers);
    return client.post(url, body: jsonEncode(body), headers: headers);
  }

  static Future<http.Response> post(
    String path, {
    body,
    ProcessResponseMethod processResponseMethod,
    Map<String, String> queryParameters,
    Map<String, String> headers,
    String authority,
    http.Client client,
  }) async {
    return _method(
      path: path,
      body: body,
      requestMethod: _post,
      processResponseMethod: processResponseMethod,
      queryParameters: queryParameters,
      headers: headers,
      authority: authority,
      nameOfMethod: 'POST',
      client: client,
    );
  }

  static Future<http.Response> _put(
    String url,
    dynamic body,
    Map<String, String> headers,
    http.Client client,
  ) {
    if (client == null)
      return http.put(url, body: jsonEncode(body), headers: headers);
    return client.put(url, body: jsonEncode(body), headers: headers);
  }

  static Future<http.Response> put(
    String path, {
    body,
    ProcessResponseMethod processResponseMethod,
    Map<String, String> queryParameters,
    Map<String, String> headers,
    String authority,
    http.Client client,
  }) async {
    return _method(
      path: path,
      body: body,
      requestMethod: _put,
      processResponseMethod: processResponseMethod,
      queryParameters: queryParameters,
      headers: headers,
      authority: authority,
      nameOfMethod: 'PUT',
      client: client,
    );
  }

  static Future<http.Response> _delete(
    String url,
    dynamic body,
    Map<String, String> headers,
    http.Client client,
  ) {
    if (client == null) return http.delete(url, headers: headers);
    return client.delete(url, headers: headers);
  }

  static Future<http.Response> delete(
    String path, {
    ProcessResponseMethod processResponseMethod,
    Map<String, String> queryParameters,
    Map<String, String> headers,
    String authority,
    http.Client client,
  }) {
    return _method(
      path: path,
      body: null,
      requestMethod: _delete,
      processResponseMethod: processResponseMethod,
      queryParameters: queryParameters,
      headers: headers,
      authority: authority,
      nameOfMethod: 'DELETE',
      client: client,
    );
  }

  static Future<http.Response> _head(
    String url,
    dynamic body,
    Map<String, String> headers,
    http.Client client,
  ) {
    if (client == null) return http.head(url, headers: headers);
    return client.head(url, headers: headers);
  }

  static Future<http.Response> head(
    String path, {
    ProcessResponseMethod processResponseMethod,
    Map<String, String> queryParameters,
    Map<String, String> headers,
    String authority,
    http.Client client,
  }) {
    return _method(
      path: path,
      body: null,
      requestMethod: _head,
      processResponseMethod: processResponseMethod,
      queryParameters: queryParameters,
      headers: headers,
      authority: authority,
      nameOfMethod: 'HEAD',
      client: client,
    );
  }

  static Future<http.Response> _patch(
    String url,
    dynamic body,
    Map<String, String> headers,
    http.Client client,
  ) {
    if (client == null)
      return http.patch(url, body: jsonEncode(body), headers: headers);
    return client.patch(url, body: jsonEncode(body), headers: headers);
  }

  static Future<http.Response> patch(
    String path, {
    body,
    ProcessResponseMethod processResponseMethod,
    Map<String, String> queryParameters,
    Map<String, String> headers,
    String authority,
    http.Client client,
  }) async {
    return _method(
      path: path,
      body: body,
      requestMethod: _patch,
      processResponseMethod: processResponseMethod,
      queryParameters: queryParameters,
      headers: headers,
      authority: authority,
      nameOfMethod: 'PATCH',
      client: client,
    );
  }
}
