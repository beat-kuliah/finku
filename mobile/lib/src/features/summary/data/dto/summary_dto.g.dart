// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'summary_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DailyTrendPointDto _$DailyTrendPointDtoFromJson(Map<String, dynamic> json) =>
    _DailyTrendPointDto(
      date: json['date'] as String,
      income: (json['income'] as num).toInt(),
      expense: (json['expense'] as num).toInt(),
    );

Map<String, dynamic> _$DailyTrendPointDtoToJson(_DailyTrendPointDto instance) =>
    <String, dynamic>{
      'date': instance.date,
      'income': instance.income,
      'expense': instance.expense,
    };

_CategoryBreakdownItemDto _$CategoryBreakdownItemDtoFromJson(
  Map<String, dynamic> json,
) => _CategoryBreakdownItemDto(
  categoryId: json['categoryId'] as String,
  name: json['name'] as String,
  value: (json['value'] as num).toInt(),
  archived: json['archived'] as bool,
);

Map<String, dynamic> _$CategoryBreakdownItemDtoToJson(
  _CategoryBreakdownItemDto instance,
) => <String, dynamic>{
  'categoryId': instance.categoryId,
  'name': instance.name,
  'value': instance.value,
  'archived': instance.archived,
};

_DashboardBudgetItemDto _$DashboardBudgetItemDtoFromJson(
  Map<String, dynamic> json,
) => _DashboardBudgetItemDto(
  id: json['id'] as String,
  categoryId: json['categoryId'] as String,
  categoryName: json['categoryName'] as String?,
  limitAmount: (json['limitAmount'] as num).toInt(),
  spent: (json['spent'] as num).toInt(),
  periodAnchor: json['periodAnchor'] as String,
  paused: json['paused'] as bool,
);

Map<String, dynamic> _$DashboardBudgetItemDtoToJson(
  _DashboardBudgetItemDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'categoryId': instance.categoryId,
  'categoryName': instance.categoryName,
  'limitAmount': instance.limitAmount,
  'spent': instance.spent,
  'periodAnchor': instance.periodAnchor,
  'paused': instance.paused,
};

_LatestTransactionItemDto _$LatestTransactionItemDtoFromJson(
  Map<String, dynamic> json,
) => _LatestTransactionItemDto(
  id: json['id'] as String,
  kind: json['kind'] as String,
  amount: (json['amount'] as num).toInt(),
  occurredAt: json['occurredAt'] as String,
  description: json['description'] as String?,
  category: json['category'] as String,
);

Map<String, dynamic> _$LatestTransactionItemDtoToJson(
  _LatestTransactionItemDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'kind': instance.kind,
  'amount': instance.amount,
  'occurredAt': instance.occurredAt,
  'description': instance.description,
  'category': instance.category,
};

_DashboardPayloadDto _$DashboardPayloadDtoFromJson(
  Map<String, dynamic> json,
) => _DashboardPayloadDto(
  totalBalance: (json['totalBalance'] as num).toInt(),
  periodIncome: (json['periodIncome'] as num).toInt(),
  periodExpense: (json['periodExpense'] as num).toInt(),
  periodFrom: json['periodFrom'] as String,
  periodTo: json['periodTo'] as String,
  dailyTrend: (json['dailyTrend'] as List<dynamic>)
      .map((e) => DailyTrendPointDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  categoryBreakdown: (json['categoryBreakdown'] as List<dynamic>)
      .map((e) => CategoryBreakdownItemDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  budgets: (json['budgets'] as List<dynamic>)
      .map((e) => DashboardBudgetItemDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  latestTransactions: (json['latestTransactions'] as List<dynamic>)
      .map((e) => LatestTransactionItemDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$DashboardPayloadDtoToJson(
  _DashboardPayloadDto instance,
) => <String, dynamic>{
  'totalBalance': instance.totalBalance,
  'periodIncome': instance.periodIncome,
  'periodExpense': instance.periodExpense,
  'periodFrom': instance.periodFrom,
  'periodTo': instance.periodTo,
  'dailyTrend': instance.dailyTrend,
  'categoryBreakdown': instance.categoryBreakdown,
  'budgets': instance.budgets,
  'latestTransactions': instance.latestTransactions,
};

_StatsCategoryBreakdownDto _$StatsCategoryBreakdownDtoFromJson(
  Map<String, dynamic> json,
) => _StatsCategoryBreakdownDto(
  name: json['name'] as String,
  value: (json['value'] as num).toInt(),
  archived: json['archived'] as bool,
);

Map<String, dynamic> _$StatsCategoryBreakdownDtoToJson(
  _StatsCategoryBreakdownDto instance,
) => <String, dynamic>{
  'name': instance.name,
  'value': instance.value,
  'archived': instance.archived,
};

_WeeklyExpenseDto _$WeeklyExpenseDtoFromJson(Map<String, dynamic> json) =>
    _WeeklyExpenseDto(
      week: json['week'] as String,
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$WeeklyExpenseDtoToJson(_WeeklyExpenseDto instance) =>
    <String, dynamic>{'week': instance.week, 'total': instance.total};

_StatsPayloadDto _$StatsPayloadDtoFromJson(Map<String, dynamic> json) =>
    _StatsPayloadDto(
      periodFrom: json['periodFrom'] as String,
      periodTo: json['periodTo'] as String,
      totalIncome: (json['totalIncome'] as num).toInt(),
      totalExpense: (json['totalExpense'] as num).toInt(),
      categoryBreakdown: (json['categoryBreakdown'] as List<dynamic>)
          .map(
            (e) =>
                StatsCategoryBreakdownDto.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      weeklyExpense: (json['weeklyExpense'] as List<dynamic>)
          .map((e) => WeeklyExpenseDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StatsPayloadDtoToJson(_StatsPayloadDto instance) =>
    <String, dynamic>{
      'periodFrom': instance.periodFrom,
      'periodTo': instance.periodTo,
      'totalIncome': instance.totalIncome,
      'totalExpense': instance.totalExpense,
      'categoryBreakdown': instance.categoryBreakdown,
      'weeklyExpense': instance.weeklyExpense,
    };
