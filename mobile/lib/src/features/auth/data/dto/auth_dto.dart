import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_dto.freezed.dart';
part 'auth_dto.g.dart';

@freezed
abstract class AuthUserDto with _$AuthUserDto {
  const factory AuthUserDto({
    required String id,
    required String email,
    required String name,
    String? username,
    required bool hasPassword,
    @Default(<String>[]) List<String> providers,
    int? monthlyIncome,
    int? payday,
    required String currency,
    required String createdAt,
    required String updatedAt,
  }) = _AuthUserDto;

  factory AuthUserDto.fromJson(Map<String, dynamic> json) => _$AuthUserDtoFromJson(json);
}

@freezed
abstract class MobileAuthResponseDto with _$MobileAuthResponseDto {
  const factory MobileAuthResponseDto({
    required AuthUserDto user,
    required String accessToken,
    required String refreshToken,
  }) = _MobileAuthResponseDto;

  factory MobileAuthResponseDto.fromJson(Map<String, dynamic> json) => _$MobileAuthResponseDtoFromJson(json);
}

@freezed
abstract class MobileRefreshResponseDto with _$MobileRefreshResponseDto {
  const factory MobileRefreshResponseDto({
    required String accessToken,
    required String refreshToken,
  }) = _MobileRefreshResponseDto;

  factory MobileRefreshResponseDto.fromJson(Map<String, dynamic> json) => _$MobileRefreshResponseDtoFromJson(json);
}

@freezed
abstract class MeResponseDto with _$MeResponseDto {
  const factory MeResponseDto({
    required AuthUserDto user,
  }) = _MeResponseDto;

  factory MeResponseDto.fromJson(Map<String, dynamic> json) => _$MeResponseDtoFromJson(json);
}

@freezed
abstract class ApiErrorEnvelopeDto with _$ApiErrorEnvelopeDto {
  const factory ApiErrorEnvelopeDto({
    ApiErrorDto? error,
  }) = _ApiErrorEnvelopeDto;

  factory ApiErrorEnvelopeDto.fromJson(Map<String, dynamic> json) => _$ApiErrorEnvelopeDtoFromJson(json);
}

@freezed
abstract class ApiErrorDto with _$ApiErrorDto {
  const factory ApiErrorDto({
    String? code,
    String? message,
  }) = _ApiErrorDto;

  factory ApiErrorDto.fromJson(Map<String, dynamic> json) => _$ApiErrorDtoFromJson(json);
}
