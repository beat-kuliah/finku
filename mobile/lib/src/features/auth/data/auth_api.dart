import 'package:dio/dio.dart';
import 'package:finku_mobile/src/core/errors/api_error.dart';
import 'package:finku_mobile/src/core/network/dio_api_mapper.dart';
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

  // ---------------------------------------------------------------------------
  // Phase 0 stubs — Track D will implement these bodies.
  //
  // All methods mirror the web endpoints under `/auth/*` and must, on success,
  // bump `dataRevisionProvider` from the caller (controller layer) so that
  // dependent providers refresh.
  // ---------------------------------------------------------------------------

  /// `PATCH /auth/password` — change password when the user already has one.
  Future<AuthUserDto> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    throw UnimplementedError('Phase 0 stub: changePassword');
  }

  /// `PATCH /auth/password` — set initial password for OAuth-only users
  /// (no `currentPassword` required).
  Future<AuthUserDto> setInitialPassword({
    required String newPassword,
  }) async {
    throw UnimplementedError('Phase 0 stub: setInitialPassword');
  }

  /// `PATCH /auth/username` — set or change the user's username.
  Future<AuthUserDto> setUsername({required String username}) async {
    throw UnimplementedError('Phase 0 stub: setUsername');
  }

  /// `GET /auth/username/suggest` — server-side suggestion based on name/email.
  Future<String> suggestUsername() async {
    throw UnimplementedError('Phase 0 stub: suggestUsername');
  }

  /// `PATCH /auth/profile` — update profile fields (name + finance prefs).
  Future<AuthUserDto> updateProfile({
    String? name,
    String? currency,
    num? monthlyIncome,
    int? payday,
  }) async {
    throw UnimplementedError('Phase 0 stub: updateProfile');
  }

  /// `DELETE /auth/identities/:provider` — unlink an OAuth identity
  /// (e.g. `google`).
  Future<AuthUserDto> unlinkProvider(String provider) async {
    throw UnimplementedError('Phase 0 stub: unlinkProvider');
  }

  @Deprecated('Use mapDioToApiError from dio_api_mapper.dart')
  static ApiError mapDioError(Object error) => mapDioToApiError(error);
}
