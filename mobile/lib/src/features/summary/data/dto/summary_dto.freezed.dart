// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'summary_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DailyTrendPointDto {

 String get date; int get income; int get expense;
/// Create a copy of DailyTrendPointDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyTrendPointDtoCopyWith<DailyTrendPointDto> get copyWith => _$DailyTrendPointDtoCopyWithImpl<DailyTrendPointDto>(this as DailyTrendPointDto, _$identity);

  /// Serializes this DailyTrendPointDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyTrendPointDto&&(identical(other.date, date) || other.date == date)&&(identical(other.income, income) || other.income == income)&&(identical(other.expense, expense) || other.expense == expense));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,income,expense);

@override
String toString() {
  return 'DailyTrendPointDto(date: $date, income: $income, expense: $expense)';
}


}

/// @nodoc
abstract mixin class $DailyTrendPointDtoCopyWith<$Res>  {
  factory $DailyTrendPointDtoCopyWith(DailyTrendPointDto value, $Res Function(DailyTrendPointDto) _then) = _$DailyTrendPointDtoCopyWithImpl;
@useResult
$Res call({
 String date, int income, int expense
});




}
/// @nodoc
class _$DailyTrendPointDtoCopyWithImpl<$Res>
    implements $DailyTrendPointDtoCopyWith<$Res> {
  _$DailyTrendPointDtoCopyWithImpl(this._self, this._then);

  final DailyTrendPointDto _self;
  final $Res Function(DailyTrendPointDto) _then;

/// Create a copy of DailyTrendPointDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? income = null,Object? expense = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,income: null == income ? _self.income : income // ignore: cast_nullable_to_non_nullable
as int,expense: null == expense ? _self.expense : expense // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DailyTrendPointDto].
extension DailyTrendPointDtoPatterns on DailyTrendPointDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DailyTrendPointDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DailyTrendPointDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DailyTrendPointDto value)  $default,){
final _that = this;
switch (_that) {
case _DailyTrendPointDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DailyTrendPointDto value)?  $default,){
final _that = this;
switch (_that) {
case _DailyTrendPointDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String date,  int income,  int expense)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailyTrendPointDto() when $default != null:
return $default(_that.date,_that.income,_that.expense);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String date,  int income,  int expense)  $default,) {final _that = this;
switch (_that) {
case _DailyTrendPointDto():
return $default(_that.date,_that.income,_that.expense);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String date,  int income,  int expense)?  $default,) {final _that = this;
switch (_that) {
case _DailyTrendPointDto() when $default != null:
return $default(_that.date,_that.income,_that.expense);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DailyTrendPointDto implements DailyTrendPointDto {
  const _DailyTrendPointDto({required this.date, required this.income, required this.expense});
  factory _DailyTrendPointDto.fromJson(Map<String, dynamic> json) => _$DailyTrendPointDtoFromJson(json);

@override final  String date;
@override final  int income;
@override final  int expense;

/// Create a copy of DailyTrendPointDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyTrendPointDtoCopyWith<_DailyTrendPointDto> get copyWith => __$DailyTrendPointDtoCopyWithImpl<_DailyTrendPointDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DailyTrendPointDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyTrendPointDto&&(identical(other.date, date) || other.date == date)&&(identical(other.income, income) || other.income == income)&&(identical(other.expense, expense) || other.expense == expense));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,income,expense);

@override
String toString() {
  return 'DailyTrendPointDto(date: $date, income: $income, expense: $expense)';
}


}

/// @nodoc
abstract mixin class _$DailyTrendPointDtoCopyWith<$Res> implements $DailyTrendPointDtoCopyWith<$Res> {
  factory _$DailyTrendPointDtoCopyWith(_DailyTrendPointDto value, $Res Function(_DailyTrendPointDto) _then) = __$DailyTrendPointDtoCopyWithImpl;
@override @useResult
$Res call({
 String date, int income, int expense
});




}
/// @nodoc
class __$DailyTrendPointDtoCopyWithImpl<$Res>
    implements _$DailyTrendPointDtoCopyWith<$Res> {
  __$DailyTrendPointDtoCopyWithImpl(this._self, this._then);

  final _DailyTrendPointDto _self;
  final $Res Function(_DailyTrendPointDto) _then;

/// Create a copy of DailyTrendPointDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? income = null,Object? expense = null,}) {
  return _then(_DailyTrendPointDto(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,income: null == income ? _self.income : income // ignore: cast_nullable_to_non_nullable
as int,expense: null == expense ? _self.expense : expense // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$CategoryBreakdownItemDto {

 String get categoryId; String get name; int get value; bool get archived;
/// Create a copy of CategoryBreakdownItemDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryBreakdownItemDtoCopyWith<CategoryBreakdownItemDto> get copyWith => _$CategoryBreakdownItemDtoCopyWithImpl<CategoryBreakdownItemDto>(this as CategoryBreakdownItemDto, _$identity);

  /// Serializes this CategoryBreakdownItemDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryBreakdownItemDto&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.name, name) || other.name == name)&&(identical(other.value, value) || other.value == value)&&(identical(other.archived, archived) || other.archived == archived));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,categoryId,name,value,archived);

@override
String toString() {
  return 'CategoryBreakdownItemDto(categoryId: $categoryId, name: $name, value: $value, archived: $archived)';
}


}

/// @nodoc
abstract mixin class $CategoryBreakdownItemDtoCopyWith<$Res>  {
  factory $CategoryBreakdownItemDtoCopyWith(CategoryBreakdownItemDto value, $Res Function(CategoryBreakdownItemDto) _then) = _$CategoryBreakdownItemDtoCopyWithImpl;
@useResult
$Res call({
 String categoryId, String name, int value, bool archived
});




}
/// @nodoc
class _$CategoryBreakdownItemDtoCopyWithImpl<$Res>
    implements $CategoryBreakdownItemDtoCopyWith<$Res> {
  _$CategoryBreakdownItemDtoCopyWithImpl(this._self, this._then);

  final CategoryBreakdownItemDto _self;
  final $Res Function(CategoryBreakdownItemDto) _then;

/// Create a copy of CategoryBreakdownItemDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categoryId = null,Object? name = null,Object? value = null,Object? archived = null,}) {
  return _then(_self.copyWith(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as int,archived: null == archived ? _self.archived : archived // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CategoryBreakdownItemDto].
extension CategoryBreakdownItemDtoPatterns on CategoryBreakdownItemDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategoryBreakdownItemDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategoryBreakdownItemDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategoryBreakdownItemDto value)  $default,){
final _that = this;
switch (_that) {
case _CategoryBreakdownItemDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategoryBreakdownItemDto value)?  $default,){
final _that = this;
switch (_that) {
case _CategoryBreakdownItemDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String categoryId,  String name,  int value,  bool archived)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CategoryBreakdownItemDto() when $default != null:
return $default(_that.categoryId,_that.name,_that.value,_that.archived);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String categoryId,  String name,  int value,  bool archived)  $default,) {final _that = this;
switch (_that) {
case _CategoryBreakdownItemDto():
return $default(_that.categoryId,_that.name,_that.value,_that.archived);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String categoryId,  String name,  int value,  bool archived)?  $default,) {final _that = this;
switch (_that) {
case _CategoryBreakdownItemDto() when $default != null:
return $default(_that.categoryId,_that.name,_that.value,_that.archived);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CategoryBreakdownItemDto implements CategoryBreakdownItemDto {
  const _CategoryBreakdownItemDto({required this.categoryId, required this.name, required this.value, required this.archived});
  factory _CategoryBreakdownItemDto.fromJson(Map<String, dynamic> json) => _$CategoryBreakdownItemDtoFromJson(json);

@override final  String categoryId;
@override final  String name;
@override final  int value;
@override final  bool archived;

/// Create a copy of CategoryBreakdownItemDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryBreakdownItemDtoCopyWith<_CategoryBreakdownItemDto> get copyWith => __$CategoryBreakdownItemDtoCopyWithImpl<_CategoryBreakdownItemDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CategoryBreakdownItemDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoryBreakdownItemDto&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.name, name) || other.name == name)&&(identical(other.value, value) || other.value == value)&&(identical(other.archived, archived) || other.archived == archived));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,categoryId,name,value,archived);

@override
String toString() {
  return 'CategoryBreakdownItemDto(categoryId: $categoryId, name: $name, value: $value, archived: $archived)';
}


}

/// @nodoc
abstract mixin class _$CategoryBreakdownItemDtoCopyWith<$Res> implements $CategoryBreakdownItemDtoCopyWith<$Res> {
  factory _$CategoryBreakdownItemDtoCopyWith(_CategoryBreakdownItemDto value, $Res Function(_CategoryBreakdownItemDto) _then) = __$CategoryBreakdownItemDtoCopyWithImpl;
@override @useResult
$Res call({
 String categoryId, String name, int value, bool archived
});




}
/// @nodoc
class __$CategoryBreakdownItemDtoCopyWithImpl<$Res>
    implements _$CategoryBreakdownItemDtoCopyWith<$Res> {
  __$CategoryBreakdownItemDtoCopyWithImpl(this._self, this._then);

  final _CategoryBreakdownItemDto _self;
  final $Res Function(_CategoryBreakdownItemDto) _then;

/// Create a copy of CategoryBreakdownItemDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categoryId = null,Object? name = null,Object? value = null,Object? archived = null,}) {
  return _then(_CategoryBreakdownItemDto(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as int,archived: null == archived ? _self.archived : archived // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$DashboardBudgetItemDto {

 String get id; String get categoryId; String? get categoryName; int get limitAmount; int get spent; String get periodAnchor; bool get paused;
/// Create a copy of DashboardBudgetItemDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardBudgetItemDtoCopyWith<DashboardBudgetItemDto> get copyWith => _$DashboardBudgetItemDtoCopyWithImpl<DashboardBudgetItemDto>(this as DashboardBudgetItemDto, _$identity);

  /// Serializes this DashboardBudgetItemDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardBudgetItemDto&&(identical(other.id, id) || other.id == id)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.limitAmount, limitAmount) || other.limitAmount == limitAmount)&&(identical(other.spent, spent) || other.spent == spent)&&(identical(other.periodAnchor, periodAnchor) || other.periodAnchor == periodAnchor)&&(identical(other.paused, paused) || other.paused == paused));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,categoryId,categoryName,limitAmount,spent,periodAnchor,paused);

@override
String toString() {
  return 'DashboardBudgetItemDto(id: $id, categoryId: $categoryId, categoryName: $categoryName, limitAmount: $limitAmount, spent: $spent, periodAnchor: $periodAnchor, paused: $paused)';
}


}

/// @nodoc
abstract mixin class $DashboardBudgetItemDtoCopyWith<$Res>  {
  factory $DashboardBudgetItemDtoCopyWith(DashboardBudgetItemDto value, $Res Function(DashboardBudgetItemDto) _then) = _$DashboardBudgetItemDtoCopyWithImpl;
@useResult
$Res call({
 String id, String categoryId, String? categoryName, int limitAmount, int spent, String periodAnchor, bool paused
});




}
/// @nodoc
class _$DashboardBudgetItemDtoCopyWithImpl<$Res>
    implements $DashboardBudgetItemDtoCopyWith<$Res> {
  _$DashboardBudgetItemDtoCopyWithImpl(this._self, this._then);

  final DashboardBudgetItemDto _self;
  final $Res Function(DashboardBudgetItemDto) _then;

/// Create a copy of DashboardBudgetItemDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? categoryId = null,Object? categoryName = freezed,Object? limitAmount = null,Object? spent = null,Object? periodAnchor = null,Object? paused = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,categoryName: freezed == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String?,limitAmount: null == limitAmount ? _self.limitAmount : limitAmount // ignore: cast_nullable_to_non_nullable
as int,spent: null == spent ? _self.spent : spent // ignore: cast_nullable_to_non_nullable
as int,periodAnchor: null == periodAnchor ? _self.periodAnchor : periodAnchor // ignore: cast_nullable_to_non_nullable
as String,paused: null == paused ? _self.paused : paused // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardBudgetItemDto].
extension DashboardBudgetItemDtoPatterns on DashboardBudgetItemDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardBudgetItemDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardBudgetItemDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardBudgetItemDto value)  $default,){
final _that = this;
switch (_that) {
case _DashboardBudgetItemDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardBudgetItemDto value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardBudgetItemDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String categoryId,  String? categoryName,  int limitAmount,  int spent,  String periodAnchor,  bool paused)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardBudgetItemDto() when $default != null:
return $default(_that.id,_that.categoryId,_that.categoryName,_that.limitAmount,_that.spent,_that.periodAnchor,_that.paused);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String categoryId,  String? categoryName,  int limitAmount,  int spent,  String periodAnchor,  bool paused)  $default,) {final _that = this;
switch (_that) {
case _DashboardBudgetItemDto():
return $default(_that.id,_that.categoryId,_that.categoryName,_that.limitAmount,_that.spent,_that.periodAnchor,_that.paused);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String categoryId,  String? categoryName,  int limitAmount,  int spent,  String periodAnchor,  bool paused)?  $default,) {final _that = this;
switch (_that) {
case _DashboardBudgetItemDto() when $default != null:
return $default(_that.id,_that.categoryId,_that.categoryName,_that.limitAmount,_that.spent,_that.periodAnchor,_that.paused);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardBudgetItemDto implements DashboardBudgetItemDto {
  const _DashboardBudgetItemDto({required this.id, required this.categoryId, this.categoryName, required this.limitAmount, required this.spent, required this.periodAnchor, required this.paused});
  factory _DashboardBudgetItemDto.fromJson(Map<String, dynamic> json) => _$DashboardBudgetItemDtoFromJson(json);

@override final  String id;
@override final  String categoryId;
@override final  String? categoryName;
@override final  int limitAmount;
@override final  int spent;
@override final  String periodAnchor;
@override final  bool paused;

/// Create a copy of DashboardBudgetItemDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardBudgetItemDtoCopyWith<_DashboardBudgetItemDto> get copyWith => __$DashboardBudgetItemDtoCopyWithImpl<_DashboardBudgetItemDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardBudgetItemDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardBudgetItemDto&&(identical(other.id, id) || other.id == id)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.limitAmount, limitAmount) || other.limitAmount == limitAmount)&&(identical(other.spent, spent) || other.spent == spent)&&(identical(other.periodAnchor, periodAnchor) || other.periodAnchor == periodAnchor)&&(identical(other.paused, paused) || other.paused == paused));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,categoryId,categoryName,limitAmount,spent,periodAnchor,paused);

@override
String toString() {
  return 'DashboardBudgetItemDto(id: $id, categoryId: $categoryId, categoryName: $categoryName, limitAmount: $limitAmount, spent: $spent, periodAnchor: $periodAnchor, paused: $paused)';
}


}

/// @nodoc
abstract mixin class _$DashboardBudgetItemDtoCopyWith<$Res> implements $DashboardBudgetItemDtoCopyWith<$Res> {
  factory _$DashboardBudgetItemDtoCopyWith(_DashboardBudgetItemDto value, $Res Function(_DashboardBudgetItemDto) _then) = __$DashboardBudgetItemDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String categoryId, String? categoryName, int limitAmount, int spent, String periodAnchor, bool paused
});




}
/// @nodoc
class __$DashboardBudgetItemDtoCopyWithImpl<$Res>
    implements _$DashboardBudgetItemDtoCopyWith<$Res> {
  __$DashboardBudgetItemDtoCopyWithImpl(this._self, this._then);

  final _DashboardBudgetItemDto _self;
  final $Res Function(_DashboardBudgetItemDto) _then;

/// Create a copy of DashboardBudgetItemDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? categoryId = null,Object? categoryName = freezed,Object? limitAmount = null,Object? spent = null,Object? periodAnchor = null,Object? paused = null,}) {
  return _then(_DashboardBudgetItemDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,categoryName: freezed == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String?,limitAmount: null == limitAmount ? _self.limitAmount : limitAmount // ignore: cast_nullable_to_non_nullable
as int,spent: null == spent ? _self.spent : spent // ignore: cast_nullable_to_non_nullable
as int,periodAnchor: null == periodAnchor ? _self.periodAnchor : periodAnchor // ignore: cast_nullable_to_non_nullable
as String,paused: null == paused ? _self.paused : paused // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$LatestTransactionItemDto {

 String get id; String get kind; int get amount; String get occurredAt; String? get description; String get category;
/// Create a copy of LatestTransactionItemDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LatestTransactionItemDtoCopyWith<LatestTransactionItemDto> get copyWith => _$LatestTransactionItemDtoCopyWithImpl<LatestTransactionItemDto>(this as LatestTransactionItemDto, _$identity);

  /// Serializes this LatestTransactionItemDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LatestTransactionItemDto&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt)&&(identical(other.description, description) || other.description == description)&&(identical(other.category, category) || other.category == category));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,kind,amount,occurredAt,description,category);

@override
String toString() {
  return 'LatestTransactionItemDto(id: $id, kind: $kind, amount: $amount, occurredAt: $occurredAt, description: $description, category: $category)';
}


}

/// @nodoc
abstract mixin class $LatestTransactionItemDtoCopyWith<$Res>  {
  factory $LatestTransactionItemDtoCopyWith(LatestTransactionItemDto value, $Res Function(LatestTransactionItemDto) _then) = _$LatestTransactionItemDtoCopyWithImpl;
@useResult
$Res call({
 String id, String kind, int amount, String occurredAt, String? description, String category
});




}
/// @nodoc
class _$LatestTransactionItemDtoCopyWithImpl<$Res>
    implements $LatestTransactionItemDtoCopyWith<$Res> {
  _$LatestTransactionItemDtoCopyWithImpl(this._self, this._then);

  final LatestTransactionItemDto _self;
  final $Res Function(LatestTransactionItemDto) _then;

/// Create a copy of LatestTransactionItemDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? kind = null,Object? amount = null,Object? occurredAt = null,Object? description = freezed,Object? category = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [LatestTransactionItemDto].
extension LatestTransactionItemDtoPatterns on LatestTransactionItemDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LatestTransactionItemDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LatestTransactionItemDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LatestTransactionItemDto value)  $default,){
final _that = this;
switch (_that) {
case _LatestTransactionItemDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LatestTransactionItemDto value)?  $default,){
final _that = this;
switch (_that) {
case _LatestTransactionItemDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String kind,  int amount,  String occurredAt,  String? description,  String category)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LatestTransactionItemDto() when $default != null:
return $default(_that.id,_that.kind,_that.amount,_that.occurredAt,_that.description,_that.category);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String kind,  int amount,  String occurredAt,  String? description,  String category)  $default,) {final _that = this;
switch (_that) {
case _LatestTransactionItemDto():
return $default(_that.id,_that.kind,_that.amount,_that.occurredAt,_that.description,_that.category);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String kind,  int amount,  String occurredAt,  String? description,  String category)?  $default,) {final _that = this;
switch (_that) {
case _LatestTransactionItemDto() when $default != null:
return $default(_that.id,_that.kind,_that.amount,_that.occurredAt,_that.description,_that.category);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LatestTransactionItemDto implements LatestTransactionItemDto {
  const _LatestTransactionItemDto({required this.id, required this.kind, required this.amount, required this.occurredAt, this.description, required this.category});
  factory _LatestTransactionItemDto.fromJson(Map<String, dynamic> json) => _$LatestTransactionItemDtoFromJson(json);

@override final  String id;
@override final  String kind;
@override final  int amount;
@override final  String occurredAt;
@override final  String? description;
@override final  String category;

/// Create a copy of LatestTransactionItemDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LatestTransactionItemDtoCopyWith<_LatestTransactionItemDto> get copyWith => __$LatestTransactionItemDtoCopyWithImpl<_LatestTransactionItemDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LatestTransactionItemDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LatestTransactionItemDto&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt)&&(identical(other.description, description) || other.description == description)&&(identical(other.category, category) || other.category == category));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,kind,amount,occurredAt,description,category);

@override
String toString() {
  return 'LatestTransactionItemDto(id: $id, kind: $kind, amount: $amount, occurredAt: $occurredAt, description: $description, category: $category)';
}


}

/// @nodoc
abstract mixin class _$LatestTransactionItemDtoCopyWith<$Res> implements $LatestTransactionItemDtoCopyWith<$Res> {
  factory _$LatestTransactionItemDtoCopyWith(_LatestTransactionItemDto value, $Res Function(_LatestTransactionItemDto) _then) = __$LatestTransactionItemDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String kind, int amount, String occurredAt, String? description, String category
});




}
/// @nodoc
class __$LatestTransactionItemDtoCopyWithImpl<$Res>
    implements _$LatestTransactionItemDtoCopyWith<$Res> {
  __$LatestTransactionItemDtoCopyWithImpl(this._self, this._then);

  final _LatestTransactionItemDto _self;
  final $Res Function(_LatestTransactionItemDto) _then;

/// Create a copy of LatestTransactionItemDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? kind = null,Object? amount = null,Object? occurredAt = null,Object? description = freezed,Object? category = null,}) {
  return _then(_LatestTransactionItemDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$DashboardPayloadDto {

 int get totalBalance; int get periodIncome; int get periodExpense; String get periodFrom; String get periodTo; List<DailyTrendPointDto> get dailyTrend; List<CategoryBreakdownItemDto> get categoryBreakdown; List<DashboardBudgetItemDto> get budgets; List<LatestTransactionItemDto> get latestTransactions;
/// Create a copy of DashboardPayloadDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardPayloadDtoCopyWith<DashboardPayloadDto> get copyWith => _$DashboardPayloadDtoCopyWithImpl<DashboardPayloadDto>(this as DashboardPayloadDto, _$identity);

  /// Serializes this DashboardPayloadDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardPayloadDto&&(identical(other.totalBalance, totalBalance) || other.totalBalance == totalBalance)&&(identical(other.periodIncome, periodIncome) || other.periodIncome == periodIncome)&&(identical(other.periodExpense, periodExpense) || other.periodExpense == periodExpense)&&(identical(other.periodFrom, periodFrom) || other.periodFrom == periodFrom)&&(identical(other.periodTo, periodTo) || other.periodTo == periodTo)&&const DeepCollectionEquality().equals(other.dailyTrend, dailyTrend)&&const DeepCollectionEquality().equals(other.categoryBreakdown, categoryBreakdown)&&const DeepCollectionEquality().equals(other.budgets, budgets)&&const DeepCollectionEquality().equals(other.latestTransactions, latestTransactions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalBalance,periodIncome,periodExpense,periodFrom,periodTo,const DeepCollectionEquality().hash(dailyTrend),const DeepCollectionEquality().hash(categoryBreakdown),const DeepCollectionEquality().hash(budgets),const DeepCollectionEquality().hash(latestTransactions));

@override
String toString() {
  return 'DashboardPayloadDto(totalBalance: $totalBalance, periodIncome: $periodIncome, periodExpense: $periodExpense, periodFrom: $periodFrom, periodTo: $periodTo, dailyTrend: $dailyTrend, categoryBreakdown: $categoryBreakdown, budgets: $budgets, latestTransactions: $latestTransactions)';
}


}

/// @nodoc
abstract mixin class $DashboardPayloadDtoCopyWith<$Res>  {
  factory $DashboardPayloadDtoCopyWith(DashboardPayloadDto value, $Res Function(DashboardPayloadDto) _then) = _$DashboardPayloadDtoCopyWithImpl;
@useResult
$Res call({
 int totalBalance, int periodIncome, int periodExpense, String periodFrom, String periodTo, List<DailyTrendPointDto> dailyTrend, List<CategoryBreakdownItemDto> categoryBreakdown, List<DashboardBudgetItemDto> budgets, List<LatestTransactionItemDto> latestTransactions
});




}
/// @nodoc
class _$DashboardPayloadDtoCopyWithImpl<$Res>
    implements $DashboardPayloadDtoCopyWith<$Res> {
  _$DashboardPayloadDtoCopyWithImpl(this._self, this._then);

  final DashboardPayloadDto _self;
  final $Res Function(DashboardPayloadDto) _then;

/// Create a copy of DashboardPayloadDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalBalance = null,Object? periodIncome = null,Object? periodExpense = null,Object? periodFrom = null,Object? periodTo = null,Object? dailyTrend = null,Object? categoryBreakdown = null,Object? budgets = null,Object? latestTransactions = null,}) {
  return _then(_self.copyWith(
totalBalance: null == totalBalance ? _self.totalBalance : totalBalance // ignore: cast_nullable_to_non_nullable
as int,periodIncome: null == periodIncome ? _self.periodIncome : periodIncome // ignore: cast_nullable_to_non_nullable
as int,periodExpense: null == periodExpense ? _self.periodExpense : periodExpense // ignore: cast_nullable_to_non_nullable
as int,periodFrom: null == periodFrom ? _self.periodFrom : periodFrom // ignore: cast_nullable_to_non_nullable
as String,periodTo: null == periodTo ? _self.periodTo : periodTo // ignore: cast_nullable_to_non_nullable
as String,dailyTrend: null == dailyTrend ? _self.dailyTrend : dailyTrend // ignore: cast_nullable_to_non_nullable
as List<DailyTrendPointDto>,categoryBreakdown: null == categoryBreakdown ? _self.categoryBreakdown : categoryBreakdown // ignore: cast_nullable_to_non_nullable
as List<CategoryBreakdownItemDto>,budgets: null == budgets ? _self.budgets : budgets // ignore: cast_nullable_to_non_nullable
as List<DashboardBudgetItemDto>,latestTransactions: null == latestTransactions ? _self.latestTransactions : latestTransactions // ignore: cast_nullable_to_non_nullable
as List<LatestTransactionItemDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardPayloadDto].
extension DashboardPayloadDtoPatterns on DashboardPayloadDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardPayloadDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardPayloadDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardPayloadDto value)  $default,){
final _that = this;
switch (_that) {
case _DashboardPayloadDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardPayloadDto value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardPayloadDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalBalance,  int periodIncome,  int periodExpense,  String periodFrom,  String periodTo,  List<DailyTrendPointDto> dailyTrend,  List<CategoryBreakdownItemDto> categoryBreakdown,  List<DashboardBudgetItemDto> budgets,  List<LatestTransactionItemDto> latestTransactions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardPayloadDto() when $default != null:
return $default(_that.totalBalance,_that.periodIncome,_that.periodExpense,_that.periodFrom,_that.periodTo,_that.dailyTrend,_that.categoryBreakdown,_that.budgets,_that.latestTransactions);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalBalance,  int periodIncome,  int periodExpense,  String periodFrom,  String periodTo,  List<DailyTrendPointDto> dailyTrend,  List<CategoryBreakdownItemDto> categoryBreakdown,  List<DashboardBudgetItemDto> budgets,  List<LatestTransactionItemDto> latestTransactions)  $default,) {final _that = this;
switch (_that) {
case _DashboardPayloadDto():
return $default(_that.totalBalance,_that.periodIncome,_that.periodExpense,_that.periodFrom,_that.periodTo,_that.dailyTrend,_that.categoryBreakdown,_that.budgets,_that.latestTransactions);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalBalance,  int periodIncome,  int periodExpense,  String periodFrom,  String periodTo,  List<DailyTrendPointDto> dailyTrend,  List<CategoryBreakdownItemDto> categoryBreakdown,  List<DashboardBudgetItemDto> budgets,  List<LatestTransactionItemDto> latestTransactions)?  $default,) {final _that = this;
switch (_that) {
case _DashboardPayloadDto() when $default != null:
return $default(_that.totalBalance,_that.periodIncome,_that.periodExpense,_that.periodFrom,_that.periodTo,_that.dailyTrend,_that.categoryBreakdown,_that.budgets,_that.latestTransactions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardPayloadDto implements DashboardPayloadDto {
  const _DashboardPayloadDto({required this.totalBalance, required this.periodIncome, required this.periodExpense, required this.periodFrom, required this.periodTo, required final  List<DailyTrendPointDto> dailyTrend, required final  List<CategoryBreakdownItemDto> categoryBreakdown, required final  List<DashboardBudgetItemDto> budgets, required final  List<LatestTransactionItemDto> latestTransactions}): _dailyTrend = dailyTrend,_categoryBreakdown = categoryBreakdown,_budgets = budgets,_latestTransactions = latestTransactions;
  factory _DashboardPayloadDto.fromJson(Map<String, dynamic> json) => _$DashboardPayloadDtoFromJson(json);

@override final  int totalBalance;
@override final  int periodIncome;
@override final  int periodExpense;
@override final  String periodFrom;
@override final  String periodTo;
 final  List<DailyTrendPointDto> _dailyTrend;
@override List<DailyTrendPointDto> get dailyTrend {
  if (_dailyTrend is EqualUnmodifiableListView) return _dailyTrend;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_dailyTrend);
}

 final  List<CategoryBreakdownItemDto> _categoryBreakdown;
@override List<CategoryBreakdownItemDto> get categoryBreakdown {
  if (_categoryBreakdown is EqualUnmodifiableListView) return _categoryBreakdown;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categoryBreakdown);
}

 final  List<DashboardBudgetItemDto> _budgets;
@override List<DashboardBudgetItemDto> get budgets {
  if (_budgets is EqualUnmodifiableListView) return _budgets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_budgets);
}

 final  List<LatestTransactionItemDto> _latestTransactions;
@override List<LatestTransactionItemDto> get latestTransactions {
  if (_latestTransactions is EqualUnmodifiableListView) return _latestTransactions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_latestTransactions);
}


/// Create a copy of DashboardPayloadDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardPayloadDtoCopyWith<_DashboardPayloadDto> get copyWith => __$DashboardPayloadDtoCopyWithImpl<_DashboardPayloadDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardPayloadDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardPayloadDto&&(identical(other.totalBalance, totalBalance) || other.totalBalance == totalBalance)&&(identical(other.periodIncome, periodIncome) || other.periodIncome == periodIncome)&&(identical(other.periodExpense, periodExpense) || other.periodExpense == periodExpense)&&(identical(other.periodFrom, periodFrom) || other.periodFrom == periodFrom)&&(identical(other.periodTo, periodTo) || other.periodTo == periodTo)&&const DeepCollectionEquality().equals(other._dailyTrend, _dailyTrend)&&const DeepCollectionEquality().equals(other._categoryBreakdown, _categoryBreakdown)&&const DeepCollectionEquality().equals(other._budgets, _budgets)&&const DeepCollectionEquality().equals(other._latestTransactions, _latestTransactions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalBalance,periodIncome,periodExpense,periodFrom,periodTo,const DeepCollectionEquality().hash(_dailyTrend),const DeepCollectionEquality().hash(_categoryBreakdown),const DeepCollectionEquality().hash(_budgets),const DeepCollectionEquality().hash(_latestTransactions));

@override
String toString() {
  return 'DashboardPayloadDto(totalBalance: $totalBalance, periodIncome: $periodIncome, periodExpense: $periodExpense, periodFrom: $periodFrom, periodTo: $periodTo, dailyTrend: $dailyTrend, categoryBreakdown: $categoryBreakdown, budgets: $budgets, latestTransactions: $latestTransactions)';
}


}

/// @nodoc
abstract mixin class _$DashboardPayloadDtoCopyWith<$Res> implements $DashboardPayloadDtoCopyWith<$Res> {
  factory _$DashboardPayloadDtoCopyWith(_DashboardPayloadDto value, $Res Function(_DashboardPayloadDto) _then) = __$DashboardPayloadDtoCopyWithImpl;
@override @useResult
$Res call({
 int totalBalance, int periodIncome, int periodExpense, String periodFrom, String periodTo, List<DailyTrendPointDto> dailyTrend, List<CategoryBreakdownItemDto> categoryBreakdown, List<DashboardBudgetItemDto> budgets, List<LatestTransactionItemDto> latestTransactions
});




}
/// @nodoc
class __$DashboardPayloadDtoCopyWithImpl<$Res>
    implements _$DashboardPayloadDtoCopyWith<$Res> {
  __$DashboardPayloadDtoCopyWithImpl(this._self, this._then);

  final _DashboardPayloadDto _self;
  final $Res Function(_DashboardPayloadDto) _then;

/// Create a copy of DashboardPayloadDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalBalance = null,Object? periodIncome = null,Object? periodExpense = null,Object? periodFrom = null,Object? periodTo = null,Object? dailyTrend = null,Object? categoryBreakdown = null,Object? budgets = null,Object? latestTransactions = null,}) {
  return _then(_DashboardPayloadDto(
totalBalance: null == totalBalance ? _self.totalBalance : totalBalance // ignore: cast_nullable_to_non_nullable
as int,periodIncome: null == periodIncome ? _self.periodIncome : periodIncome // ignore: cast_nullable_to_non_nullable
as int,periodExpense: null == periodExpense ? _self.periodExpense : periodExpense // ignore: cast_nullable_to_non_nullable
as int,periodFrom: null == periodFrom ? _self.periodFrom : periodFrom // ignore: cast_nullable_to_non_nullable
as String,periodTo: null == periodTo ? _self.periodTo : periodTo // ignore: cast_nullable_to_non_nullable
as String,dailyTrend: null == dailyTrend ? _self._dailyTrend : dailyTrend // ignore: cast_nullable_to_non_nullable
as List<DailyTrendPointDto>,categoryBreakdown: null == categoryBreakdown ? _self._categoryBreakdown : categoryBreakdown // ignore: cast_nullable_to_non_nullable
as List<CategoryBreakdownItemDto>,budgets: null == budgets ? _self._budgets : budgets // ignore: cast_nullable_to_non_nullable
as List<DashboardBudgetItemDto>,latestTransactions: null == latestTransactions ? _self._latestTransactions : latestTransactions // ignore: cast_nullable_to_non_nullable
as List<LatestTransactionItemDto>,
  ));
}


}


/// @nodoc
mixin _$StatsCategoryBreakdownDto {

 String get name; int get value; bool get archived;
/// Create a copy of StatsCategoryBreakdownDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StatsCategoryBreakdownDtoCopyWith<StatsCategoryBreakdownDto> get copyWith => _$StatsCategoryBreakdownDtoCopyWithImpl<StatsCategoryBreakdownDto>(this as StatsCategoryBreakdownDto, _$identity);

  /// Serializes this StatsCategoryBreakdownDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StatsCategoryBreakdownDto&&(identical(other.name, name) || other.name == name)&&(identical(other.value, value) || other.value == value)&&(identical(other.archived, archived) || other.archived == archived));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,value,archived);

@override
String toString() {
  return 'StatsCategoryBreakdownDto(name: $name, value: $value, archived: $archived)';
}


}

/// @nodoc
abstract mixin class $StatsCategoryBreakdownDtoCopyWith<$Res>  {
  factory $StatsCategoryBreakdownDtoCopyWith(StatsCategoryBreakdownDto value, $Res Function(StatsCategoryBreakdownDto) _then) = _$StatsCategoryBreakdownDtoCopyWithImpl;
@useResult
$Res call({
 String name, int value, bool archived
});




}
/// @nodoc
class _$StatsCategoryBreakdownDtoCopyWithImpl<$Res>
    implements $StatsCategoryBreakdownDtoCopyWith<$Res> {
  _$StatsCategoryBreakdownDtoCopyWithImpl(this._self, this._then);

  final StatsCategoryBreakdownDto _self;
  final $Res Function(StatsCategoryBreakdownDto) _then;

/// Create a copy of StatsCategoryBreakdownDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? value = null,Object? archived = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as int,archived: null == archived ? _self.archived : archived // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [StatsCategoryBreakdownDto].
extension StatsCategoryBreakdownDtoPatterns on StatsCategoryBreakdownDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StatsCategoryBreakdownDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StatsCategoryBreakdownDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StatsCategoryBreakdownDto value)  $default,){
final _that = this;
switch (_that) {
case _StatsCategoryBreakdownDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StatsCategoryBreakdownDto value)?  $default,){
final _that = this;
switch (_that) {
case _StatsCategoryBreakdownDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  int value,  bool archived)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StatsCategoryBreakdownDto() when $default != null:
return $default(_that.name,_that.value,_that.archived);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  int value,  bool archived)  $default,) {final _that = this;
switch (_that) {
case _StatsCategoryBreakdownDto():
return $default(_that.name,_that.value,_that.archived);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  int value,  bool archived)?  $default,) {final _that = this;
switch (_that) {
case _StatsCategoryBreakdownDto() when $default != null:
return $default(_that.name,_that.value,_that.archived);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StatsCategoryBreakdownDto implements StatsCategoryBreakdownDto {
  const _StatsCategoryBreakdownDto({required this.name, required this.value, required this.archived});
  factory _StatsCategoryBreakdownDto.fromJson(Map<String, dynamic> json) => _$StatsCategoryBreakdownDtoFromJson(json);

@override final  String name;
@override final  int value;
@override final  bool archived;

/// Create a copy of StatsCategoryBreakdownDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StatsCategoryBreakdownDtoCopyWith<_StatsCategoryBreakdownDto> get copyWith => __$StatsCategoryBreakdownDtoCopyWithImpl<_StatsCategoryBreakdownDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StatsCategoryBreakdownDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StatsCategoryBreakdownDto&&(identical(other.name, name) || other.name == name)&&(identical(other.value, value) || other.value == value)&&(identical(other.archived, archived) || other.archived == archived));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,value,archived);

@override
String toString() {
  return 'StatsCategoryBreakdownDto(name: $name, value: $value, archived: $archived)';
}


}

/// @nodoc
abstract mixin class _$StatsCategoryBreakdownDtoCopyWith<$Res> implements $StatsCategoryBreakdownDtoCopyWith<$Res> {
  factory _$StatsCategoryBreakdownDtoCopyWith(_StatsCategoryBreakdownDto value, $Res Function(_StatsCategoryBreakdownDto) _then) = __$StatsCategoryBreakdownDtoCopyWithImpl;
@override @useResult
$Res call({
 String name, int value, bool archived
});




}
/// @nodoc
class __$StatsCategoryBreakdownDtoCopyWithImpl<$Res>
    implements _$StatsCategoryBreakdownDtoCopyWith<$Res> {
  __$StatsCategoryBreakdownDtoCopyWithImpl(this._self, this._then);

  final _StatsCategoryBreakdownDto _self;
  final $Res Function(_StatsCategoryBreakdownDto) _then;

/// Create a copy of StatsCategoryBreakdownDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? value = null,Object? archived = null,}) {
  return _then(_StatsCategoryBreakdownDto(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as int,archived: null == archived ? _self.archived : archived // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$WeeklyExpenseDto {

 String get week; int get total;
/// Create a copy of WeeklyExpenseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeeklyExpenseDtoCopyWith<WeeklyExpenseDto> get copyWith => _$WeeklyExpenseDtoCopyWithImpl<WeeklyExpenseDto>(this as WeeklyExpenseDto, _$identity);

  /// Serializes this WeeklyExpenseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeeklyExpenseDto&&(identical(other.week, week) || other.week == week)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,week,total);

@override
String toString() {
  return 'WeeklyExpenseDto(week: $week, total: $total)';
}


}

/// @nodoc
abstract mixin class $WeeklyExpenseDtoCopyWith<$Res>  {
  factory $WeeklyExpenseDtoCopyWith(WeeklyExpenseDto value, $Res Function(WeeklyExpenseDto) _then) = _$WeeklyExpenseDtoCopyWithImpl;
@useResult
$Res call({
 String week, int total
});




}
/// @nodoc
class _$WeeklyExpenseDtoCopyWithImpl<$Res>
    implements $WeeklyExpenseDtoCopyWith<$Res> {
  _$WeeklyExpenseDtoCopyWithImpl(this._self, this._then);

  final WeeklyExpenseDto _self;
  final $Res Function(WeeklyExpenseDto) _then;

/// Create a copy of WeeklyExpenseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? week = null,Object? total = null,}) {
  return _then(_self.copyWith(
week: null == week ? _self.week : week // ignore: cast_nullable_to_non_nullable
as String,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [WeeklyExpenseDto].
extension WeeklyExpenseDtoPatterns on WeeklyExpenseDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeeklyExpenseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeeklyExpenseDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeeklyExpenseDto value)  $default,){
final _that = this;
switch (_that) {
case _WeeklyExpenseDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeeklyExpenseDto value)?  $default,){
final _that = this;
switch (_that) {
case _WeeklyExpenseDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String week,  int total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeeklyExpenseDto() when $default != null:
return $default(_that.week,_that.total);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String week,  int total)  $default,) {final _that = this;
switch (_that) {
case _WeeklyExpenseDto():
return $default(_that.week,_that.total);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String week,  int total)?  $default,) {final _that = this;
switch (_that) {
case _WeeklyExpenseDto() when $default != null:
return $default(_that.week,_that.total);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WeeklyExpenseDto implements WeeklyExpenseDto {
  const _WeeklyExpenseDto({required this.week, required this.total});
  factory _WeeklyExpenseDto.fromJson(Map<String, dynamic> json) => _$WeeklyExpenseDtoFromJson(json);

@override final  String week;
@override final  int total;

/// Create a copy of WeeklyExpenseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeeklyExpenseDtoCopyWith<_WeeklyExpenseDto> get copyWith => __$WeeklyExpenseDtoCopyWithImpl<_WeeklyExpenseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WeeklyExpenseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeeklyExpenseDto&&(identical(other.week, week) || other.week == week)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,week,total);

@override
String toString() {
  return 'WeeklyExpenseDto(week: $week, total: $total)';
}


}

/// @nodoc
abstract mixin class _$WeeklyExpenseDtoCopyWith<$Res> implements $WeeklyExpenseDtoCopyWith<$Res> {
  factory _$WeeklyExpenseDtoCopyWith(_WeeklyExpenseDto value, $Res Function(_WeeklyExpenseDto) _then) = __$WeeklyExpenseDtoCopyWithImpl;
@override @useResult
$Res call({
 String week, int total
});




}
/// @nodoc
class __$WeeklyExpenseDtoCopyWithImpl<$Res>
    implements _$WeeklyExpenseDtoCopyWith<$Res> {
  __$WeeklyExpenseDtoCopyWithImpl(this._self, this._then);

  final _WeeklyExpenseDto _self;
  final $Res Function(_WeeklyExpenseDto) _then;

/// Create a copy of WeeklyExpenseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? week = null,Object? total = null,}) {
  return _then(_WeeklyExpenseDto(
week: null == week ? _self.week : week // ignore: cast_nullable_to_non_nullable
as String,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$StatsPayloadDto {

 String get periodFrom; String get periodTo; int get totalIncome; int get totalExpense; List<StatsCategoryBreakdownDto> get categoryBreakdown; List<WeeklyExpenseDto> get weeklyExpense;
/// Create a copy of StatsPayloadDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StatsPayloadDtoCopyWith<StatsPayloadDto> get copyWith => _$StatsPayloadDtoCopyWithImpl<StatsPayloadDto>(this as StatsPayloadDto, _$identity);

  /// Serializes this StatsPayloadDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StatsPayloadDto&&(identical(other.periodFrom, periodFrom) || other.periodFrom == periodFrom)&&(identical(other.periodTo, periodTo) || other.periodTo == periodTo)&&(identical(other.totalIncome, totalIncome) || other.totalIncome == totalIncome)&&(identical(other.totalExpense, totalExpense) || other.totalExpense == totalExpense)&&const DeepCollectionEquality().equals(other.categoryBreakdown, categoryBreakdown)&&const DeepCollectionEquality().equals(other.weeklyExpense, weeklyExpense));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,periodFrom,periodTo,totalIncome,totalExpense,const DeepCollectionEquality().hash(categoryBreakdown),const DeepCollectionEquality().hash(weeklyExpense));

@override
String toString() {
  return 'StatsPayloadDto(periodFrom: $periodFrom, periodTo: $periodTo, totalIncome: $totalIncome, totalExpense: $totalExpense, categoryBreakdown: $categoryBreakdown, weeklyExpense: $weeklyExpense)';
}


}

/// @nodoc
abstract mixin class $StatsPayloadDtoCopyWith<$Res>  {
  factory $StatsPayloadDtoCopyWith(StatsPayloadDto value, $Res Function(StatsPayloadDto) _then) = _$StatsPayloadDtoCopyWithImpl;
@useResult
$Res call({
 String periodFrom, String periodTo, int totalIncome, int totalExpense, List<StatsCategoryBreakdownDto> categoryBreakdown, List<WeeklyExpenseDto> weeklyExpense
});




}
/// @nodoc
class _$StatsPayloadDtoCopyWithImpl<$Res>
    implements $StatsPayloadDtoCopyWith<$Res> {
  _$StatsPayloadDtoCopyWithImpl(this._self, this._then);

  final StatsPayloadDto _self;
  final $Res Function(StatsPayloadDto) _then;

/// Create a copy of StatsPayloadDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? periodFrom = null,Object? periodTo = null,Object? totalIncome = null,Object? totalExpense = null,Object? categoryBreakdown = null,Object? weeklyExpense = null,}) {
  return _then(_self.copyWith(
periodFrom: null == periodFrom ? _self.periodFrom : periodFrom // ignore: cast_nullable_to_non_nullable
as String,periodTo: null == periodTo ? _self.periodTo : periodTo // ignore: cast_nullable_to_non_nullable
as String,totalIncome: null == totalIncome ? _self.totalIncome : totalIncome // ignore: cast_nullable_to_non_nullable
as int,totalExpense: null == totalExpense ? _self.totalExpense : totalExpense // ignore: cast_nullable_to_non_nullable
as int,categoryBreakdown: null == categoryBreakdown ? _self.categoryBreakdown : categoryBreakdown // ignore: cast_nullable_to_non_nullable
as List<StatsCategoryBreakdownDto>,weeklyExpense: null == weeklyExpense ? _self.weeklyExpense : weeklyExpense // ignore: cast_nullable_to_non_nullable
as List<WeeklyExpenseDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [StatsPayloadDto].
extension StatsPayloadDtoPatterns on StatsPayloadDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StatsPayloadDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StatsPayloadDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StatsPayloadDto value)  $default,){
final _that = this;
switch (_that) {
case _StatsPayloadDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StatsPayloadDto value)?  $default,){
final _that = this;
switch (_that) {
case _StatsPayloadDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String periodFrom,  String periodTo,  int totalIncome,  int totalExpense,  List<StatsCategoryBreakdownDto> categoryBreakdown,  List<WeeklyExpenseDto> weeklyExpense)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StatsPayloadDto() when $default != null:
return $default(_that.periodFrom,_that.periodTo,_that.totalIncome,_that.totalExpense,_that.categoryBreakdown,_that.weeklyExpense);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String periodFrom,  String periodTo,  int totalIncome,  int totalExpense,  List<StatsCategoryBreakdownDto> categoryBreakdown,  List<WeeklyExpenseDto> weeklyExpense)  $default,) {final _that = this;
switch (_that) {
case _StatsPayloadDto():
return $default(_that.periodFrom,_that.periodTo,_that.totalIncome,_that.totalExpense,_that.categoryBreakdown,_that.weeklyExpense);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String periodFrom,  String periodTo,  int totalIncome,  int totalExpense,  List<StatsCategoryBreakdownDto> categoryBreakdown,  List<WeeklyExpenseDto> weeklyExpense)?  $default,) {final _that = this;
switch (_that) {
case _StatsPayloadDto() when $default != null:
return $default(_that.periodFrom,_that.periodTo,_that.totalIncome,_that.totalExpense,_that.categoryBreakdown,_that.weeklyExpense);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StatsPayloadDto implements StatsPayloadDto {
  const _StatsPayloadDto({required this.periodFrom, required this.periodTo, required this.totalIncome, required this.totalExpense, required final  List<StatsCategoryBreakdownDto> categoryBreakdown, required final  List<WeeklyExpenseDto> weeklyExpense}): _categoryBreakdown = categoryBreakdown,_weeklyExpense = weeklyExpense;
  factory _StatsPayloadDto.fromJson(Map<String, dynamic> json) => _$StatsPayloadDtoFromJson(json);

@override final  String periodFrom;
@override final  String periodTo;
@override final  int totalIncome;
@override final  int totalExpense;
 final  List<StatsCategoryBreakdownDto> _categoryBreakdown;
@override List<StatsCategoryBreakdownDto> get categoryBreakdown {
  if (_categoryBreakdown is EqualUnmodifiableListView) return _categoryBreakdown;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categoryBreakdown);
}

 final  List<WeeklyExpenseDto> _weeklyExpense;
@override List<WeeklyExpenseDto> get weeklyExpense {
  if (_weeklyExpense is EqualUnmodifiableListView) return _weeklyExpense;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_weeklyExpense);
}


/// Create a copy of StatsPayloadDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StatsPayloadDtoCopyWith<_StatsPayloadDto> get copyWith => __$StatsPayloadDtoCopyWithImpl<_StatsPayloadDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StatsPayloadDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StatsPayloadDto&&(identical(other.periodFrom, periodFrom) || other.periodFrom == periodFrom)&&(identical(other.periodTo, periodTo) || other.periodTo == periodTo)&&(identical(other.totalIncome, totalIncome) || other.totalIncome == totalIncome)&&(identical(other.totalExpense, totalExpense) || other.totalExpense == totalExpense)&&const DeepCollectionEquality().equals(other._categoryBreakdown, _categoryBreakdown)&&const DeepCollectionEquality().equals(other._weeklyExpense, _weeklyExpense));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,periodFrom,periodTo,totalIncome,totalExpense,const DeepCollectionEquality().hash(_categoryBreakdown),const DeepCollectionEquality().hash(_weeklyExpense));

@override
String toString() {
  return 'StatsPayloadDto(periodFrom: $periodFrom, periodTo: $periodTo, totalIncome: $totalIncome, totalExpense: $totalExpense, categoryBreakdown: $categoryBreakdown, weeklyExpense: $weeklyExpense)';
}


}

/// @nodoc
abstract mixin class _$StatsPayloadDtoCopyWith<$Res> implements $StatsPayloadDtoCopyWith<$Res> {
  factory _$StatsPayloadDtoCopyWith(_StatsPayloadDto value, $Res Function(_StatsPayloadDto) _then) = __$StatsPayloadDtoCopyWithImpl;
@override @useResult
$Res call({
 String periodFrom, String periodTo, int totalIncome, int totalExpense, List<StatsCategoryBreakdownDto> categoryBreakdown, List<WeeklyExpenseDto> weeklyExpense
});




}
/// @nodoc
class __$StatsPayloadDtoCopyWithImpl<$Res>
    implements _$StatsPayloadDtoCopyWith<$Res> {
  __$StatsPayloadDtoCopyWithImpl(this._self, this._then);

  final _StatsPayloadDto _self;
  final $Res Function(_StatsPayloadDto) _then;

/// Create a copy of StatsPayloadDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? periodFrom = null,Object? periodTo = null,Object? totalIncome = null,Object? totalExpense = null,Object? categoryBreakdown = null,Object? weeklyExpense = null,}) {
  return _then(_StatsPayloadDto(
periodFrom: null == periodFrom ? _self.periodFrom : periodFrom // ignore: cast_nullable_to_non_nullable
as String,periodTo: null == periodTo ? _self.periodTo : periodTo // ignore: cast_nullable_to_non_nullable
as String,totalIncome: null == totalIncome ? _self.totalIncome : totalIncome // ignore: cast_nullable_to_non_nullable
as int,totalExpense: null == totalExpense ? _self.totalExpense : totalExpense // ignore: cast_nullable_to_non_nullable
as int,categoryBreakdown: null == categoryBreakdown ? _self._categoryBreakdown : categoryBreakdown // ignore: cast_nullable_to_non_nullable
as List<StatsCategoryBreakdownDto>,weeklyExpense: null == weeklyExpense ? _self._weeklyExpense : weeklyExpense // ignore: cast_nullable_to_non_nullable
as List<WeeklyExpenseDto>,
  ));
}


}

// dart format on
