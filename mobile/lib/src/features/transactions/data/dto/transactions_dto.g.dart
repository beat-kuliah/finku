// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transactions_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransactionDto _$TransactionDtoFromJson(Map<String, dynamic> json) =>
    _TransactionDto(
      id: json['id'] as String,
      userId: json['userId'] as String,
      kind: json['kind'] as String,
      walletId: json['walletId'] as String,
      destWalletId: json['destWalletId'] as String?,
      categoryId: json['categoryId'] as String?,
      categoryName: json['categoryName'] as String?,
      amount: (json['amount'] as num).toInt(),
      occurredAt: json['occurredAt'] as String,
      description: json['description'] as String?,
      isBalanceIncrease: json['isBalanceIncrease'] as bool?,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );

Map<String, dynamic> _$TransactionDtoToJson(_TransactionDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'kind': instance.kind,
      'walletId': instance.walletId,
      'destWalletId': instance.destWalletId,
      'categoryId': instance.categoryId,
      'categoryName': instance.categoryName,
      'amount': instance.amount,
      'occurredAt': instance.occurredAt,
      'description': instance.description,
      'isBalanceIncrease': instance.isBalanceIncrease,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

_ListTransactionsResponseDto _$ListTransactionsResponseDtoFromJson(
  Map<String, dynamic> json,
) => _ListTransactionsResponseDto(
  transactions: (json['transactions'] as List<dynamic>)
      .map((e) => TransactionDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ListTransactionsResponseDtoToJson(
  _ListTransactionsResponseDto instance,
) => <String, dynamic>{'transactions': instance.transactions};

_TransactionEnvelopeDto _$TransactionEnvelopeDtoFromJson(
  Map<String, dynamic> json,
) => _TransactionEnvelopeDto(
  transaction: TransactionDto.fromJson(
    json['transaction'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$TransactionEnvelopeDtoToJson(
  _TransactionEnvelopeDto instance,
) => <String, dynamic>{'transaction': instance.transaction};
