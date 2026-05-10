// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuthUserDto {

 String get id; String get email; String get name; String? get username; bool get hasPassword; List<String> get providers; int? get monthlyIncome; int? get payday; String get currency; String get createdAt; String get updatedAt;
/// Create a copy of AuthUserDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthUserDtoCopyWith<AuthUserDto> get copyWith => _$AuthUserDtoCopyWithImpl<AuthUserDto>(this as AuthUserDto, _$identity);

  /// Serializes this AuthUserDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthUserDto&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.name, name) || other.name == name)&&(identical(other.username, username) || other.username == username)&&(identical(other.hasPassword, hasPassword) || other.hasPassword == hasPassword)&&const DeepCollectionEquality().equals(other.providers, providers)&&(identical(other.monthlyIncome, monthlyIncome) || other.monthlyIncome == monthlyIncome)&&(identical(other.payday, payday) || other.payday == payday)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,name,username,hasPassword,const DeepCollectionEquality().hash(providers),monthlyIncome,payday,currency,createdAt,updatedAt);

@override
String toString() {
  return 'AuthUserDto(id: $id, email: $email, name: $name, username: $username, hasPassword: $hasPassword, providers: $providers, monthlyIncome: $monthlyIncome, payday: $payday, currency: $currency, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $AuthUserDtoCopyWith<$Res>  {
  factory $AuthUserDtoCopyWith(AuthUserDto value, $Res Function(AuthUserDto) _then) = _$AuthUserDtoCopyWithImpl;
@useResult
$Res call({
 String id, String email, String name, String? username, bool hasPassword, List<String> providers, int? monthlyIncome, int? payday, String currency, String createdAt, String updatedAt
});




}
/// @nodoc
class _$AuthUserDtoCopyWithImpl<$Res>
    implements $AuthUserDtoCopyWith<$Res> {
  _$AuthUserDtoCopyWithImpl(this._self, this._then);

  final AuthUserDto _self;
  final $Res Function(AuthUserDto) _then;

/// Create a copy of AuthUserDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = null,Object? name = null,Object? username = freezed,Object? hasPassword = null,Object? providers = null,Object? monthlyIncome = freezed,Object? payday = freezed,Object? currency = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,hasPassword: null == hasPassword ? _self.hasPassword : hasPassword // ignore: cast_nullable_to_non_nullable
as bool,providers: null == providers ? _self.providers : providers // ignore: cast_nullable_to_non_nullable
as List<String>,monthlyIncome: freezed == monthlyIncome ? _self.monthlyIncome : monthlyIncome // ignore: cast_nullable_to_non_nullable
as int?,payday: freezed == payday ? _self.payday : payday // ignore: cast_nullable_to_non_nullable
as int?,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthUserDto].
extension AuthUserDtoPatterns on AuthUserDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthUserDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthUserDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthUserDto value)  $default,){
final _that = this;
switch (_that) {
case _AuthUserDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthUserDto value)?  $default,){
final _that = this;
switch (_that) {
case _AuthUserDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String email,  String name,  String? username,  bool hasPassword,  List<String> providers,  int? monthlyIncome,  int? payday,  String currency,  String createdAt,  String updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthUserDto() when $default != null:
return $default(_that.id,_that.email,_that.name,_that.username,_that.hasPassword,_that.providers,_that.monthlyIncome,_that.payday,_that.currency,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String email,  String name,  String? username,  bool hasPassword,  List<String> providers,  int? monthlyIncome,  int? payday,  String currency,  String createdAt,  String updatedAt)  $default,) {final _that = this;
switch (_that) {
case _AuthUserDto():
return $default(_that.id,_that.email,_that.name,_that.username,_that.hasPassword,_that.providers,_that.monthlyIncome,_that.payday,_that.currency,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String email,  String name,  String? username,  bool hasPassword,  List<String> providers,  int? monthlyIncome,  int? payday,  String currency,  String createdAt,  String updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _AuthUserDto() when $default != null:
return $default(_that.id,_that.email,_that.name,_that.username,_that.hasPassword,_that.providers,_that.monthlyIncome,_that.payday,_that.currency,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuthUserDto implements AuthUserDto {
  const _AuthUserDto({required this.id, required this.email, required this.name, this.username, required this.hasPassword, final  List<String> providers = const <String>[], this.monthlyIncome, this.payday, required this.currency, required this.createdAt, required this.updatedAt}): _providers = providers;
  factory _AuthUserDto.fromJson(Map<String, dynamic> json) => _$AuthUserDtoFromJson(json);

@override final  String id;
@override final  String email;
@override final  String name;
@override final  String? username;
@override final  bool hasPassword;
 final  List<String> _providers;
@override@JsonKey() List<String> get providers {
  if (_providers is EqualUnmodifiableListView) return _providers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_providers);
}

@override final  int? monthlyIncome;
@override final  int? payday;
@override final  String currency;
@override final  String createdAt;
@override final  String updatedAt;

/// Create a copy of AuthUserDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthUserDtoCopyWith<_AuthUserDto> get copyWith => __$AuthUserDtoCopyWithImpl<_AuthUserDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthUserDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthUserDto&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.name, name) || other.name == name)&&(identical(other.username, username) || other.username == username)&&(identical(other.hasPassword, hasPassword) || other.hasPassword == hasPassword)&&const DeepCollectionEquality().equals(other._providers, _providers)&&(identical(other.monthlyIncome, monthlyIncome) || other.monthlyIncome == monthlyIncome)&&(identical(other.payday, payday) || other.payday == payday)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,name,username,hasPassword,const DeepCollectionEquality().hash(_providers),monthlyIncome,payday,currency,createdAt,updatedAt);

@override
String toString() {
  return 'AuthUserDto(id: $id, email: $email, name: $name, username: $username, hasPassword: $hasPassword, providers: $providers, monthlyIncome: $monthlyIncome, payday: $payday, currency: $currency, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$AuthUserDtoCopyWith<$Res> implements $AuthUserDtoCopyWith<$Res> {
  factory _$AuthUserDtoCopyWith(_AuthUserDto value, $Res Function(_AuthUserDto) _then) = __$AuthUserDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String email, String name, String? username, bool hasPassword, List<String> providers, int? monthlyIncome, int? payday, String currency, String createdAt, String updatedAt
});




}
/// @nodoc
class __$AuthUserDtoCopyWithImpl<$Res>
    implements _$AuthUserDtoCopyWith<$Res> {
  __$AuthUserDtoCopyWithImpl(this._self, this._then);

  final _AuthUserDto _self;
  final $Res Function(_AuthUserDto) _then;

/// Create a copy of AuthUserDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = null,Object? name = null,Object? username = freezed,Object? hasPassword = null,Object? providers = null,Object? monthlyIncome = freezed,Object? payday = freezed,Object? currency = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_AuthUserDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,hasPassword: null == hasPassword ? _self.hasPassword : hasPassword // ignore: cast_nullable_to_non_nullable
as bool,providers: null == providers ? _self._providers : providers // ignore: cast_nullable_to_non_nullable
as List<String>,monthlyIncome: freezed == monthlyIncome ? _self.monthlyIncome : monthlyIncome // ignore: cast_nullable_to_non_nullable
as int?,payday: freezed == payday ? _self.payday : payday // ignore: cast_nullable_to_non_nullable
as int?,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$MobileAuthResponseDto {

 AuthUserDto get user; String get accessToken; String get refreshToken;
/// Create a copy of MobileAuthResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MobileAuthResponseDtoCopyWith<MobileAuthResponseDto> get copyWith => _$MobileAuthResponseDtoCopyWithImpl<MobileAuthResponseDto>(this as MobileAuthResponseDto, _$identity);

  /// Serializes this MobileAuthResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MobileAuthResponseDto&&(identical(other.user, user) || other.user == user)&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,user,accessToken,refreshToken);

@override
String toString() {
  return 'MobileAuthResponseDto(user: $user, accessToken: $accessToken, refreshToken: $refreshToken)';
}


}

/// @nodoc
abstract mixin class $MobileAuthResponseDtoCopyWith<$Res>  {
  factory $MobileAuthResponseDtoCopyWith(MobileAuthResponseDto value, $Res Function(MobileAuthResponseDto) _then) = _$MobileAuthResponseDtoCopyWithImpl;
@useResult
$Res call({
 AuthUserDto user, String accessToken, String refreshToken
});


$AuthUserDtoCopyWith<$Res> get user;

}
/// @nodoc
class _$MobileAuthResponseDtoCopyWithImpl<$Res>
    implements $MobileAuthResponseDtoCopyWith<$Res> {
  _$MobileAuthResponseDtoCopyWithImpl(this._self, this._then);

  final MobileAuthResponseDto _self;
  final $Res Function(MobileAuthResponseDto) _then;

/// Create a copy of MobileAuthResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? user = null,Object? accessToken = null,Object? refreshToken = null,}) {
  return _then(_self.copyWith(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as AuthUserDto,accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of MobileAuthResponseDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthUserDtoCopyWith<$Res> get user {
  
  return $AuthUserDtoCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// Adds pattern-matching-related methods to [MobileAuthResponseDto].
extension MobileAuthResponseDtoPatterns on MobileAuthResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MobileAuthResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MobileAuthResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MobileAuthResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _MobileAuthResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MobileAuthResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _MobileAuthResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AuthUserDto user,  String accessToken,  String refreshToken)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MobileAuthResponseDto() when $default != null:
return $default(_that.user,_that.accessToken,_that.refreshToken);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AuthUserDto user,  String accessToken,  String refreshToken)  $default,) {final _that = this;
switch (_that) {
case _MobileAuthResponseDto():
return $default(_that.user,_that.accessToken,_that.refreshToken);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AuthUserDto user,  String accessToken,  String refreshToken)?  $default,) {final _that = this;
switch (_that) {
case _MobileAuthResponseDto() when $default != null:
return $default(_that.user,_that.accessToken,_that.refreshToken);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MobileAuthResponseDto implements MobileAuthResponseDto {
  const _MobileAuthResponseDto({required this.user, required this.accessToken, required this.refreshToken});
  factory _MobileAuthResponseDto.fromJson(Map<String, dynamic> json) => _$MobileAuthResponseDtoFromJson(json);

@override final  AuthUserDto user;
@override final  String accessToken;
@override final  String refreshToken;

/// Create a copy of MobileAuthResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MobileAuthResponseDtoCopyWith<_MobileAuthResponseDto> get copyWith => __$MobileAuthResponseDtoCopyWithImpl<_MobileAuthResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MobileAuthResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MobileAuthResponseDto&&(identical(other.user, user) || other.user == user)&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,user,accessToken,refreshToken);

@override
String toString() {
  return 'MobileAuthResponseDto(user: $user, accessToken: $accessToken, refreshToken: $refreshToken)';
}


}

/// @nodoc
abstract mixin class _$MobileAuthResponseDtoCopyWith<$Res> implements $MobileAuthResponseDtoCopyWith<$Res> {
  factory _$MobileAuthResponseDtoCopyWith(_MobileAuthResponseDto value, $Res Function(_MobileAuthResponseDto) _then) = __$MobileAuthResponseDtoCopyWithImpl;
@override @useResult
$Res call({
 AuthUserDto user, String accessToken, String refreshToken
});


@override $AuthUserDtoCopyWith<$Res> get user;

}
/// @nodoc
class __$MobileAuthResponseDtoCopyWithImpl<$Res>
    implements _$MobileAuthResponseDtoCopyWith<$Res> {
  __$MobileAuthResponseDtoCopyWithImpl(this._self, this._then);

  final _MobileAuthResponseDto _self;
  final $Res Function(_MobileAuthResponseDto) _then;

/// Create a copy of MobileAuthResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? user = null,Object? accessToken = null,Object? refreshToken = null,}) {
  return _then(_MobileAuthResponseDto(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as AuthUserDto,accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of MobileAuthResponseDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthUserDtoCopyWith<$Res> get user {
  
  return $AuthUserDtoCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// @nodoc
mixin _$MobileRefreshResponseDto {

 String get accessToken; String get refreshToken;
/// Create a copy of MobileRefreshResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MobileRefreshResponseDtoCopyWith<MobileRefreshResponseDto> get copyWith => _$MobileRefreshResponseDtoCopyWithImpl<MobileRefreshResponseDto>(this as MobileRefreshResponseDto, _$identity);

  /// Serializes this MobileRefreshResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MobileRefreshResponseDto&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accessToken,refreshToken);

@override
String toString() {
  return 'MobileRefreshResponseDto(accessToken: $accessToken, refreshToken: $refreshToken)';
}


}

/// @nodoc
abstract mixin class $MobileRefreshResponseDtoCopyWith<$Res>  {
  factory $MobileRefreshResponseDtoCopyWith(MobileRefreshResponseDto value, $Res Function(MobileRefreshResponseDto) _then) = _$MobileRefreshResponseDtoCopyWithImpl;
@useResult
$Res call({
 String accessToken, String refreshToken
});




}
/// @nodoc
class _$MobileRefreshResponseDtoCopyWithImpl<$Res>
    implements $MobileRefreshResponseDtoCopyWith<$Res> {
  _$MobileRefreshResponseDtoCopyWithImpl(this._self, this._then);

  final MobileRefreshResponseDto _self;
  final $Res Function(MobileRefreshResponseDto) _then;

/// Create a copy of MobileRefreshResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accessToken = null,Object? refreshToken = null,}) {
  return _then(_self.copyWith(
accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MobileRefreshResponseDto].
extension MobileRefreshResponseDtoPatterns on MobileRefreshResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MobileRefreshResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MobileRefreshResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MobileRefreshResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _MobileRefreshResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MobileRefreshResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _MobileRefreshResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String accessToken,  String refreshToken)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MobileRefreshResponseDto() when $default != null:
return $default(_that.accessToken,_that.refreshToken);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String accessToken,  String refreshToken)  $default,) {final _that = this;
switch (_that) {
case _MobileRefreshResponseDto():
return $default(_that.accessToken,_that.refreshToken);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String accessToken,  String refreshToken)?  $default,) {final _that = this;
switch (_that) {
case _MobileRefreshResponseDto() when $default != null:
return $default(_that.accessToken,_that.refreshToken);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MobileRefreshResponseDto implements MobileRefreshResponseDto {
  const _MobileRefreshResponseDto({required this.accessToken, required this.refreshToken});
  factory _MobileRefreshResponseDto.fromJson(Map<String, dynamic> json) => _$MobileRefreshResponseDtoFromJson(json);

@override final  String accessToken;
@override final  String refreshToken;

/// Create a copy of MobileRefreshResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MobileRefreshResponseDtoCopyWith<_MobileRefreshResponseDto> get copyWith => __$MobileRefreshResponseDtoCopyWithImpl<_MobileRefreshResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MobileRefreshResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MobileRefreshResponseDto&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accessToken,refreshToken);

@override
String toString() {
  return 'MobileRefreshResponseDto(accessToken: $accessToken, refreshToken: $refreshToken)';
}


}

/// @nodoc
abstract mixin class _$MobileRefreshResponseDtoCopyWith<$Res> implements $MobileRefreshResponseDtoCopyWith<$Res> {
  factory _$MobileRefreshResponseDtoCopyWith(_MobileRefreshResponseDto value, $Res Function(_MobileRefreshResponseDto) _then) = __$MobileRefreshResponseDtoCopyWithImpl;
@override @useResult
$Res call({
 String accessToken, String refreshToken
});




}
/// @nodoc
class __$MobileRefreshResponseDtoCopyWithImpl<$Res>
    implements _$MobileRefreshResponseDtoCopyWith<$Res> {
  __$MobileRefreshResponseDtoCopyWithImpl(this._self, this._then);

  final _MobileRefreshResponseDto _self;
  final $Res Function(_MobileRefreshResponseDto) _then;

/// Create a copy of MobileRefreshResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accessToken = null,Object? refreshToken = null,}) {
  return _then(_MobileRefreshResponseDto(
accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$MeResponseDto {

 AuthUserDto get user;
/// Create a copy of MeResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeResponseDtoCopyWith<MeResponseDto> get copyWith => _$MeResponseDtoCopyWithImpl<MeResponseDto>(this as MeResponseDto, _$identity);

  /// Serializes this MeResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeResponseDto&&(identical(other.user, user) || other.user == user));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,user);

@override
String toString() {
  return 'MeResponseDto(user: $user)';
}


}

/// @nodoc
abstract mixin class $MeResponseDtoCopyWith<$Res>  {
  factory $MeResponseDtoCopyWith(MeResponseDto value, $Res Function(MeResponseDto) _then) = _$MeResponseDtoCopyWithImpl;
@useResult
$Res call({
 AuthUserDto user
});


$AuthUserDtoCopyWith<$Res> get user;

}
/// @nodoc
class _$MeResponseDtoCopyWithImpl<$Res>
    implements $MeResponseDtoCopyWith<$Res> {
  _$MeResponseDtoCopyWithImpl(this._self, this._then);

  final MeResponseDto _self;
  final $Res Function(MeResponseDto) _then;

/// Create a copy of MeResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? user = null,}) {
  return _then(_self.copyWith(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as AuthUserDto,
  ));
}
/// Create a copy of MeResponseDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthUserDtoCopyWith<$Res> get user {
  
  return $AuthUserDtoCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// Adds pattern-matching-related methods to [MeResponseDto].
extension MeResponseDtoPatterns on MeResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MeResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MeResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MeResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _MeResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MeResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _MeResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AuthUserDto user)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MeResponseDto() when $default != null:
return $default(_that.user);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AuthUserDto user)  $default,) {final _that = this;
switch (_that) {
case _MeResponseDto():
return $default(_that.user);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AuthUserDto user)?  $default,) {final _that = this;
switch (_that) {
case _MeResponseDto() when $default != null:
return $default(_that.user);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MeResponseDto implements MeResponseDto {
  const _MeResponseDto({required this.user});
  factory _MeResponseDto.fromJson(Map<String, dynamic> json) => _$MeResponseDtoFromJson(json);

@override final  AuthUserDto user;

/// Create a copy of MeResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeResponseDtoCopyWith<_MeResponseDto> get copyWith => __$MeResponseDtoCopyWithImpl<_MeResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MeResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MeResponseDto&&(identical(other.user, user) || other.user == user));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,user);

@override
String toString() {
  return 'MeResponseDto(user: $user)';
}


}

/// @nodoc
abstract mixin class _$MeResponseDtoCopyWith<$Res> implements $MeResponseDtoCopyWith<$Res> {
  factory _$MeResponseDtoCopyWith(_MeResponseDto value, $Res Function(_MeResponseDto) _then) = __$MeResponseDtoCopyWithImpl;
@override @useResult
$Res call({
 AuthUserDto user
});


@override $AuthUserDtoCopyWith<$Res> get user;

}
/// @nodoc
class __$MeResponseDtoCopyWithImpl<$Res>
    implements _$MeResponseDtoCopyWith<$Res> {
  __$MeResponseDtoCopyWithImpl(this._self, this._then);

  final _MeResponseDto _self;
  final $Res Function(_MeResponseDto) _then;

/// Create a copy of MeResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? user = null,}) {
  return _then(_MeResponseDto(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as AuthUserDto,
  ));
}

/// Create a copy of MeResponseDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthUserDtoCopyWith<$Res> get user {
  
  return $AuthUserDtoCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// @nodoc
mixin _$ApiErrorEnvelopeDto {

 ApiErrorDto? get error;
/// Create a copy of ApiErrorEnvelopeDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApiErrorEnvelopeDtoCopyWith<ApiErrorEnvelopeDto> get copyWith => _$ApiErrorEnvelopeDtoCopyWithImpl<ApiErrorEnvelopeDto>(this as ApiErrorEnvelopeDto, _$identity);

  /// Serializes this ApiErrorEnvelopeDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiErrorEnvelopeDto&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString() {
  return 'ApiErrorEnvelopeDto(error: $error)';
}


}

/// @nodoc
abstract mixin class $ApiErrorEnvelopeDtoCopyWith<$Res>  {
  factory $ApiErrorEnvelopeDtoCopyWith(ApiErrorEnvelopeDto value, $Res Function(ApiErrorEnvelopeDto) _then) = _$ApiErrorEnvelopeDtoCopyWithImpl;
@useResult
$Res call({
 ApiErrorDto? error
});


$ApiErrorDtoCopyWith<$Res>? get error;

}
/// @nodoc
class _$ApiErrorEnvelopeDtoCopyWithImpl<$Res>
    implements $ApiErrorEnvelopeDtoCopyWith<$Res> {
  _$ApiErrorEnvelopeDtoCopyWithImpl(this._self, this._then);

  final ApiErrorEnvelopeDto _self;
  final $Res Function(ApiErrorEnvelopeDto) _then;

/// Create a copy of ApiErrorEnvelopeDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? error = freezed,}) {
  return _then(_self.copyWith(
error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as ApiErrorDto?,
  ));
}
/// Create a copy of ApiErrorEnvelopeDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiErrorDtoCopyWith<$Res>? get error {
    if (_self.error == null) {
    return null;
  }

  return $ApiErrorDtoCopyWith<$Res>(_self.error!, (value) {
    return _then(_self.copyWith(error: value));
  });
}
}


/// Adds pattern-matching-related methods to [ApiErrorEnvelopeDto].
extension ApiErrorEnvelopeDtoPatterns on ApiErrorEnvelopeDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApiErrorEnvelopeDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApiErrorEnvelopeDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApiErrorEnvelopeDto value)  $default,){
final _that = this;
switch (_that) {
case _ApiErrorEnvelopeDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApiErrorEnvelopeDto value)?  $default,){
final _that = this;
switch (_that) {
case _ApiErrorEnvelopeDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ApiErrorDto? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApiErrorEnvelopeDto() when $default != null:
return $default(_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ApiErrorDto? error)  $default,) {final _that = this;
switch (_that) {
case _ApiErrorEnvelopeDto():
return $default(_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ApiErrorDto? error)?  $default,) {final _that = this;
switch (_that) {
case _ApiErrorEnvelopeDto() when $default != null:
return $default(_that.error);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ApiErrorEnvelopeDto implements ApiErrorEnvelopeDto {
  const _ApiErrorEnvelopeDto({this.error});
  factory _ApiErrorEnvelopeDto.fromJson(Map<String, dynamic> json) => _$ApiErrorEnvelopeDtoFromJson(json);

@override final  ApiErrorDto? error;

/// Create a copy of ApiErrorEnvelopeDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApiErrorEnvelopeDtoCopyWith<_ApiErrorEnvelopeDto> get copyWith => __$ApiErrorEnvelopeDtoCopyWithImpl<_ApiErrorEnvelopeDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApiErrorEnvelopeDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApiErrorEnvelopeDto&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString() {
  return 'ApiErrorEnvelopeDto(error: $error)';
}


}

/// @nodoc
abstract mixin class _$ApiErrorEnvelopeDtoCopyWith<$Res> implements $ApiErrorEnvelopeDtoCopyWith<$Res> {
  factory _$ApiErrorEnvelopeDtoCopyWith(_ApiErrorEnvelopeDto value, $Res Function(_ApiErrorEnvelopeDto) _then) = __$ApiErrorEnvelopeDtoCopyWithImpl;
@override @useResult
$Res call({
 ApiErrorDto? error
});


@override $ApiErrorDtoCopyWith<$Res>? get error;

}
/// @nodoc
class __$ApiErrorEnvelopeDtoCopyWithImpl<$Res>
    implements _$ApiErrorEnvelopeDtoCopyWith<$Res> {
  __$ApiErrorEnvelopeDtoCopyWithImpl(this._self, this._then);

  final _ApiErrorEnvelopeDto _self;
  final $Res Function(_ApiErrorEnvelopeDto) _then;

/// Create a copy of ApiErrorEnvelopeDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? error = freezed,}) {
  return _then(_ApiErrorEnvelopeDto(
error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as ApiErrorDto?,
  ));
}

/// Create a copy of ApiErrorEnvelopeDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiErrorDtoCopyWith<$Res>? get error {
    if (_self.error == null) {
    return null;
  }

  return $ApiErrorDtoCopyWith<$Res>(_self.error!, (value) {
    return _then(_self.copyWith(error: value));
  });
}
}


/// @nodoc
mixin _$ApiErrorDto {

 String? get code; String? get message;
/// Create a copy of ApiErrorDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApiErrorDtoCopyWith<ApiErrorDto> get copyWith => _$ApiErrorDtoCopyWithImpl<ApiErrorDto>(this as ApiErrorDto, _$identity);

  /// Serializes this ApiErrorDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiErrorDto&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,message);

@override
String toString() {
  return 'ApiErrorDto(code: $code, message: $message)';
}


}

/// @nodoc
abstract mixin class $ApiErrorDtoCopyWith<$Res>  {
  factory $ApiErrorDtoCopyWith(ApiErrorDto value, $Res Function(ApiErrorDto) _then) = _$ApiErrorDtoCopyWithImpl;
@useResult
$Res call({
 String? code, String? message
});




}
/// @nodoc
class _$ApiErrorDtoCopyWithImpl<$Res>
    implements $ApiErrorDtoCopyWith<$Res> {
  _$ApiErrorDtoCopyWithImpl(this._self, this._then);

  final ApiErrorDto _self;
  final $Res Function(ApiErrorDto) _then;

/// Create a copy of ApiErrorDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = freezed,Object? message = freezed,}) {
  return _then(_self.copyWith(
code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ApiErrorDto].
extension ApiErrorDtoPatterns on ApiErrorDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApiErrorDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApiErrorDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApiErrorDto value)  $default,){
final _that = this;
switch (_that) {
case _ApiErrorDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApiErrorDto value)?  $default,){
final _that = this;
switch (_that) {
case _ApiErrorDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? code,  String? message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApiErrorDto() when $default != null:
return $default(_that.code,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? code,  String? message)  $default,) {final _that = this;
switch (_that) {
case _ApiErrorDto():
return $default(_that.code,_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? code,  String? message)?  $default,) {final _that = this;
switch (_that) {
case _ApiErrorDto() when $default != null:
return $default(_that.code,_that.message);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ApiErrorDto implements ApiErrorDto {
  const _ApiErrorDto({this.code, this.message});
  factory _ApiErrorDto.fromJson(Map<String, dynamic> json) => _$ApiErrorDtoFromJson(json);

@override final  String? code;
@override final  String? message;

/// Create a copy of ApiErrorDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApiErrorDtoCopyWith<_ApiErrorDto> get copyWith => __$ApiErrorDtoCopyWithImpl<_ApiErrorDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApiErrorDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApiErrorDto&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,message);

@override
String toString() {
  return 'ApiErrorDto(code: $code, message: $message)';
}


}

/// @nodoc
abstract mixin class _$ApiErrorDtoCopyWith<$Res> implements $ApiErrorDtoCopyWith<$Res> {
  factory _$ApiErrorDtoCopyWith(_ApiErrorDto value, $Res Function(_ApiErrorDto) _then) = __$ApiErrorDtoCopyWithImpl;
@override @useResult
$Res call({
 String? code, String? message
});




}
/// @nodoc
class __$ApiErrorDtoCopyWithImpl<$Res>
    implements _$ApiErrorDtoCopyWith<$Res> {
  __$ApiErrorDtoCopyWithImpl(this._self, this._then);

  final _ApiErrorDto _self;
  final $Res Function(_ApiErrorDto) _then;

/// Create a copy of ApiErrorDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = freezed,Object? message = freezed,}) {
  return _then(_ApiErrorDto(
code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
