import 'package:dio/dio.dart';

/// Adds `Authorization: Bearer <token>` to every request when a token exists.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({required this.tokenProvider});

  final String? Function() tokenProvider;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = tokenProvider();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
