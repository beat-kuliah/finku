import 'package:dio/dio.dart';

import 'package:finku_mobile/src/core/network/dio_api_mapper.dart';
import 'package:finku_mobile/src/features/transactions/data/dto/transactions_dto.dart';

class ListTransactionsQuery {
  const ListTransactionsQuery({
    this.from,
    this.to,
    this.kind,
    this.walletId,
    this.categoryId,
    this.q,
  });

  final String? from;
  final String? to;
  final String? kind;
  final String? walletId;
  final String? categoryId;
  final String? q;

  Map<String, dynamic> toQueryParameters() => <String, dynamic>{
        if (from != null && from!.isNotEmpty) 'from': from,
        if (to != null && to!.isNotEmpty) 'to': to,
        if (kind != null && kind!.isNotEmpty) 'kind': kind,
        if (walletId != null && walletId!.isNotEmpty) 'walletId': walletId,
        if (categoryId != null && categoryId!.isNotEmpty) 'categoryId': categoryId,
        if (q != null && q!.isNotEmpty) 'q': q,
      };
}

class TransactionsApi {
  TransactionsApi(this._dio);

  final Dio _dio;

  Future<List<TransactionDto>> list(ListTransactionsQuery query) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '/transactions',
        queryParameters: query.toQueryParameters(),
      );
      return ListTransactionsResponseDto.fromJson(res.data ?? const {}).transactions;
    } catch (e) {
      throw mapDioToApiError(e);
    }
  }

  Future<TransactionDto> create({
    required String kind,
    required String walletId,
    String? destWalletId,
    String? categoryId,
    required int amount,
    required String occurredAt,
    String? description,
  }) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/transactions',
        data: <String, dynamic>{
          'kind': kind,
          'walletId': walletId,
          'destWalletId': ?destWalletId,
          'categoryId': ?categoryId,
          'amount': amount,
          'occurredAt': occurredAt,
          if (description != null && description.isNotEmpty) 'description': description,
        },
      );
      return TransactionEnvelopeDto.fromJson(res.data ?? const {}).transaction;
    } catch (e) {
      throw mapDioToApiError(e);
    }
  }

  Future<TransactionDto> update(
    String id, {
    required String kind,
    required String walletId,
    String? destWalletId,
    String? categoryId,
    required int amount,
    required String occurredAt,
    String? description,
  }) async {
    try {
      final res = await _dio.patch<Map<String, dynamic>>(
        '/transactions/$id',
        data: <String, dynamic>{
          'kind': kind,
          'walletId': walletId,
          'destWalletId': ?destWalletId,
          'categoryId': ?categoryId,
          'amount': amount,
          'occurredAt': occurredAt,
          if (description != null && description.isNotEmpty) 'description': description,
        },
      );
      return TransactionEnvelopeDto.fromJson(res.data ?? const {}).transaction;
    } catch (e) {
      throw mapDioToApiError(e);
    }
  }

  Future<void> delete(String id) async {
    try {
      await _dio.delete<void>('/transactions/$id');
    } catch (e) {
      throw mapDioToApiError(e);
    }
  }
}
