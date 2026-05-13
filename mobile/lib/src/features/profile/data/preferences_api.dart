import 'package:dio/dio.dart';

import 'package:finku_mobile/src/core/network/dio_api_mapper.dart';
import 'package:finku_mobile/src/features/profile/data/dto/preferences_dto.dart';

class PreferencesApi {
  PreferencesApi(this._dio);

  final Dio _dio;

  Future<PreferencesDto> get() async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('/preferences');
      return PreferencesEnvelopeDto.fromJson(res.data ?? const {}).preferences;
    } catch (e) {
      throw mapDioToApiError(e);
    }
  }

  Future<PreferencesDto> patch(Map<String, dynamic> body) async {
    try {
      final res = await _dio.patch<Map<String, dynamic>>(
        '/preferences',
        data: body,
      );
      return PreferencesEnvelopeDto.fromJson(res.data ?? const {}).preferences;
    } catch (e) {
      throw mapDioToApiError(e);
    }
  }
}
