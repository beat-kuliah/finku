// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budgets_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BudgetDto _$BudgetDtoFromJson(Map<String, dynamic> json) => _BudgetDto(
  id: json['id'] as String,
  categoryId: json['categoryId'] as String,
  categoryName: json['categoryName'] as String?,
  limitAmount: (json['limitAmount'] as num).toInt(),
  spent: (json['spent'] as num).toInt(),
  periodAnchor: json['periodAnchor'] as String,
  paused: json['paused'] as bool,
  pausedAt: json['pausedAt'] as String?,
);

Map<String, dynamic> _$BudgetDtoToJson(_BudgetDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'categoryId': instance.categoryId,
      'categoryName': instance.categoryName,
      'limitAmount': instance.limitAmount,
      'spent': instance.spent,
      'periodAnchor': instance.periodAnchor,
      'paused': instance.paused,
      'pausedAt': instance.pausedAt,
    };

_ListBudgetsResponseDto _$ListBudgetsResponseDtoFromJson(
  Map<String, dynamic> json,
) => _ListBudgetsResponseDto(
  budgets: (json['budgets'] as List<dynamic>)
      .map((e) => BudgetDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ListBudgetsResponseDtoToJson(
  _ListBudgetsResponseDto instance,
) => <String, dynamic>{'budgets': instance.budgets};

_BudgetEnvelopeDto _$BudgetEnvelopeDtoFromJson(Map<String, dynamic> json) =>
    _BudgetEnvelopeDto(
      budget: BudgetDto.fromJson(json['budget'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BudgetEnvelopeDtoToJson(_BudgetEnvelopeDto instance) =>
    <String, dynamic>{'budget': instance.budget};
