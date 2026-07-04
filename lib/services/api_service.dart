import 'package:get/get.dart';

import 'package:me_mobile/services/api_response.dart';
import 'package:me_mobile/services/api_routes.dart';

enum ApiMethod { get, post, put, patch, delete }

class ApiService extends GetxService {
  final GetConnect _client = GetConnect();
  late String _baseUrl;

  ApiService init({String? baseUrl}) {
    _baseUrl = baseUrl ?? ApiRoutes.publicBaseUrl;
    _client.httpClient.timeout = const Duration(seconds: 30);
    return this;
  }

  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? query,
    T Function(dynamic value)? fromJson,
  }) {
    return _request<T>(
      ApiMethod.get,
      endpoint,
      headers: headers,
      query: query,
      fromJson: fromJson,
    );
  }

  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    Object? body,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
    T Function(dynamic value)? fromJson,
  }) {
    return _request<T>(
      ApiMethod.post,
      endpoint,
      body: body,
      headers: headers,
      query: query,
      fromJson: fromJson,
    );
  }

  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    Object? body,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
    T Function(dynamic value)? fromJson,
  }) {
    return _request<T>(
      ApiMethod.put,
      endpoint,
      body: body,
      headers: headers,
      query: query,
      fromJson: fromJson,
    );
  }

  Future<ApiResponse<T>> patch<T>(
    String endpoint, {
    Object? body,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
    T Function(dynamic value)? fromJson,
  }) {
    return _request<T>(
      ApiMethod.patch,
      endpoint,
      body: body,
      headers: headers,
      query: query,
      fromJson: fromJson,
    );
  }

  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    Object? body,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
    T Function(dynamic value)? fromJson,
  }) {
    return _request<T>(
      ApiMethod.delete,
      endpoint,
      body: body,
      headers: headers,
      query: query,
      fromJson: fromJson,
    );
  }

  Future<ApiResponse<T>> _request<T>(
    ApiMethod method,
    String endpoint, {
    Object? body,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
    T Function(dynamic value)? fromJson,
  }) async {
    try {
      final response = await _send(
        method,
        endpoint,
        body: body,
        headers: headers,
        query: query,
      );

      return _normalizeResponse<T>(response, fromJson: fromJson);
    } on Exception catch (error) {
      return ApiResponse<T>.failure(message: error.toString(), status: 0);
    }
  }

  Future<Response<dynamic>> _send(
    ApiMethod method,
    String endpoint, {
    Object? body,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
  }) {
    final resolvedEndpoint = _resolveEndpoint(endpoint);

    return switch (method) {
      ApiMethod.get => _client.get(
        resolvedEndpoint,
        headers: headers,
        query: query,
      ),
      ApiMethod.post => _client.post(
        resolvedEndpoint,
        body,
        headers: headers,
        query: query,
      ),
      ApiMethod.put => _client.put(
        resolvedEndpoint,
        body,
        headers: headers,
        query: query,
      ),
      ApiMethod.patch => _client.patch(
        resolvedEndpoint,
        body,
        headers: headers,
        query: query,
      ),
      ApiMethod.delete => _client.delete(
        resolvedEndpoint,
        headers: headers,
        query: query,
      ),
    };
  }

  String _resolveEndpoint(String endpoint) {
    if (endpoint.startsWith('http://') || endpoint.startsWith('https://')) {
      return endpoint;
    }

    final cleanBaseUrl = _baseUrl.endsWith('/')
        ? _baseUrl.substring(0, _baseUrl.length - 1)
        : _baseUrl;
    final cleanEndpoint = endpoint.startsWith('/') ? endpoint : '/$endpoint';

    return '$cleanBaseUrl$cleanEndpoint';
  }

  ApiResponse<T> _normalizeResponse<T>(
    Response<dynamic> response, {
    T Function(dynamic value)? fromJson,
  }) {
    final status = response.statusCode ?? 0;
    final body = response.body;

    if (body is Map<String, dynamic>) {
      return ApiResponse<T>.fromJson(
        body,
        fallbackStatus: status,
        fromJson: fromJson,
      );
    }

    if (body is Map) {
      return ApiResponse<T>.fromJson(
        Map<String, dynamic>.from(body),
        fallbackStatus: status,
        fromJson: fromJson,
      );
    }

    if (body is List) {
      return ApiResponse<T>(
        data: body
            .map((value) => fromJson == null ? value as T : fromJson(value))
            .toList(),
        message: response.statusText ?? '',
        status: status,
      );
    }

    return ApiResponse<T>.failure(
      message: response.statusText ?? 'Unexpected API response',
      status: status,
    );
  }
}
