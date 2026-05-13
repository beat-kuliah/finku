// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferences_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PreferencesDto _$PreferencesDtoFromJson(Map<String, dynamic> json) =>
    _PreferencesDto(
      notifyBudgetWarning: json['notifyBudgetWarning'] as bool,
      notifyReminder: json['notifyReminder'] as bool,
      notifyWeeklyReport: json['notifyWeeklyReport'] as bool,
      theme: json['theme'] as String,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$PreferencesDtoToJson(_PreferencesDto instance) =>
    <String, dynamic>{
      'notifyBudgetWarning': instance.notifyBudgetWarning,
      'notifyReminder': instance.notifyReminder,
      'notifyWeeklyReport': instance.notifyWeeklyReport,
      'theme': instance.theme,
      'updatedAt': instance.updatedAt,
    };

_PreferencesEnvelopeDto _$PreferencesEnvelopeDtoFromJson(
  Map<String, dynamic> json,
) => _PreferencesEnvelopeDto(
  preferences: PreferencesDto.fromJson(
    json['preferences'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$PreferencesEnvelopeDtoToJson(
  _PreferencesEnvelopeDto instance,
) => <String, dynamic>{'preferences': instance.preferences};
