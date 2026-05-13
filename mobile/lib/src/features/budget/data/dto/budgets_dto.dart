import 'package:freezed_annotation/freezed_annotation.dart';

part 'budgets_dto.freezed.dart';
part 'budgets_dto.g.dart';

@freezed
abstract class BudgetDto with _$BudgetDto {
  const factory BudgetDto({
    required String id,
    required String categoryId,
    String? categoryName,
    required int limitAmount,
    required int spent,
    required String periodAnchor,
    required bool paused,
    String? pausedAt,
  }) = _BudgetDto;

  factory BudgetDto.fromJson(Map<String, dynamic> json) => _$BudgetDtoFromJson(json);
}

@freezed
abstract class ListBudgetsResponseDto with _$ListBudgetsResponseDto {
  const factory ListBudgetsResponseDto({
    required List<BudgetDto> budgets,
  }) = _ListBudgetsResponseDto;

  factory ListBudgetsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ListBudgetsResponseDtoFromJson(json);
}

@freezed
abstract class BudgetEnvelopeDto with _$BudgetEnvelopeDto {
  const factory BudgetEnvelopeDto({
    required BudgetDto budget,
  }) = _BudgetEnvelopeDto;

  factory BudgetEnvelopeDto.fromJson(Map<String, dynamic> json) => _$BudgetEnvelopeDtoFromJson(json);
}
