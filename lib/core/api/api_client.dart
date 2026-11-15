import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../error/exceptions.dart';
import 'api_endpoints.dart';
import 'api_interceptors.dart';

/// Single entry point for HTTP calls. Data sources depend on this class,
/// never on Dio directly, and only ever see [ServerException] /
/// [NetworkException] / [UnauthorizedException].
class ApiClient {
  ApiClient({required String? Function() tokenProvider, Dio? dio})
    : _dio = dio ?? Dio() {
    _dio.options
      ..baseUrl = ApiEndpoints.baseUrl
      ..connectTimeout = ApiEndpoints.connectTimeout
      ..receiveTimeout = ApiEndpoints.receiveTimeout
      ..headers = {'Accept': 'application/json'};

    _dio.interceptors.add(AuthInterceptor(tokenProvider: tokenProvider));
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
    }
  }

  final Dio _dio;

  Future<dynamic> get(String path, {Map<String, dynamic>? query}) =>
      _send(() => _dio.get<dynamic>(path, queryParameters: query));

  Future<dynamic> post(String path, {Object? body}) =>
      _send(() => _dio.post<dynamic>(path, data: body));

  Future<dynamic> put(String path, {Object? body}) =>
      _send(() => _dio.put<dynamic>(path, data: body));

  Future<dynamic> patch(String path, {Object? body}) =>
      _send(() => _dio.patch<dynamic>(path, data: body));

  Future<dynamic> delete(String path, {Object? body}) =>
      _send(() => _dio.delete<dynamic>(path, data: body));

  Future<dynamic> _send(Future<Response<dynamic>> Function() request) async {
    try {
      final response = await request();
      return response.data;
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Exception _mapError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return const NetworkException();
      default:
        final statusCode = e.response?.statusCode;
        final message = _extractMessage(e.response?.data) ?? e.message;
        if (statusCode == 401) {
          return UnauthorizedException(message ?? 'Unauthorized');
        }
        return ServerException(
          message ?? 'Something went wrong',
          statusCode: statusCode,
        );
    }
  }

  String? _extractMessage(dynamic data) {
    if (data is Map && data['message'] is String) {
      return data['message'] as String;
    }
    return null;
  }
}
