// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_groups_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WalletGroupDto _$WalletGroupDtoFromJson(Map<String, dynamic> json) =>
    _WalletGroupDto(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String?,
      walletCount: (json['walletCount'] as num).toInt(),
      totalBalance: (json['totalBalance'] as num).toInt(),
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );

Map<String, dynamic> _$WalletGroupDtoToJson(_WalletGroupDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'name': instance.name,
      'icon': instance.icon,
      'walletCount': instance.walletCount,
      'totalBalance': instance.totalBalance,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

_ListWalletGroupsResponseDto _$ListWalletGroupsResponseDtoFromJson(
  Map<String, dynamic> json,
) => _ListWalletGroupsResponseDto(
  groups: (json['groups'] as List<dynamic>)
      .map((e) => WalletGroupDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ListWalletGroupsResponseDtoToJson(
  _ListWalletGroupsResponseDto instance,
) => <String, dynamic>{'groups': instance.groups};

_WalletGroupEnvelopeDto _$WalletGroupEnvelopeDtoFromJson(
  Map<String, dynamic> json,
) => _WalletGroupEnvelopeDto(
  group: WalletGroupDto.fromJson(json['group'] as Map<String, dynamic>),
);

Map<String, dynamic> _$WalletGroupEnvelopeDtoToJson(
  _WalletGroupEnvelopeDto instance,
) => <String, dynamic>{'group': instance.group};
