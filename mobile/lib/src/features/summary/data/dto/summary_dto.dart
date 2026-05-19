import 'package:freezed_annotation/freezed_annotation.dart';

part 'summary_dto.freezed.dart';
part 'summary_dto.g.dart';

@freezed
abstract class DailyTrendPointDto with _$DailyTrendPointDto {
  const factory DailyTrendPointDto({
    required String date,
    required int income,
    required int expense,
  }) = _DailyTrendPointDto;

  factory DailyTrendPointDto.fromJson(Map<String, dynamic> json) => _$DailyTrendPointDtoFromJson(json);
}

@freezed
abstract class CategoryBreakdownItemDto with _$CategoryBreakdownItemDto {
  const factory CategoryBreakdownItemDto({
    required String categoryId,
    required String name,
    required int value,
    required bool archived,
  }) = _CategoryBreakdownItemDto;

  factory CategoryBreakdownItemDto.fromJson(Map<String, dynamic> json) =>
      _$CategoryBreakdownItemDtoFromJson(json);
}

@freezed
abstract class DashboardBudgetItemDto with _$DashboardBudgetItemDto {
  const factory DashboardBudgetItemDto({
    required String id,
    required String categoryId,
    String? categoryName,
    required int limitAmount,
    required int spent,
    required String periodAnchor,
    required bool paused,
  }) = _DashboardBudgetItemDto;

  factory DashboardBudgetItemDto.fromJson(Map<String, dynamic> json) =>
      _$DashboardBudgetItemDtoFromJson(json);
}

@freezed
abstract class LatestTransactionItemDto with _$LatestTransactionItemDto {
  const factory LatestTransactionItemDto({
    required String id,
    required String kind,
    required int amount,
    required String occurredAt,
    String? description,
    required String category,
  }) = _LatestTransactionItemDto;

  factory LatestTransactionItemDto.fromJson(Map<String, dynamic> json) =>
      _$LatestTransactionItemDtoFromJson(json);
}

@freezed
abstract class DashboardPayloadDto with _$DashboardPayloadDto {
  const factory DashboardPayloadDto({
    required int totalBalance,
    required int periodIncome,
    required int periodExpense,
    int? periodModifiedBalance,
    required String periodFrom,
    required String periodTo,
    required List<DailyTrendPointDto> dailyTrend,
    required List<CategoryBreakdownItemDto> categoryBreakdown,
    required List<DashboardBudgetItemDto> budgets,
    required List<LatestTransactionItemDto> latestTransactions,
  }) = _DashboardPayloadDto;

  factory DashboardPayloadDto.fromJson(Map<String, dynamic> json) => _$DashboardPayloadDtoFromJson(json);
}

@freezed
abstract class StatsCategoryBreakdownDto with _$StatsCategoryBreakdownDto {
  const factory StatsCategoryBreakdownDto({
    required String name,
    required int value,
    required bool archived,
  }) = _StatsCategoryBreakdownDto;

  factory StatsCategoryBreakdownDto.fromJson(Map<String, dynamic> json) =>
      _$StatsCategoryBreakdownDtoFromJson(json);
}

@freezed
abstract class WeeklyExpenseDto with _$WeeklyExpenseDto {
  const factory WeeklyExpenseDto({
    required String week,
    required int total,
  }) = _WeeklyExpenseDto;

  factory WeeklyExpenseDto.fromJson(Map<String, dynamic> json) => _$WeeklyExpenseDtoFromJson(json);
}

@freezed
abstract class StatsPayloadDto with _$StatsPayloadDto {
  const factory StatsPayloadDto({
    required String periodFrom,
    required String periodTo,
    required int totalIncome,
    required int totalExpense,
    int? totalModifiedBalance,
    required List<StatsCategoryBreakdownDto> categoryBreakdown,
    required List<WeeklyExpenseDto> weeklyExpense,
  }) = _StatsPayloadDto;

  factory StatsPayloadDto.fromJson(Map<String, dynamic> json) => _$StatsPayloadDtoFromJson(json);
}
