// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallets_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WalletDto _$WalletDtoFromJson(Map<String, dynamic> json) => _WalletDto(
  id: json['id'] as String,
  userId: json['userId'] as String,
  name: json['name'] as String,
  walletType: json['walletType'] as String,
  icon: json['icon'] as String?,
  balance: (json['balance'] as num).toInt(),
  groupId: json['groupId'] as String?,
  archivedAt: json['archivedAt'] as String?,
  createdAt: json['createdAt'] as String,
  updatedAt: json['updatedAt'] as String,
);

Map<String, dynamic> _$WalletDtoToJson(_WalletDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'name': instance.name,
      'walletType': instance.walletType,
      'icon': instance.icon,
      'balance': instance.balance,
      'groupId': instance.groupId,
      'archivedAt': instance.archivedAt,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

_ListWalletsResponseDto _$ListWalletsResponseDtoFromJson(
  Map<String, dynamic> json,
) => _ListWalletsResponseDto(
  wallets: (json['wallets'] as List<dynamic>)
      .map((e) => WalletDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ListWalletsResponseDtoToJson(
  _ListWalletsResponseDto instance,
) => <String, dynamic>{'wallets': instance.wallets};

_WalletEnvelopeDto _$WalletEnvelopeDtoFromJson(Map<String, dynamic> json) =>
    _WalletEnvelopeDto(
      wallet: WalletDto.fromJson(json['wallet'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WalletEnvelopeDtoToJson(_WalletEnvelopeDto instance) =>
    <String, dynamic>{'wallet': instance.wallet};
