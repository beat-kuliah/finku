import 'package:freezed_annotation/freezed_annotation.dart';

part 'preferences_dto.freezed.dart';
part 'preferences_dto.g.dart';

@freezed
abstract class PreferencesDto with _$PreferencesDto {
  const factory PreferencesDto({
    required bool notifyBudgetWarning,
    required bool notifyReminder,
    required bool notifyWeeklyReport,
    required String theme,
    String? updatedAt,
  }) = _PreferencesDto;

  factory PreferencesDto.fromJson(Map<String, dynamic> json) => _$PreferencesDtoFromJson(json);
}

@freezed
abstract class PreferencesEnvelopeDto with _$PreferencesEnvelopeDto {
  const factory PreferencesEnvelopeDto({
    required PreferencesDto preferences,
  }) = _PreferencesEnvelopeDto;

  factory PreferencesEnvelopeDto.fromJson(Map<String, dynamic> json) =>
      _$PreferencesEnvelopeDtoFromJson(json);
}
