// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthUserDto _$AuthUserDtoFromJson(Map<String, dynamic> json) => _AuthUserDto(
  id: json['id'] as String,
  email: json['email'] as String,
  name: json['name'] as String,
  username: json['username'] as String?,
  hasPassword: json['hasPassword'] as bool,
  providers:
      (json['providers'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  monthlyIncome: (json['monthlyIncome'] as num?)?.toInt(),
  payday: (json['payday'] as num?)?.toInt(),
  currency: json['currency'] as String,
  createdAt: json['createdAt'] as String,
  updatedAt: json['updatedAt'] as String,
);

Map<String, dynamic> _$AuthUserDtoToJson(_AuthUserDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'username': instance.username,
      'hasPassword': instance.hasPassword,
      'providers': instance.providers,
      'monthlyIncome': instance.monthlyIncome,
      'payday': instance.payday,
      'currency': instance.currency,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

_MobileAuthResponseDto _$MobileAuthResponseDtoFromJson(
  Map<String, dynamic> json,
) => _MobileAuthResponseDto(
  user: AuthUserDto.fromJson(json['user'] as Map<String, dynamic>),
  accessToken: json['accessToken'] as String,
  refreshToken: json['refreshToken'] as String,
);

Map<String, dynamic> _$MobileAuthResponseDtoToJson(
  _MobileAuthResponseDto instance,
) => <String, dynamic>{
  'user': instance.user,
  'accessToken': instance.accessToken,
  'refreshToken': instance.refreshToken,
};

_MobileRefreshResponseDto _$MobileRefreshResponseDtoFromJson(
  Map<String, dynamic> json,
) => _MobileRefreshResponseDto(
  accessToken: json['accessToken'] as String,
  refreshToken: json['refreshToken'] as String,
);

Map<String, dynamic> _$MobileRefreshResponseDtoToJson(
  _MobileRefreshResponseDto instance,
) => <String, dynamic>{
  'accessToken': instance.accessToken,
  'refreshToken': instance.refreshToken,
};

_MeResponseDto _$MeResponseDtoFromJson(Map<String, dynamic> json) =>
    _MeResponseDto(
      user: AuthUserDto.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MeResponseDtoToJson(_MeResponseDto instance) =>
    <String, dynamic>{'user': instance.user};

_ApiErrorEnvelopeDto _$ApiErrorEnvelopeDtoFromJson(Map<String, dynamic> json) =>
    _ApiErrorEnvelopeDto(
      error: json['error'] == null
          ? null
          : ApiErrorDto.fromJson(json['error'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ApiErrorEnvelopeDtoToJson(
  _ApiErrorEnvelopeDto instance,
) => <String, dynamic>{'error': instance.error};

_ApiErrorDto _$ApiErrorDtoFromJson(Map<String, dynamic> json) => _ApiErrorDto(
  code: json['code'] as String?,
  message: json['message'] as String?,
);

Map<String, dynamic> _$ApiErrorDtoToJson(_ApiErrorDto instance) =>
    <String, dynamic>{'code': instance.code, 'message': instance.message};
