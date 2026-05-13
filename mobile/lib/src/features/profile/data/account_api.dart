import 'package:dio/dio.dart';

import 'package:finku_mobile/src/core/network/dio_api_mapper.dart';

class AccountApi {
  AccountApi(this._dio);

  final Dio _dio;

  Future<void> resetFinancialData() async {
    try {
      await _dio.post<void>('/account/reset-data');
    } catch (e) {
      throw mapDioToApiError(e);
    }
  }
}
