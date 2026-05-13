import 'package:freezed_annotation/freezed_annotation.dart';

part 'goals_dto.freezed.dart';
part 'goals_dto.g.dart';

@freezed
abstract class GoalDto with _$GoalDto {
  const factory GoalDto({
    required String id,
    required String userId,
    required String name,
    required int targetAmount,
    required int currentAmount,
    String? deadline,
    double? progressPct,
    required String createdAt,
    required String updatedAt,
  }) = _GoalDto;

  factory GoalDto.fromJson(Map<String, dynamic> json) => _$GoalDtoFromJson(json);
}

@freezed
abstract class ListGoalsResponseDto with _$ListGoalsResponseDto {
  const factory ListGoalsResponseDto({
    required List<GoalDto> goals,
  }) = _ListGoalsResponseDto;

  factory ListGoalsResponseDto.fromJson(Map<String, dynamic> json) => _$ListGoalsResponseDtoFromJson(json);
}

@freezed
abstract class GoalEnvelopeDto with _$GoalEnvelopeDto {
  const factory GoalEnvelopeDto({
    required GoalDto goal,
  }) = _GoalEnvelopeDto;

  factory GoalEnvelopeDto.fromJson(Map<String, dynamic> json) => _$GoalEnvelopeDtoFromJson(json);
}
