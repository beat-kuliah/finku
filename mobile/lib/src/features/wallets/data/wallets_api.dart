import 'package:dio/dio.dart';

import 'package:finku_mobile/src/core/network/dio_api_mapper.dart';
import 'package:finku_mobile/src/features/wallets/data/dto/wallets_dto.dart';

class WalletsApi {
  WalletsApi(this._dio);

  final Dio _dio;

  Future<List<WalletDto>> list({bool archived = false}) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '/wallets',
        queryParameters: archived ? {'archived': '1'} : null,
      );
      return ListWalletsResponseDto.fromJson(res.data ?? const {}).wallets;
    } catch (e) {
      throw mapDioToApiError(e);
    }
  }

  Future<WalletDto> create({
    required String name,
    String? walletType,
    String? icon,
    String? groupId,
  }) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/wallets',
        data: {
          'name': name,
          'walletType': ?walletType,
          'icon': ?icon,
          'groupId': ?groupId,
        },
      );
      return WalletEnvelopeDto.fromJson(res.data ?? const {}).wallet;
    } catch (e) {
      throw mapDioToApiError(e);
    }
  }

  Future<WalletDto> update(
    String id, {
    required String name,
    String? walletType,
    String? icon,
    String? groupId,
  }) async {
    try {
      final res = await _dio.patch<Map<String, dynamic>>(
        '/wallets/$id',
        data: {
          'name': name,
          'walletType': ?walletType,
          'icon': ?icon,
          'groupId': ?groupId,
        },
      );
      return WalletEnvelopeDto.fromJson(res.data ?? const {}).wallet;
    } catch (e) {
      throw mapDioToApiError(e);
    }
  }

  Future<WalletDto> archive(String id) async {
    try {
      final res = await _dio.delete<Map<String, dynamic>>('/wallets/$id');
      return WalletEnvelopeDto.fromJson(res.data ?? const {}).wallet;
    } catch (e) {
      throw mapDioToApiError(e);
    }
  }
}
