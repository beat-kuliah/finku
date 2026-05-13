// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budgets_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BudgetDto {

 String get id; String get categoryId; String? get categoryName; int get limitAmount; int get spent; String get periodAnchor; bool get paused; String? get pausedAt;
/// Create a copy of BudgetDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BudgetDtoCopyWith<BudgetDto> get copyWith => _$BudgetDtoCopyWithImpl<BudgetDto>(this as BudgetDto, _$identity);

  /// Serializes this BudgetDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BudgetDto&&(identical(other.id, id) || other.id == id)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.limitAmount, limitAmount) || other.limitAmount == limitAmount)&&(identical(other.spent, spent) || other.spent == spent)&&(identical(other.periodAnchor, periodAnchor) || other.periodAnchor == periodAnchor)&&(identical(other.paused, paused) || other.paused == paused)&&(identical(other.pausedAt, pausedAt) || other.pausedAt == pausedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,categoryId,categoryName,limitAmount,spent,periodAnchor,paused,pausedAt);

@override
String toString() {
  return 'BudgetDto(id: $id, categoryId: $categoryId, categoryName: $categoryName, limitAmount: $limitAmount, spent: $spent, periodAnchor: $periodAnchor, paused: $paused, pausedAt: $pausedAt)';
}


}

/// @nodoc
abstract mixin class $BudgetDtoCopyWith<$Res>  {
  factory $BudgetDtoCopyWith(BudgetDto value, $Res Function(BudgetDto) _then) = _$BudgetDtoCopyWithImpl;
@useResult
$Res call({
 String id, String categoryId, String? categoryName, int limitAmount, int spent, String periodAnchor, bool paused, String? pausedAt
});




}
/// @nodoc
class _$BudgetDtoCopyWithImpl<$Res>
    implements $BudgetDtoCopyWith<$Res> {
  _$BudgetDtoCopyWithImpl(this._self, this._then);

  final BudgetDto _self;
  final $Res Function(BudgetDto) _then;

/// Create a copy of BudgetDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? categoryId = null,Object? categoryName = freezed,Object? limitAmount = null,Object? spent = null,Object? periodAnchor = null,Object? paused = null,Object? pausedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,categoryName: freezed == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String?,limitAmount: null == limitAmount ? _self.limitAmount : limitAmount // ignore: cast_nullable_to_non_nullable
as int,spent: null == spent ? _self.spent : spent // ignore: cast_nullable_to_non_nullable
as int,periodAnchor: null == periodAnchor ? _self.periodAnchor : periodAnchor // ignore: cast_nullable_to_non_nullable
as String,paused: null == paused ? _self.paused : paused // ignore: cast_nullable_to_non_nullable
as bool,pausedAt: freezed == pausedAt ? _self.pausedAt : pausedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BudgetDto].
extension BudgetDtoPatterns on BudgetDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BudgetDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BudgetDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BudgetDto value)  $default,){
final _that = this;
switch (_that) {
case _BudgetDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BudgetDto value)?  $default,){
final _that = this;
switch (_that) {
case _BudgetDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String categoryId,  String? categoryName,  int limitAmount,  int spent,  String periodAnchor,  bool paused,  String? pausedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BudgetDto() when $default != null:
return $default(_that.id,_that.categoryId,_that.categoryName,_that.limitAmount,_that.spent,_that.periodAnchor,_that.paused,_that.pausedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String categoryId,  String? categoryName,  int limitAmount,  int spent,  String periodAnchor,  bool paused,  String? pausedAt)  $default,) {final _that = this;
switch (_that) {
case _BudgetDto():
return $default(_that.id,_that.categoryId,_that.categoryName,_that.limitAmount,_that.spent,_that.periodAnchor,_that.paused,_that.pausedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String categoryId,  String? categoryName,  int limitAmount,  int spent,  String periodAnchor,  bool paused,  String? pausedAt)?  $default,) {final _that = this;
switch (_that) {
case _BudgetDto() when $default != null:
return $default(_that.id,_that.categoryId,_that.categoryName,_that.limitAmount,_that.spent,_that.periodAnchor,_that.paused,_that.pausedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BudgetDto implements BudgetDto {
  const _BudgetDto({required this.id, required this.categoryId, this.categoryName, required this.limitAmount, required this.spent, required this.periodAnchor, required this.paused, this.pausedAt});
  factory _BudgetDto.fromJson(Map<String, dynamic> json) => _$BudgetDtoFromJson(json);

@override final  String id;
@override final  String categoryId;
@override final  String? categoryName;
@override final  int limitAmount;
@override final  int spent;
@override final  String periodAnchor;
@override final  bool paused;
@override final  String? pausedAt;

/// Create a copy of BudgetDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BudgetDtoCopyWith<_BudgetDto> get copyWith => __$BudgetDtoCopyWithImpl<_BudgetDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BudgetDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BudgetDto&&(identical(other.id, id) || other.id == id)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.limitAmount, limitAmount) || other.limitAmount == limitAmount)&&(identical(other.spent, spent) || other.spent == spent)&&(identical(other.periodAnchor, periodAnchor) || other.periodAnchor == periodAnchor)&&(identical(other.paused, paused) || other.paused == paused)&&(identical(other.pausedAt, pausedAt) || other.pausedAt == pausedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,categoryId,categoryName,limitAmount,spent,periodAnchor,paused,pausedAt);

@override
String toString() {
  return 'BudgetDto(id: $id, categoryId: $categoryId, categoryName: $categoryName, limitAmount: $limitAmount, spent: $spent, periodAnchor: $periodAnchor, paused: $paused, pausedAt: $pausedAt)';
}


}

/// @nodoc
abstract mixin class _$BudgetDtoCopyWith<$Res> implements $BudgetDtoCopyWith<$Res> {
  factory _$BudgetDtoCopyWith(_BudgetDto value, $Res Function(_BudgetDto) _then) = __$BudgetDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String categoryId, String? categoryName, int limitAmount, int spent, String periodAnchor, bool paused, String? pausedAt
});




}
/// @nodoc
class __$BudgetDtoCopyWithImpl<$Res>
    implements _$BudgetDtoCopyWith<$Res> {
  __$BudgetDtoCopyWithImpl(this._self, this._then);

  final _BudgetDto _self;
  final $Res Function(_BudgetDto) _then;

/// Create a copy of BudgetDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? categoryId = null,Object? categoryName = freezed,Object? limitAmount = null,Object? spent = null,Object? periodAnchor = null,Object? paused = null,Object? pausedAt = freezed,}) {
  return _then(_BudgetDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,categoryName: freezed == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String?,limitAmount: null == limitAmount ? _self.limitAmount : limitAmount // ignore: cast_nullable_to_non_nullable
as int,spent: null == spent ? _self.spent : spent // ignore: cast_nullable_to_non_nullable
as int,periodAnchor: null == periodAnchor ? _self.periodAnchor : periodAnchor // ignore: cast_nullable_to_non_nullable
as String,paused: null == paused ? _self.paused : paused // ignore: cast_nullable_to_non_nullable
as bool,pausedAt: freezed == pausedAt ? _self.pausedAt : pausedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ListBudgetsResponseDto {

 List<BudgetDto> get budgets;
/// Create a copy of ListBudgetsResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ListBudgetsResponseDtoCopyWith<ListBudgetsResponseDto> get copyWith => _$ListBudgetsResponseDtoCopyWithImpl<ListBudgetsResponseDto>(this as ListBudgetsResponseDto, _$identity);

  /// Serializes this ListBudgetsResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ListBudgetsResponseDto&&const DeepCollectionEquality().equals(other.budgets, budgets));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(budgets));

@override
String toString() {
  return 'ListBudgetsResponseDto(budgets: $budgets)';
}


}

/// @nodoc
abstract mixin class $ListBudgetsResponseDtoCopyWith<$Res>  {
  factory $ListBudgetsResponseDtoCopyWith(ListBudgetsResponseDto value, $Res Function(ListBudgetsResponseDto) _then) = _$ListBudgetsResponseDtoCopyWithImpl;
@useResult
$Res call({
 List<BudgetDto> budgets
});




}
/// @nodoc
class _$ListBudgetsResponseDtoCopyWithImpl<$Res>
    implements $ListBudgetsResponseDtoCopyWith<$Res> {
  _$ListBudgetsResponseDtoCopyWithImpl(this._self, this._then);

  final ListBudgetsResponseDto _self;
  final $Res Function(ListBudgetsResponseDto) _then;

/// Create a copy of ListBudgetsResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? budgets = null,}) {
  return _then(_self.copyWith(
budgets: null == budgets ? _self.budgets : budgets // ignore: cast_nullable_to_non_nullable
as List<BudgetDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [ListBudgetsResponseDto].
extension ListBudgetsResponseDtoPatterns on ListBudgetsResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ListBudgetsResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ListBudgetsResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ListBudgetsResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _ListBudgetsResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ListBudgetsResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _ListBudgetsResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<BudgetDto> budgets)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ListBudgetsResponseDto() when $default != null:
return $default(_that.budgets);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<BudgetDto> budgets)  $default,) {final _that = this;
switch (_that) {
case _ListBudgetsResponseDto():
return $default(_that.budgets);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<BudgetDto> budgets)?  $default,) {final _that = this;
switch (_that) {
case _ListBudgetsResponseDto() when $default != null:
return $default(_that.budgets);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ListBudgetsResponseDto implements ListBudgetsResponseDto {
  const _ListBudgetsResponseDto({required final  List<BudgetDto> budgets}): _budgets = budgets;
  factory _ListBudgetsResponseDto.fromJson(Map<String, dynamic> json) => _$ListBudgetsResponseDtoFromJson(json);

 final  List<BudgetDto> _budgets;
@override List<BudgetDto> get budgets {
  if (_budgets is EqualUnmodifiableListView) return _budgets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_budgets);
}


/// Create a copy of ListBudgetsResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ListBudgetsResponseDtoCopyWith<_ListBudgetsResponseDto> get copyWith => __$ListBudgetsResponseDtoCopyWithImpl<_ListBudgetsResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ListBudgetsResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ListBudgetsResponseDto&&const DeepCollectionEquality().equals(other._budgets, _budgets));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_budgets));

@override
String toString() {
  return 'ListBudgetsResponseDto(budgets: $budgets)';
}


}

/// @nodoc
abstract mixin class _$ListBudgetsResponseDtoCopyWith<$Res> implements $ListBudgetsResponseDtoCopyWith<$Res> {
  factory _$ListBudgetsResponseDtoCopyWith(_ListBudgetsResponseDto value, $Res Function(_ListBudgetsResponseDto) _then) = __$ListBudgetsResponseDtoCopyWithImpl;
@override @useResult
$Res call({
 List<BudgetDto> budgets
});




}
/// @nodoc
class __$ListBudgetsResponseDtoCopyWithImpl<$Res>
    implements _$ListBudgetsResponseDtoCopyWith<$Res> {
  __$ListBudgetsResponseDtoCopyWithImpl(this._self, this._then);

  final _ListBudgetsResponseDto _self;
  final $Res Function(_ListBudgetsResponseDto) _then;

/// Create a copy of ListBudgetsResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? budgets = null,}) {
  return _then(_ListBudgetsResponseDto(
budgets: null == budgets ? _self._budgets : budgets // ignore: cast_nullable_to_non_nullable
as List<BudgetDto>,
  ));
}


}


/// @nodoc
mixin _$BudgetEnvelopeDto {

 BudgetDto get budget;
/// Create a copy of BudgetEnvelopeDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BudgetEnvelopeDtoCopyWith<BudgetEnvelopeDto> get copyWith => _$BudgetEnvelopeDtoCopyWithImpl<BudgetEnvelopeDto>(this as BudgetEnvelopeDto, _$identity);

  /// Serializes this BudgetEnvelopeDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BudgetEnvelopeDto&&(identical(other.budget, budget) || other.budget == budget));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,budget);

@override
String toString() {
  return 'BudgetEnvelopeDto(budget: $budget)';
}


}

/// @nodoc
abstract mixin class $BudgetEnvelopeDtoCopyWith<$Res>  {
  factory $BudgetEnvelopeDtoCopyWith(BudgetEnvelopeDto value, $Res Function(BudgetEnvelopeDto) _then) = _$BudgetEnvelopeDtoCopyWithImpl;
@useResult
$Res call({
 BudgetDto budget
});


$BudgetDtoCopyWith<$Res> get budget;

}
/// @nodoc
class _$BudgetEnvelopeDtoCopyWithImpl<$Res>
    implements $BudgetEnvelopeDtoCopyWith<$Res> {
  _$BudgetEnvelopeDtoCopyWithImpl(this._self, this._then);

  final BudgetEnvelopeDto _self;
  final $Res Function(BudgetEnvelopeDto) _then;

/// Create a copy of BudgetEnvelopeDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? budget = null,}) {
  return _then(_self.copyWith(
budget: null == budget ? _self.budget : budget // ignore: cast_nullable_to_non_nullable
as BudgetDto,
  ));
}
/// Create a copy of BudgetEnvelopeDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BudgetDtoCopyWith<$Res> get budget {
  
  return $BudgetDtoCopyWith<$Res>(_self.budget, (value) {
    return _then(_self.copyWith(budget: value));
  });
}
}


/// Adds pattern-matching-related methods to [BudgetEnvelopeDto].
extension BudgetEnvelopeDtoPatterns on BudgetEnvelopeDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BudgetEnvelopeDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BudgetEnvelopeDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BudgetEnvelopeDto value)  $default,){
final _that = this;
switch (_that) {
case _BudgetEnvelopeDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BudgetEnvelopeDto value)?  $default,){
final _that = this;
switch (_that) {
case _BudgetEnvelopeDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( BudgetDto budget)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BudgetEnvelopeDto() when $default != null:
return $default(_that.budget);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( BudgetDto budget)  $default,) {final _that = this;
switch (_that) {
case _BudgetEnvelopeDto():
return $default(_that.budget);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( BudgetDto budget)?  $default,) {final _that = this;
switch (_that) {
case _BudgetEnvelopeDto() when $default != null:
return $default(_that.budget);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BudgetEnvelopeDto implements BudgetEnvelopeDto {
  const _BudgetEnvelopeDto({required this.budget});
  factory _BudgetEnvelopeDto.fromJson(Map<String, dynamic> json) => _$BudgetEnvelopeDtoFromJson(json);

@override final  BudgetDto budget;

/// Create a copy of BudgetEnvelopeDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BudgetEnvelopeDtoCopyWith<_BudgetEnvelopeDto> get copyWith => __$BudgetEnvelopeDtoCopyWithImpl<_BudgetEnvelopeDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BudgetEnvelopeDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BudgetEnvelopeDto&&(identical(other.budget, budget) || other.budget == budget));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,budget);

@override
String toString() {
  return 'BudgetEnvelopeDto(budget: $budget)';
}


}

/// @nodoc
abstract mixin class _$BudgetEnvelopeDtoCopyWith<$Res> implements $BudgetEnvelopeDtoCopyWith<$Res> {
  factory _$BudgetEnvelopeDtoCopyWith(_BudgetEnvelopeDto value, $Res Function(_BudgetEnvelopeDto) _then) = __$BudgetEnvelopeDtoCopyWithImpl;
@override @useResult
$Res call({
 BudgetDto budget
});


@override $BudgetDtoCopyWith<$Res> get budget;

}
/// @nodoc
class __$BudgetEnvelopeDtoCopyWithImpl<$Res>
    implements _$BudgetEnvelopeDtoCopyWith<$Res> {
  __$BudgetEnvelopeDtoCopyWithImpl(this._self, this._then);

  final _BudgetEnvelopeDto _self;
  final $Res Function(_BudgetEnvelopeDto) _then;

/// Create a copy of BudgetEnvelopeDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? budget = null,}) {
  return _then(_BudgetEnvelopeDto(
budget: null == budget ? _self.budget : budget // ignore: cast_nullable_to_non_nullable
as BudgetDto,
  ));
}

/// Create a copy of BudgetEnvelopeDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BudgetDtoCopyWith<$Res> get budget {
  
  return $BudgetDtoCopyWith<$Res>(_self.budget, (value) {
    return _then(_self.copyWith(budget: value));
  });
}
}

// dart format on
