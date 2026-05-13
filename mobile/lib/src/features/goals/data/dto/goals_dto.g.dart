// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goals_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GoalDto _$GoalDtoFromJson(Map<String, dynamic> json) => _GoalDto(
  id: json['id'] as String,
  userId: json['userId'] as String,
  name: json['name'] as String,
  targetAmount: (json['targetAmount'] as num).toInt(),
  currentAmount: (json['currentAmount'] as num).toInt(),
  deadline: json['deadline'] as String?,
  progressPct: (json['progressPct'] as num?)?.toDouble(),
  createdAt: json['createdAt'] as String,
  updatedAt: json['updatedAt'] as String,
);

Map<String, dynamic> _$GoalDtoToJson(_GoalDto instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'name': instance.name,
  'targetAmount': instance.targetAmount,
  'currentAmount': instance.currentAmount,
  'deadline': instance.deadline,
  'progressPct': instance.progressPct,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
};

_ListGoalsResponseDto _$ListGoalsResponseDtoFromJson(
  Map<String, dynamic> json,
) => _ListGoalsResponseDto(
  goals: (json['goals'] as List<dynamic>)
      .map((e) => GoalDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ListGoalsResponseDtoToJson(
  _ListGoalsResponseDto instance,
) => <String, dynamic>{'goals': instance.goals};

_GoalEnvelopeDto _$GoalEnvelopeDtoFromJson(Map<String, dynamic> json) =>
    _GoalEnvelopeDto(
      goal: GoalDto.fromJson(json['goal'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GoalEnvelopeDtoToJson(_GoalEnvelopeDto instance) =>
    <String, dynamic>{'goal': instance.goal};
