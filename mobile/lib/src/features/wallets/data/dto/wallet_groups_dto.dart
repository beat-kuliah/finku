import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_groups_dto.freezed.dart';
part 'wallet_groups_dto.g.dart';

@freezed
abstract class WalletGroupDto with _$WalletGroupDto {
  const factory WalletGroupDto({
    required String id,
    required String userId,
    required String name,
    String? icon,
    required int walletCount,
    required int totalBalance,
    required String createdAt,
    required String updatedAt,
  }) = _WalletGroupDto;

  factory WalletGroupDto.fromJson(Map<String, dynamic> json) => _$WalletGroupDtoFromJson(json);
}

@freezed
abstract class ListWalletGroupsResponseDto with _$ListWalletGroupsResponseDto {
  const factory ListWalletGroupsResponseDto({
    required List<WalletGroupDto> groups,
  }) = _ListWalletGroupsResponseDto;

  factory ListWalletGroupsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ListWalletGroupsResponseDtoFromJson(json);
}

@freezed
abstract class WalletGroupEnvelopeDto with _$WalletGroupEnvelopeDto {
  const factory WalletGroupEnvelopeDto({
    required WalletGroupDto group,
  }) = _WalletGroupEnvelopeDto;

  factory WalletGroupEnvelopeDto.fromJson(Map<String, dynamic> json) =>
      _$WalletGroupEnvelopeDtoFromJson(json);
}
