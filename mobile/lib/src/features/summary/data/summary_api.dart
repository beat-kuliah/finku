import 'package:dio/dio.dart';

import 'package:finku_mobile/src/core/network/dio_api_mapper.dart';
import 'package:finku_mobile/src/features/summary/data/dto/summary_dto.dart';

class SummaryApi {
  SummaryApi(this._dio);

  final Dio _dio;

  Future<DashboardPayloadDto> fetchDashboard({String? from, String? to}) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '/summary/dashboard',
        queryParameters: {
          'from': ?from,
          'to': ?to,
        },
      );
      return DashboardPayloadDto.fromJson(res.data ?? const {});
    } catch (e) {
      throw mapDioToApiError(e);
    }
  }

  Future<StatsPayloadDto> fetchStats({String? from, String? to}) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '/summary/stats',
        queryParameters: {
          'from': ?from,
          'to': ?to,
        },
      );
      return StatsPayloadDto.fromJson(res.data ?? const {});
    } catch (e) {
      throw mapDioToApiError(e);
    }
  }
}
