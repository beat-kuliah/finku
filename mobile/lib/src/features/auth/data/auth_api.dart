import 'package:dio/dio.dart';
import 'package:finku_mobile/src/core/errors/api_error.dart';
import 'package:finku_mobile/src/features/auth/data/dto/auth_dto.dart';

class AuthApi {
  AuthApi(this._dio);

  final Dio _dio;

  Future<MobileAuthResponseDto> login({
    required String identifier,
    required String password,
  }) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/auth/mobile/login',
      data: {'identifier': identifier, 'password': password},
    );
    return MobileAuthResponseDto.fromJson(res.data ?? {});
  }

  Future<MobileAuthResponseDto> register({
    required String name,
    required String username,
    required String email,
    required String password,
  }) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/auth/mobile/register',
      data: {'name': name, 'username': username, 'email': email, 'password': password},
    );
    return MobileAuthResponseDto.fromJson(res.data ?? {});
  }

  Future<MobileAuthResponseDto> loginWithGoogle(String idToken) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/auth/mobile/oauth/google',
      data: {'idToken': idToken},
    );
    return MobileAuthResponseDto.fromJson(res.data ?? {});
  }

  Future<MobileRefreshResponseDto> refresh(String refreshToken) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/auth/mobile/refresh',
      data: {'refreshToken': refreshToken},
    );
    return MobileRefreshResponseDto.fromJson(res.data ?? {});
  }

  Future<void> logout({
    required String refreshToken,
    required String accessToken,
  }) async {
    await _dio.post<void>(
      '/auth/mobile/logout',
      data: {'refreshToken': refreshToken},
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
  }

  Future<AuthUserDto> me(String accessToken) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/auth/me',
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
    return MeResponseDto.fromJson(res.data ?? {}).user;
  }

  static ApiError mapDioError(Object error) {
    if (error is DioException) {
      final status = error.response?.statusCode ?? 0;
      final payload = error.response?.data;
      if (payload is Map<String, dynamic>) {
        final envelope = ApiErrorEnvelopeDto.fromJson(payload);
        return ApiError(
          message: envelope.error?.message ?? error.message ?? 'Request failed',
          statusCode: status,
          code: envelope.error?.code,
        );
      }
      return ApiError(message: error.message ?? 'Request failed', statusCode: status);
    }
    return ApiError(message: 'Unexpected error', statusCode: 0);
  }
}
