import 'dart:async';

import 'package:dio/dio.dart';

typedef RefreshTokenFn = Future<String?> Function();
typedef UnauthorizedFn = Future<void> Function();
typedef AccessTokenFn = String? Function();

class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required AccessTokenFn getAccessToken,
    required RefreshTokenFn refreshToken,
    required UnauthorizedFn onUnauthorized,
  })  : _getAccessToken = getAccessToken,
        _refreshToken = refreshToken,
        _onUnauthorized = onUnauthorized;

  final AccessTokenFn _getAccessToken;
  final RefreshTokenFn _refreshToken;
  final UnauthorizedFn _onUnauthorized;

  Completer<String?>? _refreshCompleter;

  bool _isAuthExcluded(String path) {
    return path.endsWith('/auth/mobile/login') ||
        path.endsWith('/auth/mobile/register') ||
        path.endsWith('/auth/mobile/refresh') ||
        path.endsWith('/auth/mobile/oauth/google');
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!_isAuthExcluded(options.path)) {
      final token = _getAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    super.onRequest(options, handler);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final status = err.response?.statusCode ?? 0;
    final requestPath = err.requestOptions.path;
    if (status != 401 || _isAuthExcluded(requestPath)) {
      handler.next(err);
      return;
    }

    _refreshCompleter ??= Completer<String?>();
    if (!_refreshCompleter!.isCompleted) {
      try {
        final token = await _refreshToken();
        _refreshCompleter!.complete(token);
      } catch (_) {
        _refreshCompleter!.complete(null);
      }
    }
    final newToken = await _refreshCompleter!.future;
    _refreshCompleter = null;

    if (newToken == null || newToken.isEmpty) {
      await _onUnauthorized();
      handler.next(err);
      return;
    }

    final retryOptions = err.requestOptions;
    retryOptions.headers['Authorization'] = 'Bearer $newToken';
    final dio = Dio(err.requestOptions.baseUrl.isEmpty ? BaseOptions() : BaseOptions(baseUrl: err.requestOptions.baseUrl));
    dio.interceptors.clear();
    try {
      final response = await dio.fetch<dynamic>(retryOptions);
      handler.resolve(response);
    } catch (retryErr) {
      handler.next(err);
    }
  }
}
