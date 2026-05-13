// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'preferences_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PreferencesDto {

 bool get notifyBudgetWarning; bool get notifyReminder; bool get notifyWeeklyReport; String get theme; String? get updatedAt;
/// Create a copy of PreferencesDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PreferencesDtoCopyWith<PreferencesDto> get copyWith => _$PreferencesDtoCopyWithImpl<PreferencesDto>(this as PreferencesDto, _$identity);

  /// Serializes this PreferencesDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PreferencesDto&&(identical(other.notifyBudgetWarning, notifyBudgetWarning) || other.notifyBudgetWarning == notifyBudgetWarning)&&(identical(other.notifyReminder, notifyReminder) || other.notifyReminder == notifyReminder)&&(identical(other.notifyWeeklyReport, notifyWeeklyReport) || other.notifyWeeklyReport == notifyWeeklyReport)&&(identical(other.theme, theme) || other.theme == theme)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,notifyBudgetWarning,notifyReminder,notifyWeeklyReport,theme,updatedAt);

@override
String toString() {
  return 'PreferencesDto(notifyBudgetWarning: $notifyBudgetWarning, notifyReminder: $notifyReminder, notifyWeeklyReport: $notifyWeeklyReport, theme: $theme, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $PreferencesDtoCopyWith<$Res>  {
  factory $PreferencesDtoCopyWith(PreferencesDto value, $Res Function(PreferencesDto) _then) = _$PreferencesDtoCopyWithImpl;
@useResult
$Res call({
 bool notifyBudgetWarning, bool notifyReminder, bool notifyWeeklyReport, String theme, String? updatedAt
});




}
/// @nodoc
class _$PreferencesDtoCopyWithImpl<$Res>
    implements $PreferencesDtoCopyWith<$Res> {
  _$PreferencesDtoCopyWithImpl(this._self, this._then);

  final PreferencesDto _self;
  final $Res Function(PreferencesDto) _then;

/// Create a copy of PreferencesDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? notifyBudgetWarning = null,Object? notifyReminder = null,Object? notifyWeeklyReport = null,Object? theme = null,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
notifyBudgetWarning: null == notifyBudgetWarning ? _self.notifyBudgetWarning : notifyBudgetWarning // ignore: cast_nullable_to_non_nullable
as bool,notifyReminder: null == notifyReminder ? _self.notifyReminder : notifyReminder // ignore: cast_nullable_to_non_nullable
as bool,notifyWeeklyReport: null == notifyWeeklyReport ? _self.notifyWeeklyReport : notifyWeeklyReport // ignore: cast_nullable_to_non_nullable
as bool,theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as String,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PreferencesDto].
extension PreferencesDtoPatterns on PreferencesDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PreferencesDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PreferencesDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PreferencesDto value)  $default,){
final _that = this;
switch (_that) {
case _PreferencesDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PreferencesDto value)?  $default,){
final _that = this;
switch (_that) {
case _PreferencesDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool notifyBudgetWarning,  bool notifyReminder,  bool notifyWeeklyReport,  String theme,  String? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PreferencesDto() when $default != null:
return $default(_that.notifyBudgetWarning,_that.notifyReminder,_that.notifyWeeklyReport,_that.theme,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool notifyBudgetWarning,  bool notifyReminder,  bool notifyWeeklyReport,  String theme,  String? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _PreferencesDto():
return $default(_that.notifyBudgetWarning,_that.notifyReminder,_that.notifyWeeklyReport,_that.theme,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool notifyBudgetWarning,  bool notifyReminder,  bool notifyWeeklyReport,  String theme,  String? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _PreferencesDto() when $default != null:
return $default(_that.notifyBudgetWarning,_that.notifyReminder,_that.notifyWeeklyReport,_that.theme,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PreferencesDto implements PreferencesDto {
  const _PreferencesDto({required this.notifyBudgetWarning, required this.notifyReminder, required this.notifyWeeklyReport, required this.theme, this.updatedAt});
  factory _PreferencesDto.fromJson(Map<String, dynamic> json) => _$PreferencesDtoFromJson(json);

@override final  bool notifyBudgetWarning;
@override final  bool notifyReminder;
@override final  bool notifyWeeklyReport;
@override final  String theme;
@override final  String? updatedAt;

/// Create a copy of PreferencesDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PreferencesDtoCopyWith<_PreferencesDto> get copyWith => __$PreferencesDtoCopyWithImpl<_PreferencesDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PreferencesDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PreferencesDto&&(identical(other.notifyBudgetWarning, notifyBudgetWarning) || other.notifyBudgetWarning == notifyBudgetWarning)&&(identical(other.notifyReminder, notifyReminder) || other.notifyReminder == notifyReminder)&&(identical(other.notifyWeeklyReport, notifyWeeklyReport) || other.notifyWeeklyReport == notifyWeeklyReport)&&(identical(other.theme, theme) || other.theme == theme)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,notifyBudgetWarning,notifyReminder,notifyWeeklyReport,theme,updatedAt);

@override
String toString() {
  return 'PreferencesDto(notifyBudgetWarning: $notifyBudgetWarning, notifyReminder: $notifyReminder, notifyWeeklyReport: $notifyWeeklyReport, theme: $theme, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$PreferencesDtoCopyWith<$Res> implements $PreferencesDtoCopyWith<$Res> {
  factory _$PreferencesDtoCopyWith(_PreferencesDto value, $Res Function(_PreferencesDto) _then) = __$PreferencesDtoCopyWithImpl;
@override @useResult
$Res call({
 bool notifyBudgetWarning, bool notifyReminder, bool notifyWeeklyReport, String theme, String? updatedAt
});




}
/// @nodoc
class __$PreferencesDtoCopyWithImpl<$Res>
    implements _$PreferencesDtoCopyWith<$Res> {
  __$PreferencesDtoCopyWithImpl(this._self, this._then);

  final _PreferencesDto _self;
  final $Res Function(_PreferencesDto) _then;

/// Create a copy of PreferencesDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? notifyBudgetWarning = null,Object? notifyReminder = null,Object? notifyWeeklyReport = null,Object? theme = null,Object? updatedAt = freezed,}) {
  return _then(_PreferencesDto(
notifyBudgetWarning: null == notifyBudgetWarning ? _self.notifyBudgetWarning : notifyBudgetWarning // ignore: cast_nullable_to_non_nullable
as bool,notifyReminder: null == notifyReminder ? _self.notifyReminder : notifyReminder // ignore: cast_nullable_to_non_nullable
as bool,notifyWeeklyReport: null == notifyWeeklyReport ? _self.notifyWeeklyReport : notifyWeeklyReport // ignore: cast_nullable_to_non_nullable
as bool,theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as String,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$PreferencesEnvelopeDto {

 PreferencesDto get preferences;
/// Create a copy of PreferencesEnvelopeDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PreferencesEnvelopeDtoCopyWith<PreferencesEnvelopeDto> get copyWith => _$PreferencesEnvelopeDtoCopyWithImpl<PreferencesEnvelopeDto>(this as PreferencesEnvelopeDto, _$identity);

  /// Serializes this PreferencesEnvelopeDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PreferencesEnvelopeDto&&(identical(other.preferences, preferences) || other.preferences == preferences));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,preferences);

@override
String toString() {
  return 'PreferencesEnvelopeDto(preferences: $preferences)';
}


}

/// @nodoc
abstract mixin class $PreferencesEnvelopeDtoCopyWith<$Res>  {
  factory $PreferencesEnvelopeDtoCopyWith(PreferencesEnvelopeDto value, $Res Function(PreferencesEnvelopeDto) _then) = _$PreferencesEnvelopeDtoCopyWithImpl;
@useResult
$Res call({
 PreferencesDto preferences
});


$PreferencesDtoCopyWith<$Res> get preferences;

}
/// @nodoc
class _$PreferencesEnvelopeDtoCopyWithImpl<$Res>
    implements $PreferencesEnvelopeDtoCopyWith<$Res> {
  _$PreferencesEnvelopeDtoCopyWithImpl(this._self, this._then);

  final PreferencesEnvelopeDto _self;
  final $Res Function(PreferencesEnvelopeDto) _then;

/// Create a copy of PreferencesEnvelopeDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? preferences = null,}) {
  return _then(_self.copyWith(
preferences: null == preferences ? _self.preferences : preferences // ignore: cast_nullable_to_non_nullable
as PreferencesDto,
  ));
}
/// Create a copy of PreferencesEnvelopeDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PreferencesDtoCopyWith<$Res> get preferences {
  
  return $PreferencesDtoCopyWith<$Res>(_self.preferences, (value) {
    return _then(_self.copyWith(preferences: value));
  });
}
}


/// Adds pattern-matching-related methods to [PreferencesEnvelopeDto].
extension PreferencesEnvelopeDtoPatterns on PreferencesEnvelopeDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PreferencesEnvelopeDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PreferencesEnvelopeDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PreferencesEnvelopeDto value)  $default,){
final _that = this;
switch (_that) {
case _PreferencesEnvelopeDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PreferencesEnvelopeDto value)?  $default,){
final _that = this;
switch (_that) {
case _PreferencesEnvelopeDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PreferencesDto preferences)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PreferencesEnvelopeDto() when $default != null:
return $default(_that.preferences);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PreferencesDto preferences)  $default,) {final _that = this;
switch (_that) {
case _PreferencesEnvelopeDto():
return $default(_that.preferences);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PreferencesDto preferences)?  $default,) {final _that = this;
switch (_that) {
case _PreferencesEnvelopeDto() when $default != null:
return $default(_that.preferences);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PreferencesEnvelopeDto implements PreferencesEnvelopeDto {
  const _PreferencesEnvelopeDto({required this.preferences});
  factory _PreferencesEnvelopeDto.fromJson(Map<String, dynamic> json) => _$PreferencesEnvelopeDtoFromJson(json);

@override final  PreferencesDto preferences;

/// Create a copy of PreferencesEnvelopeDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PreferencesEnvelopeDtoCopyWith<_PreferencesEnvelopeDto> get copyWith => __$PreferencesEnvelopeDtoCopyWithImpl<_PreferencesEnvelopeDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PreferencesEnvelopeDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PreferencesEnvelopeDto&&(identical(other.preferences, preferences) || other.preferences == preferences));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,preferences);

@override
String toString() {
  return 'PreferencesEnvelopeDto(preferences: $preferences)';
}


}

/// @nodoc
abstract mixin class _$PreferencesEnvelopeDtoCopyWith<$Res> implements $PreferencesEnvelopeDtoCopyWith<$Res> {
  factory _$PreferencesEnvelopeDtoCopyWith(_PreferencesEnvelopeDto value, $Res Function(_PreferencesEnvelopeDto) _then) = __$PreferencesEnvelopeDtoCopyWithImpl;
@override @useResult
$Res call({
 PreferencesDto preferences
});


@override $PreferencesDtoCopyWith<$Res> get preferences;

}
/// @nodoc
class __$PreferencesEnvelopeDtoCopyWithImpl<$Res>
    implements _$PreferencesEnvelopeDtoCopyWith<$Res> {
  __$PreferencesEnvelopeDtoCopyWithImpl(this._self, this._then);

  final _PreferencesEnvelopeDto _self;
  final $Res Function(_PreferencesEnvelopeDto) _then;

/// Create a copy of PreferencesEnvelopeDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? preferences = null,}) {
  return _then(_PreferencesEnvelopeDto(
preferences: null == preferences ? _self.preferences : preferences // ignore: cast_nullable_to_non_nullable
as PreferencesDto,
  ));
}

/// Create a copy of PreferencesEnvelopeDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PreferencesDtoCopyWith<$Res> get preferences {
  
  return $PreferencesDtoCopyWith<$Res>(_self.preferences, (value) {
    return _then(_self.copyWith(preferences: value));
  });
}
}

// dart format on
