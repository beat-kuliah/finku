import 'package:freezed_annotation/freezed_annotation.dart';

part 'transactions_dto.freezed.dart';
part 'transactions_dto.g.dart';

@freezed
abstract class TransactionDto with _$TransactionDto {
  const factory TransactionDto({
    required String id,
    required String userId,
    required String kind,
    required String walletId,
    String? destWalletId,
    String? categoryId,
    String? categoryName,
    required int amount,
    required String occurredAt,
    String? description,
    required String createdAt,
    required String updatedAt,
  }) = _TransactionDto;

  factory TransactionDto.fromJson(Map<String, dynamic> json) => _$TransactionDtoFromJson(json);
}

@freezed
abstract class ListTransactionsResponseDto with _$ListTransactionsResponseDto {
  const factory ListTransactionsResponseDto({
    required List<TransactionDto> transactions,
  }) = _ListTransactionsResponseDto;

  factory ListTransactionsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ListTransactionsResponseDtoFromJson(json);
}

@freezed
abstract class TransactionEnvelopeDto with _$TransactionEnvelopeDto {
  const factory TransactionEnvelopeDto({
    required TransactionDto transaction,
  }) = _TransactionEnvelopeDto;

  factory TransactionEnvelopeDto.fromJson(Map<String, dynamic> json) =>
      _$TransactionEnvelopeDtoFromJson(json);
}
