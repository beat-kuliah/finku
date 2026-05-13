// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_groups_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WalletGroupDto {

 String get id; String get userId; String get name; String? get icon; int get walletCount; int get totalBalance; String get createdAt; String get updatedAt;
/// Create a copy of WalletGroupDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalletGroupDtoCopyWith<WalletGroupDto> get copyWith => _$WalletGroupDtoCopyWithImpl<WalletGroupDto>(this as WalletGroupDto, _$identity);

  /// Serializes this WalletGroupDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WalletGroupDto&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.walletCount, walletCount) || other.walletCount == walletCount)&&(identical(other.totalBalance, totalBalance) || other.totalBalance == totalBalance)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,name,icon,walletCount,totalBalance,createdAt,updatedAt);

@override
String toString() {
  return 'WalletGroupDto(id: $id, userId: $userId, name: $name, icon: $icon, walletCount: $walletCount, totalBalance: $totalBalance, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $WalletGroupDtoCopyWith<$Res>  {
  factory $WalletGroupDtoCopyWith(WalletGroupDto value, $Res Function(WalletGroupDto) _then) = _$WalletGroupDtoCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String name, String? icon, int walletCount, int totalBalance, String createdAt, String updatedAt
});




}
/// @nodoc
class _$WalletGroupDtoCopyWithImpl<$Res>
    implements $WalletGroupDtoCopyWith<$Res> {
  _$WalletGroupDtoCopyWithImpl(this._self, this._then);

  final WalletGroupDto _self;
  final $Res Function(WalletGroupDto) _then;

/// Create a copy of WalletGroupDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? name = null,Object? icon = freezed,Object? walletCount = null,Object? totalBalance = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,walletCount: null == walletCount ? _self.walletCount : walletCount // ignore: cast_nullable_to_non_nullable
as int,totalBalance: null == totalBalance ? _self.totalBalance : totalBalance // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [WalletGroupDto].
extension WalletGroupDtoPatterns on WalletGroupDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WalletGroupDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WalletGroupDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WalletGroupDto value)  $default,){
final _that = this;
switch (_that) {
case _WalletGroupDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WalletGroupDto value)?  $default,){
final _that = this;
switch (_that) {
case _WalletGroupDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String name,  String? icon,  int walletCount,  int totalBalance,  String createdAt,  String updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WalletGroupDto() when $default != null:
return $default(_that.id,_that.userId,_that.name,_that.icon,_that.walletCount,_that.totalBalance,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String name,  String? icon,  int walletCount,  int totalBalance,  String createdAt,  String updatedAt)  $default,) {final _that = this;
switch (_that) {
case _WalletGroupDto():
return $default(_that.id,_that.userId,_that.name,_that.icon,_that.walletCount,_that.totalBalance,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String name,  String? icon,  int walletCount,  int totalBalance,  String createdAt,  String updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _WalletGroupDto() when $default != null:
return $default(_that.id,_that.userId,_that.name,_that.icon,_that.walletCount,_that.totalBalance,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WalletGroupDto implements WalletGroupDto {
  const _WalletGroupDto({required this.id, required this.userId, required this.name, this.icon, required this.walletCount, required this.totalBalance, required this.createdAt, required this.updatedAt});
  factory _WalletGroupDto.fromJson(Map<String, dynamic> json) => _$WalletGroupDtoFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String name;
@override final  String? icon;
@override final  int walletCount;
@override final  int totalBalance;
@override final  String createdAt;
@override final  String updatedAt;

/// Create a copy of WalletGroupDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalletGroupDtoCopyWith<_WalletGroupDto> get copyWith => __$WalletGroupDtoCopyWithImpl<_WalletGroupDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WalletGroupDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalletGroupDto&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.walletCount, walletCount) || other.walletCount == walletCount)&&(identical(other.totalBalance, totalBalance) || other.totalBalance == totalBalance)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,name,icon,walletCount,totalBalance,createdAt,updatedAt);

@override
String toString() {
  return 'WalletGroupDto(id: $id, userId: $userId, name: $name, icon: $icon, walletCount: $walletCount, totalBalance: $totalBalance, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$WalletGroupDtoCopyWith<$Res> implements $WalletGroupDtoCopyWith<$Res> {
  factory _$WalletGroupDtoCopyWith(_WalletGroupDto value, $Res Function(_WalletGroupDto) _then) = __$WalletGroupDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String name, String? icon, int walletCount, int totalBalance, String createdAt, String updatedAt
});




}
/// @nodoc
class __$WalletGroupDtoCopyWithImpl<$Res>
    implements _$WalletGroupDtoCopyWith<$Res> {
  __$WalletGroupDtoCopyWithImpl(this._self, this._then);

  final _WalletGroupDto _self;
  final $Res Function(_WalletGroupDto) _then;

/// Create a copy of WalletGroupDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? name = null,Object? icon = freezed,Object? walletCount = null,Object? totalBalance = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_WalletGroupDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,walletCount: null == walletCount ? _self.walletCount : walletCount // ignore: cast_nullable_to_non_nullable
as int,totalBalance: null == totalBalance ? _self.totalBalance : totalBalance // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ListWalletGroupsResponseDto {

 List<WalletGroupDto> get groups;
/// Create a copy of ListWalletGroupsResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ListWalletGroupsResponseDtoCopyWith<ListWalletGroupsResponseDto> get copyWith => _$ListWalletGroupsResponseDtoCopyWithImpl<ListWalletGroupsResponseDto>(this as ListWalletGroupsResponseDto, _$identity);

  /// Serializes this ListWalletGroupsResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ListWalletGroupsResponseDto&&const DeepCollectionEquality().equals(other.groups, groups));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(groups));

@override
String toString() {
  return 'ListWalletGroupsResponseDto(groups: $groups)';
}


}

/// @nodoc
abstract mixin class $ListWalletGroupsResponseDtoCopyWith<$Res>  {
  factory $ListWalletGroupsResponseDtoCopyWith(ListWalletGroupsResponseDto value, $Res Function(ListWalletGroupsResponseDto) _then) = _$ListWalletGroupsResponseDtoCopyWithImpl;
@useResult
$Res call({
 List<WalletGroupDto> groups
});




}
/// @nodoc
class _$ListWalletGroupsResponseDtoCopyWithImpl<$Res>
    implements $ListWalletGroupsResponseDtoCopyWith<$Res> {
  _$ListWalletGroupsResponseDtoCopyWithImpl(this._self, this._then);

  final ListWalletGroupsResponseDto _self;
  final $Res Function(ListWalletGroupsResponseDto) _then;

/// Create a copy of ListWalletGroupsResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? groups = null,}) {
  return _then(_self.copyWith(
groups: null == groups ? _self.groups : groups // ignore: cast_nullable_to_non_nullable
as List<WalletGroupDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [ListWalletGroupsResponseDto].
extension ListWalletGroupsResponseDtoPatterns on ListWalletGroupsResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ListWalletGroupsResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ListWalletGroupsResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ListWalletGroupsResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _ListWalletGroupsResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ListWalletGroupsResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _ListWalletGroupsResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<WalletGroupDto> groups)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ListWalletGroupsResponseDto() when $default != null:
return $default(_that.groups);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<WalletGroupDto> groups)  $default,) {final _that = this;
switch (_that) {
case _ListWalletGroupsResponseDto():
return $default(_that.groups);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<WalletGroupDto> groups)?  $default,) {final _that = this;
switch (_that) {
case _ListWalletGroupsResponseDto() when $default != null:
return $default(_that.groups);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ListWalletGroupsResponseDto implements ListWalletGroupsResponseDto {
  const _ListWalletGroupsResponseDto({required final  List<WalletGroupDto> groups}): _groups = groups;
  factory _ListWalletGroupsResponseDto.fromJson(Map<String, dynamic> json) => _$ListWalletGroupsResponseDtoFromJson(json);

 final  List<WalletGroupDto> _groups;
@override List<WalletGroupDto> get groups {
  if (_groups is EqualUnmodifiableListView) return _groups;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_groups);
}


/// Create a copy of ListWalletGroupsResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ListWalletGroupsResponseDtoCopyWith<_ListWalletGroupsResponseDto> get copyWith => __$ListWalletGroupsResponseDtoCopyWithImpl<_ListWalletGroupsResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ListWalletGroupsResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ListWalletGroupsResponseDto&&const DeepCollectionEquality().equals(other._groups, _groups));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_groups));

@override
String toString() {
  return 'ListWalletGroupsResponseDto(groups: $groups)';
}


}

/// @nodoc
abstract mixin class _$ListWalletGroupsResponseDtoCopyWith<$Res> implements $ListWalletGroupsResponseDtoCopyWith<$Res> {
  factory _$ListWalletGroupsResponseDtoCopyWith(_ListWalletGroupsResponseDto value, $Res Function(_ListWalletGroupsResponseDto) _then) = __$ListWalletGroupsResponseDtoCopyWithImpl;
@override @useResult
$Res call({
 List<WalletGroupDto> groups
});




}
/// @nodoc
class __$ListWalletGroupsResponseDtoCopyWithImpl<$Res>
    implements _$ListWalletGroupsResponseDtoCopyWith<$Res> {
  __$ListWalletGroupsResponseDtoCopyWithImpl(this._self, this._then);

  final _ListWalletGroupsResponseDto _self;
  final $Res Function(_ListWalletGroupsResponseDto) _then;

/// Create a copy of ListWalletGroupsResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? groups = null,}) {
  return _then(_ListWalletGroupsResponseDto(
groups: null == groups ? _self._groups : groups // ignore: cast_nullable_to_non_nullable
as List<WalletGroupDto>,
  ));
}


}


/// @nodoc
mixin _$WalletGroupEnvelopeDto {

 WalletGroupDto get group;
/// Create a copy of WalletGroupEnvelopeDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalletGroupEnvelopeDtoCopyWith<WalletGroupEnvelopeDto> get copyWith => _$WalletGroupEnvelopeDtoCopyWithImpl<WalletGroupEnvelopeDto>(this as WalletGroupEnvelopeDto, _$identity);

  /// Serializes this WalletGroupEnvelopeDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WalletGroupEnvelopeDto&&(identical(other.group, group) || other.group == group));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,group);

@override
String toString() {
  return 'WalletGroupEnvelopeDto(group: $group)';
}


}

/// @nodoc
abstract mixin class $WalletGroupEnvelopeDtoCopyWith<$Res>  {
  factory $WalletGroupEnvelopeDtoCopyWith(WalletGroupEnvelopeDto value, $Res Function(WalletGroupEnvelopeDto) _then) = _$WalletGroupEnvelopeDtoCopyWithImpl;
@useResult
$Res call({
 WalletGroupDto group
});


$WalletGroupDtoCopyWith<$Res> get group;

}
/// @nodoc
class _$WalletGroupEnvelopeDtoCopyWithImpl<$Res>
    implements $WalletGroupEnvelopeDtoCopyWith<$Res> {
  _$WalletGroupEnvelopeDtoCopyWithImpl(this._self, this._then);

  final WalletGroupEnvelopeDto _self;
  final $Res Function(WalletGroupEnvelopeDto) _then;

/// Create a copy of WalletGroupEnvelopeDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? group = null,}) {
  return _then(_self.copyWith(
group: null == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as WalletGroupDto,
  ));
}
/// Create a copy of WalletGroupEnvelopeDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WalletGroupDtoCopyWith<$Res> get group {
  
  return $WalletGroupDtoCopyWith<$Res>(_self.group, (value) {
    return _then(_self.copyWith(group: value));
  });
}
}


/// Adds pattern-matching-related methods to [WalletGroupEnvelopeDto].
extension WalletGroupEnvelopeDtoPatterns on WalletGroupEnvelopeDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WalletGroupEnvelopeDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WalletGroupEnvelopeDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WalletGroupEnvelopeDto value)  $default,){
final _that = this;
switch (_that) {
case _WalletGroupEnvelopeDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WalletGroupEnvelopeDto value)?  $default,){
final _that = this;
switch (_that) {
case _WalletGroupEnvelopeDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( WalletGroupDto group)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WalletGroupEnvelopeDto() when $default != null:
return $default(_that.group);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( WalletGroupDto group)  $default,) {final _that = this;
switch (_that) {
case _WalletGroupEnvelopeDto():
return $default(_that.group);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( WalletGroupDto group)?  $default,) {final _that = this;
switch (_that) {
case _WalletGroupEnvelopeDto() when $default != null:
return $default(_that.group);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WalletGroupEnvelopeDto implements WalletGroupEnvelopeDto {
  const _WalletGroupEnvelopeDto({required this.group});
  factory _WalletGroupEnvelopeDto.fromJson(Map<String, dynamic> json) => _$WalletGroupEnvelopeDtoFromJson(json);

@override final  WalletGroupDto group;

/// Create a copy of WalletGroupEnvelopeDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalletGroupEnvelopeDtoCopyWith<_WalletGroupEnvelopeDto> get copyWith => __$WalletGroupEnvelopeDtoCopyWithImpl<_WalletGroupEnvelopeDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WalletGroupEnvelopeDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalletGroupEnvelopeDto&&(identical(other.group, group) || other.group == group));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,group);

@override
String toString() {
  return 'WalletGroupEnvelopeDto(group: $group)';
}


}

/// @nodoc
abstract mixin class _$WalletGroupEnvelopeDtoCopyWith<$Res> implements $WalletGroupEnvelopeDtoCopyWith<$Res> {
  factory _$WalletGroupEnvelopeDtoCopyWith(_WalletGroupEnvelopeDto value, $Res Function(_WalletGroupEnvelopeDto) _then) = __$WalletGroupEnvelopeDtoCopyWithImpl;
@override @useResult
$Res call({
 WalletGroupDto group
});


@override $WalletGroupDtoCopyWith<$Res> get group;

}
/// @nodoc
class __$WalletGroupEnvelopeDtoCopyWithImpl<$Res>
    implements _$WalletGroupEnvelopeDtoCopyWith<$Res> {
  __$WalletGroupEnvelopeDtoCopyWithImpl(this._self, this._then);

  final _WalletGroupEnvelopeDto _self;
  final $Res Function(_WalletGroupEnvelopeDto) _then;

/// Create a copy of WalletGroupEnvelopeDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? group = null,}) {
  return _then(_WalletGroupEnvelopeDto(
group: null == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as WalletGroupDto,
  ));
}

/// Create a copy of WalletGroupEnvelopeDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WalletGroupDtoCopyWith<$Res> get group {
  
  return $WalletGroupDtoCopyWith<$Res>(_self.group, (value) {
    return _then(_self.copyWith(group: value));
  });
}
}

// dart format on
