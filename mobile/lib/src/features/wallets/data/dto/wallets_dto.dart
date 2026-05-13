import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallets_dto.freezed.dart';
part 'wallets_dto.g.dart';

@freezed
abstract class WalletDto with _$WalletDto {
  const factory WalletDto({
    required String id,
    required String userId,
    required String name,
    required String walletType,
    String? icon,
    required int balance,
    String? groupId,
    String? archivedAt,
    required String createdAt,
    required String updatedAt,
  }) = _WalletDto;

  factory WalletDto.fromJson(Map<String, dynamic> json) => _$WalletDtoFromJson(json);
}

@freezed
abstract class ListWalletsResponseDto with _$ListWalletsResponseDto {
  const factory ListWalletsResponseDto({
    required List<WalletDto> wallets,
  }) = _ListWalletsResponseDto;

  factory ListWalletsResponseDto.fromJson(Map<String, dynamic> json) => _$ListWalletsResponseDtoFromJson(json);
}

@freezed
abstract class WalletEnvelopeDto with _$WalletEnvelopeDto {
  const factory WalletEnvelopeDto({
    required WalletDto wallet,
  }) = _WalletEnvelopeDto;

  factory WalletEnvelopeDto.fromJson(Map<String, dynamic> json) => _$WalletEnvelopeDtoFromJson(json);
}
