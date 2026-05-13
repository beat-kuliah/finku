// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'goals_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GoalDto {

 String get id; String get userId; String get name; int get targetAmount; int get currentAmount; String? get deadline; double? get progressPct; String get createdAt; String get updatedAt;
/// Create a copy of GoalDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GoalDtoCopyWith<GoalDto> get copyWith => _$GoalDtoCopyWithImpl<GoalDto>(this as GoalDto, _$identity);

  /// Serializes this GoalDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GoalDto&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.targetAmount, targetAmount) || other.targetAmount == targetAmount)&&(identical(other.currentAmount, currentAmount) || other.currentAmount == currentAmount)&&(identical(other.deadline, deadline) || other.deadline == deadline)&&(identical(other.progressPct, progressPct) || other.progressPct == progressPct)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,name,targetAmount,currentAmount,deadline,progressPct,createdAt,updatedAt);

@override
String toString() {
  return 'GoalDto(id: $id, userId: $userId, name: $name, targetAmount: $targetAmount, currentAmount: $currentAmount, deadline: $deadline, progressPct: $progressPct, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $GoalDtoCopyWith<$Res>  {
  factory $GoalDtoCopyWith(GoalDto value, $Res Function(GoalDto) _then) = _$GoalDtoCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String name, int targetAmount, int currentAmount, String? deadline, double? progressPct, String createdAt, String updatedAt
});




}
/// @nodoc
class _$GoalDtoCopyWithImpl<$Res>
    implements $GoalDtoCopyWith<$Res> {
  _$GoalDtoCopyWithImpl(this._self, this._then);

  final GoalDto _self;
  final $Res Function(GoalDto) _then;

/// Create a copy of GoalDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? name = null,Object? targetAmount = null,Object? currentAmount = null,Object? deadline = freezed,Object? progressPct = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,targetAmount: null == targetAmount ? _self.targetAmount : targetAmount // ignore: cast_nullable_to_non_nullable
as int,currentAmount: null == currentAmount ? _self.currentAmount : currentAmount // ignore: cast_nullable_to_non_nullable
as int,deadline: freezed == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as String?,progressPct: freezed == progressPct ? _self.progressPct : progressPct // ignore: cast_nullable_to_non_nullable
as double?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GoalDto].
extension GoalDtoPatterns on GoalDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GoalDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GoalDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GoalDto value)  $default,){
final _that = this;
switch (_that) {
case _GoalDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GoalDto value)?  $default,){
final _that = this;
switch (_that) {
case _GoalDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String name,  int targetAmount,  int currentAmount,  String? deadline,  double? progressPct,  String createdAt,  String updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GoalDto() when $default != null:
return $default(_that.id,_that.userId,_that.name,_that.targetAmount,_that.currentAmount,_that.deadline,_that.progressPct,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String name,  int targetAmount,  int currentAmount,  String? deadline,  double? progressPct,  String createdAt,  String updatedAt)  $default,) {final _that = this;
switch (_that) {
case _GoalDto():
return $default(_that.id,_that.userId,_that.name,_that.targetAmount,_that.currentAmount,_that.deadline,_that.progressPct,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String name,  int targetAmount,  int currentAmount,  String? deadline,  double? progressPct,  String createdAt,  String updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _GoalDto() when $default != null:
return $default(_that.id,_that.userId,_that.name,_that.targetAmount,_that.currentAmount,_that.deadline,_that.progressPct,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GoalDto implements GoalDto {
  const _GoalDto({required this.id, required this.userId, required this.name, required this.targetAmount, required this.currentAmount, this.deadline, this.progressPct, required this.createdAt, required this.updatedAt});
  factory _GoalDto.fromJson(Map<String, dynamic> json) => _$GoalDtoFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String name;
@override final  int targetAmount;
@override final  int currentAmount;
@override final  String? deadline;
@override final  double? progressPct;
@override final  String createdAt;
@override final  String updatedAt;

/// Create a copy of GoalDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GoalDtoCopyWith<_GoalDto> get copyWith => __$GoalDtoCopyWithImpl<_GoalDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GoalDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GoalDto&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.targetAmount, targetAmount) || other.targetAmount == targetAmount)&&(identical(other.currentAmount, currentAmount) || other.currentAmount == currentAmount)&&(identical(other.deadline, deadline) || other.deadline == deadline)&&(identical(other.progressPct, progressPct) || other.progressPct == progressPct)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,name,targetAmount,currentAmount,deadline,progressPct,createdAt,updatedAt);

@override
String toString() {
  return 'GoalDto(id: $id, userId: $userId, name: $name, targetAmount: $targetAmount, currentAmount: $currentAmount, deadline: $deadline, progressPct: $progressPct, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$GoalDtoCopyWith<$Res> implements $GoalDtoCopyWith<$Res> {
  factory _$GoalDtoCopyWith(_GoalDto value, $Res Function(_GoalDto) _then) = __$GoalDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String name, int targetAmount, int currentAmount, String? deadline, double? progressPct, String createdAt, String updatedAt
});




}
/// @nodoc
class __$GoalDtoCopyWithImpl<$Res>
    implements _$GoalDtoCopyWith<$Res> {
  __$GoalDtoCopyWithImpl(this._self, this._then);

  final _GoalDto _self;
  final $Res Function(_GoalDto) _then;

/// Create a copy of GoalDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? name = null,Object? targetAmount = null,Object? currentAmount = null,Object? deadline = freezed,Object? progressPct = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_GoalDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,targetAmount: null == targetAmount ? _self.targetAmount : targetAmount // ignore: cast_nullable_to_non_nullable
as int,currentAmount: null == currentAmount ? _self.currentAmount : currentAmount // ignore: cast_nullable_to_non_nullable
as int,deadline: freezed == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as String?,progressPct: freezed == progressPct ? _self.progressPct : progressPct // ignore: cast_nullable_to_non_nullable
as double?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ListGoalsResponseDto {

 List<GoalDto> get goals;
/// Create a copy of ListGoalsResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ListGoalsResponseDtoCopyWith<ListGoalsResponseDto> get copyWith => _$ListGoalsResponseDtoCopyWithImpl<ListGoalsResponseDto>(this as ListGoalsResponseDto, _$identity);

  /// Serializes this ListGoalsResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ListGoalsResponseDto&&const DeepCollectionEquality().equals(other.goals, goals));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(goals));

@override
String toString() {
  return 'ListGoalsResponseDto(goals: $goals)';
}


}

/// @nodoc
abstract mixin class $ListGoalsResponseDtoCopyWith<$Res>  {
  factory $ListGoalsResponseDtoCopyWith(ListGoalsResponseDto value, $Res Function(ListGoalsResponseDto) _then) = _$ListGoalsResponseDtoCopyWithImpl;
@useResult
$Res call({
 List<GoalDto> goals
});




}
/// @nodoc
class _$ListGoalsResponseDtoCopyWithImpl<$Res>
    implements $ListGoalsResponseDtoCopyWith<$Res> {
  _$ListGoalsResponseDtoCopyWithImpl(this._self, this._then);

  final ListGoalsResponseDto _self;
  final $Res Function(ListGoalsResponseDto) _then;

/// Create a copy of ListGoalsResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? goals = null,}) {
  return _then(_self.copyWith(
goals: null == goals ? _self.goals : goals // ignore: cast_nullable_to_non_nullable
as List<GoalDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [ListGoalsResponseDto].
extension ListGoalsResponseDtoPatterns on ListGoalsResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ListGoalsResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ListGoalsResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ListGoalsResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _ListGoalsResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ListGoalsResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _ListGoalsResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<GoalDto> goals)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ListGoalsResponseDto() when $default != null:
return $default(_that.goals);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<GoalDto> goals)  $default,) {final _that = this;
switch (_that) {
case _ListGoalsResponseDto():
return $default(_that.goals);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<GoalDto> goals)?  $default,) {final _that = this;
switch (_that) {
case _ListGoalsResponseDto() when $default != null:
return $default(_that.goals);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ListGoalsResponseDto implements ListGoalsResponseDto {
  const _ListGoalsResponseDto({required final  List<GoalDto> goals}): _goals = goals;
  factory _ListGoalsResponseDto.fromJson(Map<String, dynamic> json) => _$ListGoalsResponseDtoFromJson(json);

 final  List<GoalDto> _goals;
@override List<GoalDto> get goals {
  if (_goals is EqualUnmodifiableListView) return _goals;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_goals);
}


/// Create a copy of ListGoalsResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ListGoalsResponseDtoCopyWith<_ListGoalsResponseDto> get copyWith => __$ListGoalsResponseDtoCopyWithImpl<_ListGoalsResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ListGoalsResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ListGoalsResponseDto&&const DeepCollectionEquality().equals(other._goals, _goals));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_goals));

@override
String toString() {
  return 'ListGoalsResponseDto(goals: $goals)';
}


}

/// @nodoc
abstract mixin class _$ListGoalsResponseDtoCopyWith<$Res> implements $ListGoalsResponseDtoCopyWith<$Res> {
  factory _$ListGoalsResponseDtoCopyWith(_ListGoalsResponseDto value, $Res Function(_ListGoalsResponseDto) _then) = __$ListGoalsResponseDtoCopyWithImpl;
@override @useResult
$Res call({
 List<GoalDto> goals
});




}
/// @nodoc
class __$ListGoalsResponseDtoCopyWithImpl<$Res>
    implements _$ListGoalsResponseDtoCopyWith<$Res> {
  __$ListGoalsResponseDtoCopyWithImpl(this._self, this._then);

  final _ListGoalsResponseDto _self;
  final $Res Function(_ListGoalsResponseDto) _then;

/// Create a copy of ListGoalsResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? goals = null,}) {
  return _then(_ListGoalsResponseDto(
goals: null == goals ? _self._goals : goals // ignore: cast_nullable_to_non_nullable
as List<GoalDto>,
  ));
}


}


/// @nodoc
mixin _$GoalEnvelopeDto {

 GoalDto get goal;
/// Create a copy of GoalEnvelopeDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GoalEnvelopeDtoCopyWith<GoalEnvelopeDto> get copyWith => _$GoalEnvelopeDtoCopyWithImpl<GoalEnvelopeDto>(this as GoalEnvelopeDto, _$identity);

  /// Serializes this GoalEnvelopeDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GoalEnvelopeDto&&(identical(other.goal, goal) || other.goal == goal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,goal);

@override
String toString() {
  return 'GoalEnvelopeDto(goal: $goal)';
}


}

/// @nodoc
abstract mixin class $GoalEnvelopeDtoCopyWith<$Res>  {
  factory $GoalEnvelopeDtoCopyWith(GoalEnvelopeDto value, $Res Function(GoalEnvelopeDto) _then) = _$GoalEnvelopeDtoCopyWithImpl;
@useResult
$Res call({
 GoalDto goal
});


$GoalDtoCopyWith<$Res> get goal;

}
/// @nodoc
class _$GoalEnvelopeDtoCopyWithImpl<$Res>
    implements $GoalEnvelopeDtoCopyWith<$Res> {
  _$GoalEnvelopeDtoCopyWithImpl(this._self, this._then);

  final GoalEnvelopeDto _self;
  final $Res Function(GoalEnvelopeDto) _then;

/// Create a copy of GoalEnvelopeDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? goal = null,}) {
  return _then(_self.copyWith(
goal: null == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as GoalDto,
  ));
}
/// Create a copy of GoalEnvelopeDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GoalDtoCopyWith<$Res> get goal {
  
  return $GoalDtoCopyWith<$Res>(_self.goal, (value) {
    return _then(_self.copyWith(goal: value));
  });
}
}


/// Adds pattern-matching-related methods to [GoalEnvelopeDto].
extension GoalEnvelopeDtoPatterns on GoalEnvelopeDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GoalEnvelopeDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GoalEnvelopeDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GoalEnvelopeDto value)  $default,){
final _that = this;
switch (_that) {
case _GoalEnvelopeDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GoalEnvelopeDto value)?  $default,){
final _that = this;
switch (_that) {
case _GoalEnvelopeDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( GoalDto goal)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GoalEnvelopeDto() when $default != null:
return $default(_that.goal);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( GoalDto goal)  $default,) {final _that = this;
switch (_that) {
case _GoalEnvelopeDto():
return $default(_that.goal);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( GoalDto goal)?  $default,) {final _that = this;
switch (_that) {
case _GoalEnvelopeDto() when $default != null:
return $default(_that.goal);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GoalEnvelopeDto implements GoalEnvelopeDto {
  const _GoalEnvelopeDto({required this.goal});
  factory _GoalEnvelopeDto.fromJson(Map<String, dynamic> json) => _$GoalEnvelopeDtoFromJson(json);

@override final  GoalDto goal;

/// Create a copy of GoalEnvelopeDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GoalEnvelopeDtoCopyWith<_GoalEnvelopeDto> get copyWith => __$GoalEnvelopeDtoCopyWithImpl<_GoalEnvelopeDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GoalEnvelopeDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GoalEnvelopeDto&&(identical(other.goal, goal) || other.goal == goal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,goal);

@override
String toString() {
  return 'GoalEnvelopeDto(goal: $goal)';
}


}

/// @nodoc
abstract mixin class _$GoalEnvelopeDtoCopyWith<$Res> implements $GoalEnvelopeDtoCopyWith<$Res> {
  factory _$GoalEnvelopeDtoCopyWith(_GoalEnvelopeDto value, $Res Function(_GoalEnvelopeDto) _then) = __$GoalEnvelopeDtoCopyWithImpl;
@override @useResult
$Res call({
 GoalDto goal
});


@override $GoalDtoCopyWith<$Res> get goal;

}
/// @nodoc
class __$GoalEnvelopeDtoCopyWithImpl<$Res>
    implements _$GoalEnvelopeDtoCopyWith<$Res> {
  __$GoalEnvelopeDtoCopyWithImpl(this._self, this._then);

  final _GoalEnvelopeDto _self;
  final $Res Function(_GoalEnvelopeDto) _then;

/// Create a copy of GoalEnvelopeDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? goal = null,}) {
  return _then(_GoalEnvelopeDto(
goal: null == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as GoalDto,
  ));
}

/// Create a copy of GoalEnvelopeDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GoalDtoCopyWith<$Res> get goal {
  
  return $GoalDtoCopyWith<$Res>(_self.goal, (value) {
    return _then(_self.copyWith(goal: value));
  });
}
}

// dart format on
