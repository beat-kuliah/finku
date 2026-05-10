import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finku_mobile/src/core/config/env.dart';
import 'package:finku_mobile/src/core/network/auth_interceptor.dart';
import 'package:finku_mobile/src/core/secure_storage/token_store_provider.dart';

final accessTokenProvider = StateProvider<String?>((ref) => null);

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: Env.apiBaseUrl,
      connectTimeout: const Duration(seconds: 12),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 12),
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
    ),
  );

  dio.interceptors.add(
    AuthInterceptor(
      getAccessToken: () => ref.read(accessTokenProvider),
      refreshToken: () async {
        final refreshToken = await ref.read(tokenStoreProvider).readRefreshToken();
        if (refreshToken == null || refreshToken.isEmpty) {
          return null;
        }
        try {
          final response = await dio.post<Map<String, dynamic>>(
            '/auth/mobile/refresh',
            data: {'refreshToken': refreshToken},
          );
          final data = response.data ?? {};
          final newAccess = data['accessToken'] as String?;
          final newRefresh = data['refreshToken'] as String?;
          if (newAccess == null || newRefresh == null) {
            return null;
          }
          await ref.read(tokenStoreProvider).saveRefreshToken(newRefresh);
          ref.read(accessTokenProvider.notifier).state = newAccess;
          return newAccess;
        } catch (_) {
          return null;
        }
      },
      onUnauthorized: () async {
        await ref.read(tokenStoreProvider).clear();
        ref.read(accessTokenProvider.notifier).state = null;
      },
    ),
  );

  if (!kReleaseMode) {
    dio.interceptors.add(
      LogInterceptor(
        requestBody: false,
        responseBody: false,
      ),
    );
  }
  return dio;
});
