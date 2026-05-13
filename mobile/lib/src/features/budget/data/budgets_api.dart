import 'package:dio/dio.dart';

import 'package:finku_mobile/src/core/network/dio_api_mapper.dart';
import 'package:finku_mobile/src/features/budget/data/dto/budgets_dto.dart';

class BudgetsApi {
  BudgetsApi(this._dio);

  final Dio _dio;

  Future<List<BudgetDto>> list({String? from, String? to}) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '/budgets',
        queryParameters: {
          'from': ?from,
          'to': ?to,
        },
      );
      return ListBudgetsResponseDto.fromJson(res.data ?? const {}).budgets;
    } catch (e) {
      throw mapDioToApiError(e);
    }
  }

  Future<BudgetDto> create({
    required String categoryId,
    String? period,
    required String periodAnchor,
    required int limitAmount,
  }) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/budgets',
        data: {
          'categoryId': categoryId,
          'period': ?period,
          'periodAnchor': periodAnchor,
          'limitAmount': limitAmount,
        },
      );
      return BudgetEnvelopeDto.fromJson(res.data ?? const {}).budget;
    } catch (e) {
      throw mapDioToApiError(e);
    }
  }

  Future<BudgetDto> updateLimit(String id, int limitAmount) async {
    try {
      final res = await _dio.patch<Map<String, dynamic>>(
        '/budgets/$id',
        data: {'limitAmount': limitAmount},
      );
      return BudgetEnvelopeDto.fromJson(res.data ?? const {}).budget;
    } catch (e) {
      throw mapDioToApiError(e);
    }
  }

  Future<void> delete(String id) async {
    try {
      await _dio.delete<void>('/budgets/$id');
    } catch (e) {
      throw mapDioToApiError(e);
    }
  }
}
