import 'package:dio/dio.dart';

import 'package:finku_mobile/src/core/network/dio_api_mapper.dart';
import 'package:finku_mobile/src/features/goals/data/dto/goals_dto.dart';

class GoalsApi {
  GoalsApi(this._dio);

  final Dio _dio;

  Future<List<GoalDto>> list() async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('/goals');
      return ListGoalsResponseDto.fromJson(res.data ?? const {}).goals;
    } catch (e) {
      throw mapDioToApiError(e);
    }
  }

  Future<GoalDto> create({
    required String name,
    required int targetAmount,
    String? deadline,
  }) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/goals',
        data: {
          'name': name,
          'targetAmount': targetAmount,
          'deadline': ?deadline,
        },
      );
      return GoalEnvelopeDto.fromJson(res.data ?? const {}).goal;
    } catch (e) {
      throw mapDioToApiError(e);
    }
  }

  Future<GoalDto> update(
    String id, {
    required String name,
    required int targetAmount,
    String? deadline,
  }) async {
    try {
      final res = await _dio.patch<Map<String, dynamic>>(
        '/goals/$id',
        data: {
          'name': name,
          'targetAmount': targetAmount,
          'deadline': ?deadline,
        },
      );
      return GoalEnvelopeDto.fromJson(res.data ?? const {}).goal;
    } catch (e) {
      throw mapDioToApiError(e);
    }
  }

  Future<GoalDto> contribute(String id, int amount) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/goals/$id/contribute',
        data: {'amount': amount},
      );
      return GoalEnvelopeDto.fromJson(res.data ?? const {}).goal;
    } catch (e) {
      throw mapDioToApiError(e);
    }
  }

  Future<void> delete(String id) async {
    try {
      await _dio.delete<void>('/goals/$id');
    } catch (e) {
      throw mapDioToApiError(e);
    }
  }
}
