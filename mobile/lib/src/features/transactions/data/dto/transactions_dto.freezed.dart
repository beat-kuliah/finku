// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transactions_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TransactionDto {

 String get id; String get userId; String get kind; String get walletId; String? get destWalletId; String? get categoryId; String? get categoryName; int get amount; String get occurredAt; String? get description; bool? get isBalanceIncrease; String get createdAt; String get updatedAt;
/// Create a copy of TransactionDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionDtoCopyWith<TransactionDto> get copyWith => _$TransactionDtoCopyWithImpl<TransactionDto>(this as TransactionDto, _$identity);

  /// Serializes this TransactionDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionDto&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.walletId, walletId) || other.walletId == walletId)&&(identical(other.destWalletId, destWalletId) || other.destWalletId == destWalletId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt)&&(identical(other.description, description) || other.description == description)&&(identical(other.isBalanceIncrease, isBalanceIncrease) || other.isBalanceIncrease == isBalanceIncrease)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,kind,walletId,destWalletId,categoryId,categoryName,amount,occurredAt,description,isBalanceIncrease,createdAt,updatedAt);

@override
String toString() {
  return 'TransactionDto(id: $id, userId: $userId, kind: $kind, walletId: $walletId, destWalletId: $destWalletId, categoryId: $categoryId, categoryName: $categoryName, amount: $amount, occurredAt: $occurredAt, description: $description, isBalanceIncrease: $isBalanceIncrease, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $TransactionDtoCopyWith<$Res>  {
  factory $TransactionDtoCopyWith(TransactionDto value, $Res Function(TransactionDto) _then) = _$TransactionDtoCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String kind, String walletId, String? destWalletId, String? categoryId, String? categoryName, int amount, String occurredAt, String? description, bool? isBalanceIncrease, String createdAt, String updatedAt
});




}
/// @nodoc
class _$TransactionDtoCopyWithImpl<$Res>
    implements $TransactionDtoCopyWith<$Res> {
  _$TransactionDtoCopyWithImpl(this._self, this._then);

  final TransactionDto _self;
  final $Res Function(TransactionDto) _then;

/// Create a copy of TransactionDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? kind = null,Object? walletId = null,Object? destWalletId = freezed,Object? categoryId = freezed,Object? categoryName = freezed,Object? amount = null,Object? occurredAt = null,Object? description = freezed,Object? isBalanceIncrease = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,walletId: null == walletId ? _self.walletId : walletId // ignore: cast_nullable_to_non_nullable
as String,destWalletId: freezed == destWalletId ? _self.destWalletId : destWalletId // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,categoryName: freezed == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isBalanceIncrease: freezed == isBalanceIncrease ? _self.isBalanceIncrease : isBalanceIncrease // ignore: cast_nullable_to_non_nullable
as bool?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TransactionDto].
extension TransactionDtoPatterns on TransactionDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionDto value)  $default,){
final _that = this;
switch (_that) {
case _TransactionDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionDto value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String kind,  String walletId,  String? destWalletId,  String? categoryId,  String? categoryName,  int amount,  String occurredAt,  String? description,  bool? isBalanceIncrease,  String createdAt,  String updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionDto() when $default != null:
return $default(_that.id,_that.userId,_that.kind,_that.walletId,_that.destWalletId,_that.categoryId,_that.categoryName,_that.amount,_that.occurredAt,_that.description,_that.isBalanceIncrease,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String kind,  String walletId,  String? destWalletId,  String? categoryId,  String? categoryName,  int amount,  String occurredAt,  String? description,  bool? isBalanceIncrease,  String createdAt,  String updatedAt)  $default,) {final _that = this;
switch (_that) {
case _TransactionDto():
return $default(_that.id,_that.userId,_that.kind,_that.walletId,_that.destWalletId,_that.categoryId,_that.categoryName,_that.amount,_that.occurredAt,_that.description,_that.isBalanceIncrease,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String kind,  String walletId,  String? destWalletId,  String? categoryId,  String? categoryName,  int amount,  String occurredAt,  String? description,  bool? isBalanceIncrease,  String createdAt,  String updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _TransactionDto() when $default != null:
return $default(_that.id,_that.userId,_that.kind,_that.walletId,_that.destWalletId,_that.categoryId,_that.categoryName,_that.amount,_that.occurredAt,_that.description,_that.isBalanceIncrease,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransactionDto implements TransactionDto {
  const _TransactionDto({required this.id, required this.userId, required this.kind, required this.walletId, this.destWalletId, this.categoryId, this.categoryName, required this.amount, required this.occurredAt, this.description, this.isBalanceIncrease, required this.createdAt, required this.updatedAt});
  factory _TransactionDto.fromJson(Map<String, dynamic> json) => _$TransactionDtoFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String kind;
@override final  String walletId;
@override final  String? destWalletId;
@override final  String? categoryId;
@override final  String? categoryName;
@override final  int amount;
@override final  String occurredAt;
@override final  String? description;
@override final  bool? isBalanceIncrease;
@override final  String createdAt;
@override final  String updatedAt;

/// Create a copy of TransactionDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionDtoCopyWith<_TransactionDto> get copyWith => __$TransactionDtoCopyWithImpl<_TransactionDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransactionDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionDto&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.walletId, walletId) || other.walletId == walletId)&&(identical(other.destWalletId, destWalletId) || other.destWalletId == destWalletId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt)&&(identical(other.description, description) || other.description == description)&&(identical(other.isBalanceIncrease, isBalanceIncrease) || other.isBalanceIncrease == isBalanceIncrease)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,kind,walletId,destWalletId,categoryId,categoryName,amount,occurredAt,description,isBalanceIncrease,createdAt,updatedAt);

@override
String toString() {
  return 'TransactionDto(id: $id, userId: $userId, kind: $kind, walletId: $walletId, destWalletId: $destWalletId, categoryId: $categoryId, categoryName: $categoryName, amount: $amount, occurredAt: $occurredAt, description: $description, isBalanceIncrease: $isBalanceIncrease, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$TransactionDtoCopyWith<$Res> implements $TransactionDtoCopyWith<$Res> {
  factory _$TransactionDtoCopyWith(_TransactionDto value, $Res Function(_TransactionDto) _then) = __$TransactionDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String kind, String walletId, String? destWalletId, String? categoryId, String? categoryName, int amount, String occurredAt, String? description, bool? isBalanceIncrease, String createdAt, String updatedAt
});




}
/// @nodoc
class __$TransactionDtoCopyWithImpl<$Res>
    implements _$TransactionDtoCopyWith<$Res> {
  __$TransactionDtoCopyWithImpl(this._self, this._then);

  final _TransactionDto _self;
  final $Res Function(_TransactionDto) _then;

/// Create a copy of TransactionDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? kind = null,Object? walletId = null,Object? destWalletId = freezed,Object? categoryId = freezed,Object? categoryName = freezed,Object? amount = null,Object? occurredAt = null,Object? description = freezed,Object? isBalanceIncrease = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_TransactionDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,walletId: null == walletId ? _self.walletId : walletId // ignore: cast_nullable_to_non_nullable
as String,destWalletId: freezed == destWalletId ? _self.destWalletId : destWalletId // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,categoryName: freezed == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isBalanceIncrease: freezed == isBalanceIncrease ? _self.isBalanceIncrease : isBalanceIncrease // ignore: cast_nullable_to_non_nullable
as bool?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ListTransactionsResponseDto {

 List<TransactionDto> get transactions;
/// Create a copy of ListTransactionsResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ListTransactionsResponseDtoCopyWith<ListTransactionsResponseDto> get copyWith => _$ListTransactionsResponseDtoCopyWithImpl<ListTransactionsResponseDto>(this as ListTransactionsResponseDto, _$identity);

  /// Serializes this ListTransactionsResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ListTransactionsResponseDto&&const DeepCollectionEquality().equals(other.transactions, transactions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(transactions));

@override
String toString() {
  return 'ListTransactionsResponseDto(transactions: $transactions)';
}


}

/// @nodoc
abstract mixin class $ListTransactionsResponseDtoCopyWith<$Res>  {
  factory $ListTransactionsResponseDtoCopyWith(ListTransactionsResponseDto value, $Res Function(ListTransactionsResponseDto) _then) = _$ListTransactionsResponseDtoCopyWithImpl;
@useResult
$Res call({
 List<TransactionDto> transactions
});




}
/// @nodoc
class _$ListTransactionsResponseDtoCopyWithImpl<$Res>
    implements $ListTransactionsResponseDtoCopyWith<$Res> {
  _$ListTransactionsResponseDtoCopyWithImpl(this._self, this._then);

  final ListTransactionsResponseDto _self;
  final $Res Function(ListTransactionsResponseDto) _then;

/// Create a copy of ListTransactionsResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? transactions = null,}) {
  return _then(_self.copyWith(
transactions: null == transactions ? _self.transactions : transactions // ignore: cast_nullable_to_non_nullable
as List<TransactionDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [ListTransactionsResponseDto].
extension ListTransactionsResponseDtoPatterns on ListTransactionsResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ListTransactionsResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ListTransactionsResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ListTransactionsResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _ListTransactionsResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ListTransactionsResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _ListTransactionsResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<TransactionDto> transactions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ListTransactionsResponseDto() when $default != null:
return $default(_that.transactions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<TransactionDto> transactions)  $default,) {final _that = this;
switch (_that) {
case _ListTransactionsResponseDto():
return $default(_that.transactions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<TransactionDto> transactions)?  $default,) {final _that = this;
switch (_that) {
case _ListTransactionsResponseDto() when $default != null:
return $default(_that.transactions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ListTransactionsResponseDto implements ListTransactionsResponseDto {
  const _ListTransactionsResponseDto({required final  List<TransactionDto> transactions}): _transactions = transactions;
  factory _ListTransactionsResponseDto.fromJson(Map<String, dynamic> json) => _$ListTransactionsResponseDtoFromJson(json);

 final  List<TransactionDto> _transactions;
@override List<TransactionDto> get transactions {
  if (_transactions is EqualUnmodifiableListView) return _transactions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_transactions);
}


/// Create a copy of ListTransactionsResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ListTransactionsResponseDtoCopyWith<_ListTransactionsResponseDto> get copyWith => __$ListTransactionsResponseDtoCopyWithImpl<_ListTransactionsResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ListTransactionsResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ListTransactionsResponseDto&&const DeepCollectionEquality().equals(other._transactions, _transactions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_transactions));

@override
String toString() {
  return 'ListTransactionsResponseDto(transactions: $transactions)';
}


}

/// @nodoc
abstract mixin class _$ListTransactionsResponseDtoCopyWith<$Res> implements $ListTransactionsResponseDtoCopyWith<$Res> {
  factory _$ListTransactionsResponseDtoCopyWith(_ListTransactionsResponseDto value, $Res Function(_ListTransactionsResponseDto) _then) = __$ListTransactionsResponseDtoCopyWithImpl;
@override @useResult
$Res call({
 List<TransactionDto> transactions
});




}
/// @nodoc
class __$ListTransactionsResponseDtoCopyWithImpl<$Res>
    implements _$ListTransactionsResponseDtoCopyWith<$Res> {
  __$ListTransactionsResponseDtoCopyWithImpl(this._self, this._then);

  final _ListTransactionsResponseDto _self;
  final $Res Function(_ListTransactionsResponseDto) _then;

/// Create a copy of ListTransactionsResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? transactions = null,}) {
  return _then(_ListTransactionsResponseDto(
transactions: null == transactions ? _self._transactions : transactions // ignore: cast_nullable_to_non_nullable
as List<TransactionDto>,
  ));
}


}


/// @nodoc
mixin _$TransactionEnvelopeDto {

 TransactionDto get transaction;
/// Create a copy of TransactionEnvelopeDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionEnvelopeDtoCopyWith<TransactionEnvelopeDto> get copyWith => _$TransactionEnvelopeDtoCopyWithImpl<TransactionEnvelopeDto>(this as TransactionEnvelopeDto, _$identity);

  /// Serializes this TransactionEnvelopeDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionEnvelopeDto&&(identical(other.transaction, transaction) || other.transaction == transaction));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,transaction);

@override
String toString() {
  return 'TransactionEnvelopeDto(transaction: $transaction)';
}


}

/// @nodoc
abstract mixin class $TransactionEnvelopeDtoCopyWith<$Res>  {
  factory $TransactionEnvelopeDtoCopyWith(TransactionEnvelopeDto value, $Res Function(TransactionEnvelopeDto) _then) = _$TransactionEnvelopeDtoCopyWithImpl;
@useResult
$Res call({
 TransactionDto transaction
});


$TransactionDtoCopyWith<$Res> get transaction;

}
/// @nodoc
class _$TransactionEnvelopeDtoCopyWithImpl<$Res>
    implements $TransactionEnvelopeDtoCopyWith<$Res> {
  _$TransactionEnvelopeDtoCopyWithImpl(this._self, this._then);

  final TransactionEnvelopeDto _self;
  final $Res Function(TransactionEnvelopeDto) _then;

/// Create a copy of TransactionEnvelopeDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? transaction = null,}) {
  return _then(_self.copyWith(
transaction: null == transaction ? _self.transaction : transaction // ignore: cast_nullable_to_non_nullable
as TransactionDto,
  ));
}
/// Create a copy of TransactionEnvelopeDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransactionDtoCopyWith<$Res> get transaction {
  
  return $TransactionDtoCopyWith<$Res>(_self.transaction, (value) {
    return _then(_self.copyWith(transaction: value));
  });
}
}


/// Adds pattern-matching-related methods to [TransactionEnvelopeDto].
extension TransactionEnvelopeDtoPatterns on TransactionEnvelopeDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionEnvelopeDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionEnvelopeDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionEnvelopeDto value)  $default,){
final _that = this;
switch (_that) {
case _TransactionEnvelopeDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionEnvelopeDto value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionEnvelopeDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TransactionDto transaction)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionEnvelopeDto() when $default != null:
return $default(_that.transaction);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TransactionDto transaction)  $default,) {final _that = this;
switch (_that) {
case _TransactionEnvelopeDto():
return $default(_that.transaction);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TransactionDto transaction)?  $default,) {final _that = this;
switch (_that) {
case _TransactionEnvelopeDto() when $default != null:
return $default(_that.transaction);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransactionEnvelopeDto implements TransactionEnvelopeDto {
  const _TransactionEnvelopeDto({required this.transaction});
  factory _TransactionEnvelopeDto.fromJson(Map<String, dynamic> json) => _$TransactionEnvelopeDtoFromJson(json);

@override final  TransactionDto transaction;

/// Create a copy of TransactionEnvelopeDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionEnvelopeDtoCopyWith<_TransactionEnvelopeDto> get copyWith => __$TransactionEnvelopeDtoCopyWithImpl<_TransactionEnvelopeDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransactionEnvelopeDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionEnvelopeDto&&(identical(other.transaction, transaction) || other.transaction == transaction));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,transaction);

@override
String toString() {
  return 'TransactionEnvelopeDto(transaction: $transaction)';
}


}

/// @nodoc
abstract mixin class _$TransactionEnvelopeDtoCopyWith<$Res> implements $TransactionEnvelopeDtoCopyWith<$Res> {
  factory _$TransactionEnvelopeDtoCopyWith(_TransactionEnvelopeDto value, $Res Function(_TransactionEnvelopeDto) _then) = __$TransactionEnvelopeDtoCopyWithImpl;
@override @useResult
$Res call({
 TransactionDto transaction
});


@override $TransactionDtoCopyWith<$Res> get transaction;

}
/// @nodoc
class __$TransactionEnvelopeDtoCopyWithImpl<$Res>
    implements _$TransactionEnvelopeDtoCopyWith<$Res> {
  __$TransactionEnvelopeDtoCopyWithImpl(this._self, this._then);

  final _TransactionEnvelopeDto _self;
  final $Res Function(_TransactionEnvelopeDto) _then;

/// Create a copy of TransactionEnvelopeDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? transaction = null,}) {
  return _then(_TransactionEnvelopeDto(
transaction: null == transaction ? _self.transaction : transaction // ignore: cast_nullable_to_non_nullable
as TransactionDto,
  ));
}

/// Create a copy of TransactionEnvelopeDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransactionDtoCopyWith<$Res> get transaction {
  
  return $TransactionDtoCopyWith<$Res>(_self.transaction, (value) {
    return _then(_self.copyWith(transaction: value));
  });
}
}

// dart format on
