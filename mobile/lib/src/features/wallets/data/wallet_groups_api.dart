import 'package:dio/dio.dart';

import 'package:finku_mobile/src/core/network/dio_api_mapper.dart';
import 'package:finku_mobile/src/features/wallets/data/dto/wallet_groups_dto.dart';

class WalletGroupsApi {
  WalletGroupsApi(this._dio);

  final Dio _dio;

  Future<List<WalletGroupDto>> list() async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('/wallet-groups');
      return ListWalletGroupsResponseDto.fromJson(res.data ?? const {}).groups;
    } catch (e) {
      throw mapDioToApiError(e);
    }
  }

  Future<WalletGroupDto> create({required String name, String? icon}) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/wallet-groups',
        data: {
          'name': name,
          'icon': ?icon,
        },
      );
      return WalletGroupEnvelopeDto.fromJson(res.data ?? const {}).group;
    } catch (e) {
      throw mapDioToApiError(e);
    }
  }

  Future<WalletGroupDto> update(String id, {required String name, String? icon}) async {
    try {
      final res = await _dio.patch<Map<String, dynamic>>(
        '/wallet-groups/$id',
        data: {
          'name': name,
          'icon': ?icon,
        },
      );
      return WalletGroupEnvelopeDto.fromJson(res.data ?? const {}).group;
    } catch (e) {
      throw mapDioToApiError(e);
    }
  }

  Future<void> delete(String id) async {
    try {
      await _dio.delete<void>('/wallet-groups/$id');
    } catch (e) {
      throw mapDioToApiError(e);
    }
  }
}
