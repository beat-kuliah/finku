// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallets_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WalletDto {

 String get id; String get userId; String get name; String get walletType; String? get icon; int get balance; String? get groupId; String? get archivedAt; String get createdAt; String get updatedAt;
/// Create a copy of WalletDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalletDtoCopyWith<WalletDto> get copyWith => _$WalletDtoCopyWithImpl<WalletDto>(this as WalletDto, _$identity);

  /// Serializes this WalletDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WalletDto&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.walletType, walletType) || other.walletType == walletType)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.archivedAt, archivedAt) || other.archivedAt == archivedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,name,walletType,icon,balance,groupId,archivedAt,createdAt,updatedAt);

@override
String toString() {
  return 'WalletDto(id: $id, userId: $userId, name: $name, walletType: $walletType, icon: $icon, balance: $balance, groupId: $groupId, archivedAt: $archivedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $WalletDtoCopyWith<$Res>  {
  factory $WalletDtoCopyWith(WalletDto value, $Res Function(WalletDto) _then) = _$WalletDtoCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String name, String walletType, String? icon, int balance, String? groupId, String? archivedAt, String createdAt, String updatedAt
});




}
/// @nodoc
class _$WalletDtoCopyWithImpl<$Res>
    implements $WalletDtoCopyWith<$Res> {
  _$WalletDtoCopyWithImpl(this._self, this._then);

  final WalletDto _self;
  final $Res Function(WalletDto) _then;

/// Create a copy of WalletDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? name = null,Object? walletType = null,Object? icon = freezed,Object? balance = null,Object? groupId = freezed,Object? archivedAt = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,walletType: null == walletType ? _self.walletType : walletType // ignore: cast_nullable_to_non_nullable
as String,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as int,groupId: freezed == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String?,archivedAt: freezed == archivedAt ? _self.archivedAt : archivedAt // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [WalletDto].
extension WalletDtoPatterns on WalletDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WalletDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WalletDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WalletDto value)  $default,){
final _that = this;
switch (_that) {
case _WalletDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WalletDto value)?  $default,){
final _that = this;
switch (_that) {
case _WalletDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String name,  String walletType,  String? icon,  int balance,  String? groupId,  String? archivedAt,  String createdAt,  String updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WalletDto() when $default != null:
return $default(_that.id,_that.userId,_that.name,_that.walletType,_that.icon,_that.balance,_that.groupId,_that.archivedAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String name,  String walletType,  String? icon,  int balance,  String? groupId,  String? archivedAt,  String createdAt,  String updatedAt)  $default,) {final _that = this;
switch (_that) {
case _WalletDto():
return $default(_that.id,_that.userId,_that.name,_that.walletType,_that.icon,_that.balance,_that.groupId,_that.archivedAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String name,  String walletType,  String? icon,  int balance,  String? groupId,  String? archivedAt,  String createdAt,  String updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _WalletDto() when $default != null:
return $default(_that.id,_that.userId,_that.name,_that.walletType,_that.icon,_that.balance,_that.groupId,_that.archivedAt,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WalletDto implements WalletDto {
  const _WalletDto({required this.id, required this.userId, required this.name, required this.walletType, this.icon, required this.balance, this.groupId, this.archivedAt, required this.createdAt, required this.updatedAt});
  factory _WalletDto.fromJson(Map<String, dynamic> json) => _$WalletDtoFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String name;
@override final  String walletType;
@override final  String? icon;
@override final  int balance;
@override final  String? groupId;
@override final  String? archivedAt;
@override final  String createdAt;
@override final  String updatedAt;

/// Create a copy of WalletDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalletDtoCopyWith<_WalletDto> get copyWith => __$WalletDtoCopyWithImpl<_WalletDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WalletDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalletDto&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.walletType, walletType) || other.walletType == walletType)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.archivedAt, archivedAt) || other.archivedAt == archivedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,name,walletType,icon,balance,groupId,archivedAt,createdAt,updatedAt);

@override
String toString() {
  return 'WalletDto(id: $id, userId: $userId, name: $name, walletType: $walletType, icon: $icon, balance: $balance, groupId: $groupId, archivedAt: $archivedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$WalletDtoCopyWith<$Res> implements $WalletDtoCopyWith<$Res> {
  factory _$WalletDtoCopyWith(_WalletDto value, $Res Function(_WalletDto) _then) = __$WalletDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String name, String walletType, String? icon, int balance, String? groupId, String? archivedAt, String createdAt, String updatedAt
});




}
/// @nodoc
class __$WalletDtoCopyWithImpl<$Res>
    implements _$WalletDtoCopyWith<$Res> {
  __$WalletDtoCopyWithImpl(this._self, this._then);

  final _WalletDto _self;
  final $Res Function(_WalletDto) _then;

/// Create a copy of WalletDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? name = null,Object? walletType = null,Object? icon = freezed,Object? balance = null,Object? groupId = freezed,Object? archivedAt = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_WalletDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,walletType: null == walletType ? _self.walletType : walletType // ignore: cast_nullable_to_non_nullable
as String,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as int,groupId: freezed == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String?,archivedAt: freezed == archivedAt ? _self.archivedAt : archivedAt // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ListWalletsResponseDto {

 List<WalletDto> get wallets;
/// Create a copy of ListWalletsResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ListWalletsResponseDtoCopyWith<ListWalletsResponseDto> get copyWith => _$ListWalletsResponseDtoCopyWithImpl<ListWalletsResponseDto>(this as ListWalletsResponseDto, _$identity);

  /// Serializes this ListWalletsResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ListWalletsResponseDto&&const DeepCollectionEquality().equals(other.wallets, wallets));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(wallets));

@override
String toString() {
  return 'ListWalletsResponseDto(wallets: $wallets)';
}


}

/// @nodoc
abstract mixin class $ListWalletsResponseDtoCopyWith<$Res>  {
  factory $ListWalletsResponseDtoCopyWith(ListWalletsResponseDto value, $Res Function(ListWalletsResponseDto) _then) = _$ListWalletsResponseDtoCopyWithImpl;
@useResult
$Res call({
 List<WalletDto> wallets
});




}
/// @nodoc
class _$ListWalletsResponseDtoCopyWithImpl<$Res>
    implements $ListWalletsResponseDtoCopyWith<$Res> {
  _$ListWalletsResponseDtoCopyWithImpl(this._self, this._then);

  final ListWalletsResponseDto _self;
  final $Res Function(ListWalletsResponseDto) _then;

/// Create a copy of ListWalletsResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? wallets = null,}) {
  return _then(_self.copyWith(
wallets: null == wallets ? _self.wallets : wallets // ignore: cast_nullable_to_non_nullable
as List<WalletDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [ListWalletsResponseDto].
extension ListWalletsResponseDtoPatterns on ListWalletsResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ListWalletsResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ListWalletsResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ListWalletsResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _ListWalletsResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ListWalletsResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _ListWalletsResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<WalletDto> wallets)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ListWalletsResponseDto() when $default != null:
return $default(_that.wallets);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<WalletDto> wallets)  $default,) {final _that = this;
switch (_that) {
case _ListWalletsResponseDto():
return $default(_that.wallets);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<WalletDto> wallets)?  $default,) {final _that = this;
switch (_that) {
case _ListWalletsResponseDto() when $default != null:
return $default(_that.wallets);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ListWalletsResponseDto implements ListWalletsResponseDto {
  const _ListWalletsResponseDto({required final  List<WalletDto> wallets}): _wallets = wallets;
  factory _ListWalletsResponseDto.fromJson(Map<String, dynamic> json) => _$ListWalletsResponseDtoFromJson(json);

 final  List<WalletDto> _wallets;
@override List<WalletDto> get wallets {
  if (_wallets is EqualUnmodifiableListView) return _wallets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_wallets);
}


/// Create a copy of ListWalletsResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ListWalletsResponseDtoCopyWith<_ListWalletsResponseDto> get copyWith => __$ListWalletsResponseDtoCopyWithImpl<_ListWalletsResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ListWalletsResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ListWalletsResponseDto&&const DeepCollectionEquality().equals(other._wallets, _wallets));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_wallets));

@override
String toString() {
  return 'ListWalletsResponseDto(wallets: $wallets)';
}


}

/// @nodoc
abstract mixin class _$ListWalletsResponseDtoCopyWith<$Res> implements $ListWalletsResponseDtoCopyWith<$Res> {
  factory _$ListWalletsResponseDtoCopyWith(_ListWalletsResponseDto value, $Res Function(_ListWalletsResponseDto) _then) = __$ListWalletsResponseDtoCopyWithImpl;
@override @useResult
$Res call({
 List<WalletDto> wallets
});




}
/// @nodoc
class __$ListWalletsResponseDtoCopyWithImpl<$Res>
    implements _$ListWalletsResponseDtoCopyWith<$Res> {
  __$ListWalletsResponseDtoCopyWithImpl(this._self, this._then);

  final _ListWalletsResponseDto _self;
  final $Res Function(_ListWalletsResponseDto) _then;

/// Create a copy of ListWalletsResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? wallets = null,}) {
  return _then(_ListWalletsResponseDto(
wallets: null == wallets ? _self._wallets : wallets // ignore: cast_nullable_to_non_nullable
as List<WalletDto>,
  ));
}


}


/// @nodoc
mixin _$WalletEnvelopeDto {

 WalletDto get wallet;
/// Create a copy of WalletEnvelopeDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalletEnvelopeDtoCopyWith<WalletEnvelopeDto> get copyWith => _$WalletEnvelopeDtoCopyWithImpl<WalletEnvelopeDto>(this as WalletEnvelopeDto, _$identity);

  /// Serializes this WalletEnvelopeDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WalletEnvelopeDto&&(identical(other.wallet, wallet) || other.wallet == wallet));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,wallet);

@override
String toString() {
  return 'WalletEnvelopeDto(wallet: $wallet)';
}


}

/// @nodoc
abstract mixin class $WalletEnvelopeDtoCopyWith<$Res>  {
  factory $WalletEnvelopeDtoCopyWith(WalletEnvelopeDto value, $Res Function(WalletEnvelopeDto) _then) = _$WalletEnvelopeDtoCopyWithImpl;
@useResult
$Res call({
 WalletDto wallet
});


$WalletDtoCopyWith<$Res> get wallet;

}
/// @nodoc
class _$WalletEnvelopeDtoCopyWithImpl<$Res>
    implements $WalletEnvelopeDtoCopyWith<$Res> {
  _$WalletEnvelopeDtoCopyWithImpl(this._self, this._then);

  final WalletEnvelopeDto _self;
  final $Res Function(WalletEnvelopeDto) _then;

/// Create a copy of WalletEnvelopeDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? wallet = null,}) {
  return _then(_self.copyWith(
wallet: null == wallet ? _self.wallet : wallet // ignore: cast_nullable_to_non_nullable
as WalletDto,
  ));
}
/// Create a copy of WalletEnvelopeDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WalletDtoCopyWith<$Res> get wallet {
  
  return $WalletDtoCopyWith<$Res>(_self.wallet, (value) {
    return _then(_self.copyWith(wallet: value));
  });
}
}


/// Adds pattern-matching-related methods to [WalletEnvelopeDto].
extension WalletEnvelopeDtoPatterns on WalletEnvelopeDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WalletEnvelopeDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WalletEnvelopeDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WalletEnvelopeDto value)  $default,){
final _that = this;
switch (_that) {
case _WalletEnvelopeDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WalletEnvelopeDto value)?  $default,){
final _that = this;
switch (_that) {
case _WalletEnvelopeDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( WalletDto wallet)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WalletEnvelopeDto() when $default != null:
return $default(_that.wallet);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( WalletDto wallet)  $default,) {final _that = this;
switch (_that) {
case _WalletEnvelopeDto():
return $default(_that.wallet);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( WalletDto wallet)?  $default,) {final _that = this;
switch (_that) {
case _WalletEnvelopeDto() when $default != null:
return $default(_that.wallet);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WalletEnvelopeDto implements WalletEnvelopeDto {
  const _WalletEnvelopeDto({required this.wallet});
  factory _WalletEnvelopeDto.fromJson(Map<String, dynamic> json) => _$WalletEnvelopeDtoFromJson(json);

@override final  WalletDto wallet;

/// Create a copy of WalletEnvelopeDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalletEnvelopeDtoCopyWith<_WalletEnvelopeDto> get copyWith => __$WalletEnvelopeDtoCopyWithImpl<_WalletEnvelopeDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WalletEnvelopeDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalletEnvelopeDto&&(identical(other.wallet, wallet) || other.wallet == wallet));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,wallet);

@override
String toString() {
  return 'WalletEnvelopeDto(wallet: $wallet)';
}


}

/// @nodoc
abstract mixin class _$WalletEnvelopeDtoCopyWith<$Res> implements $WalletEnvelopeDtoCopyWith<$Res> {
  factory _$WalletEnvelopeDtoCopyWith(_WalletEnvelopeDto value, $Res Function(_WalletEnvelopeDto) _then) = __$WalletEnvelopeDtoCopyWithImpl;
@override @useResult
$Res call({
 WalletDto wallet
});


@override $WalletDtoCopyWith<$Res> get wallet;

}
/// @nodoc
class __$WalletEnvelopeDtoCopyWithImpl<$Res>
    implements _$WalletEnvelopeDtoCopyWith<$Res> {
  __$WalletEnvelopeDtoCopyWithImpl(this._self, this._then);

  final _WalletEnvelopeDto _self;
  final $Res Function(_WalletEnvelopeDto) _then;

/// Create a copy of WalletEnvelopeDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? wallet = null,}) {
  return _then(_WalletEnvelopeDto(
wallet: null == wallet ? _self.wallet : wallet // ignore: cast_nullable_to_non_nullable
as WalletDto,
  ));
}

/// Create a copy of WalletEnvelopeDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WalletDtoCopyWith<$Res> get wallet {
  
  return $WalletDtoCopyWith<$Res>(_self.wallet, (value) {
    return _then(_self.copyWith(wallet: value));
  });
}
}

// dart format on
