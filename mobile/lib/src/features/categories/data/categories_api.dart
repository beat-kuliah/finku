import 'package:dio/dio.dart';

import 'package:finku_mobile/src/core/network/dio_api_mapper.dart';
import 'package:finku_mobile/src/features/categories/data/dto/categories_dto.dart';

class CategoriesApi {
  CategoriesApi(this._dio);

  final Dio _dio;

  Future<List<CategoryDto>> list({bool? archived}) async {
    try {
      Map<String, String>? queryParameters;
      if (archived == true) {
        queryParameters = {'archived': '1'};
      } else if (archived == false) {
        queryParameters = {'archived': '0'};
      }
      final res = await _dio.get<Map<String, dynamic>>(
        '/categories',
        queryParameters: queryParameters,
      );
      return ListCategoriesResponseDto.fromJson(res.data ?? const {}).categories;
    } catch (e) {
      throw mapDioToApiError(e);
    }
  }

  Future<CategoryDto> create({required String name, required String kind, String? icon}) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/categories',
        data: {
          'name': name,
          'kind': kind,
          'icon': ?icon,
        },
      );
      return CategoryEnvelopeDto.fromJson(res.data ?? const {}).category;
    } catch (e) {
      throw mapDioToApiError(e);
    }
  }

  Future<CategoryDto> update(String id, {required String name, String? icon}) async {
    try {
      final res = await _dio.patch<Map<String, dynamic>>(
        '/categories/$id',
        data: {
          'name': name,
          'icon': ?icon,
        },
      );
      return CategoryEnvelopeDto.fromJson(res.data ?? const {}).category;
    } catch (e) {
      throw mapDioToApiError(e);
    }
  }

  Future<CategoryDto> archive(String id) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>('/categories/$id/archive');
      return CategoryEnvelopeDto.fromJson(res.data ?? const {}).category;
    } catch (e) {
      throw mapDioToApiError(e);
    }
  }

  Future<CategoryDto> unarchive(String id) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>('/categories/$id/unarchive');
      return CategoryEnvelopeDto.fromJson(res.data ?? const {}).category;
    } catch (e) {
      throw mapDioToApiError(e);
    }
  }
}
