// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'categories_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CategoryDto {

 String get id; String get userId; String get name; String get kind; String? get icon; String? get archivedAt; String get createdAt; String get updatedAt;
/// Create a copy of CategoryDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryDtoCopyWith<CategoryDto> get copyWith => _$CategoryDtoCopyWithImpl<CategoryDto>(this as CategoryDto, _$identity);

  /// Serializes this CategoryDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryDto&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.archivedAt, archivedAt) || other.archivedAt == archivedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,name,kind,icon,archivedAt,createdAt,updatedAt);

@override
String toString() {
  return 'CategoryDto(id: $id, userId: $userId, name: $name, kind: $kind, icon: $icon, archivedAt: $archivedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $CategoryDtoCopyWith<$Res>  {
  factory $CategoryDtoCopyWith(CategoryDto value, $Res Function(CategoryDto) _then) = _$CategoryDtoCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String name, String kind, String? icon, String? archivedAt, String createdAt, String updatedAt
});




}
/// @nodoc
class _$CategoryDtoCopyWithImpl<$Res>
    implements $CategoryDtoCopyWith<$Res> {
  _$CategoryDtoCopyWithImpl(this._self, this._then);

  final CategoryDto _self;
  final $Res Function(CategoryDto) _then;

/// Create a copy of CategoryDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? name = null,Object? kind = null,Object? icon = freezed,Object? archivedAt = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,archivedAt: freezed == archivedAt ? _self.archivedAt : archivedAt // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CategoryDto].
extension CategoryDtoPatterns on CategoryDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategoryDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategoryDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategoryDto value)  $default,){
final _that = this;
switch (_that) {
case _CategoryDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategoryDto value)?  $default,){
final _that = this;
switch (_that) {
case _CategoryDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String name,  String kind,  String? icon,  String? archivedAt,  String createdAt,  String updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CategoryDto() when $default != null:
return $default(_that.id,_that.userId,_that.name,_that.kind,_that.icon,_that.archivedAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String name,  String kind,  String? icon,  String? archivedAt,  String createdAt,  String updatedAt)  $default,) {final _that = this;
switch (_that) {
case _CategoryDto():
return $default(_that.id,_that.userId,_that.name,_that.kind,_that.icon,_that.archivedAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String name,  String kind,  String? icon,  String? archivedAt,  String createdAt,  String updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _CategoryDto() when $default != null:
return $default(_that.id,_that.userId,_that.name,_that.kind,_that.icon,_that.archivedAt,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CategoryDto implements CategoryDto {
  const _CategoryDto({required this.id, required this.userId, required this.name, required this.kind, this.icon, this.archivedAt, required this.createdAt, required this.updatedAt});
  factory _CategoryDto.fromJson(Map<String, dynamic> json) => _$CategoryDtoFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String name;
@override final  String kind;
@override final  String? icon;
@override final  String? archivedAt;
@override final  String createdAt;
@override final  String updatedAt;

/// Create a copy of CategoryDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryDtoCopyWith<_CategoryDto> get copyWith => __$CategoryDtoCopyWithImpl<_CategoryDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CategoryDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoryDto&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.archivedAt, archivedAt) || other.archivedAt == archivedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,name,kind,icon,archivedAt,createdAt,updatedAt);

@override
String toString() {
  return 'CategoryDto(id: $id, userId: $userId, name: $name, kind: $kind, icon: $icon, archivedAt: $archivedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$CategoryDtoCopyWith<$Res> implements $CategoryDtoCopyWith<$Res> {
  factory _$CategoryDtoCopyWith(_CategoryDto value, $Res Function(_CategoryDto) _then) = __$CategoryDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String name, String kind, String? icon, String? archivedAt, String createdAt, String updatedAt
});




}
/// @nodoc
class __$CategoryDtoCopyWithImpl<$Res>
    implements _$CategoryDtoCopyWith<$Res> {
  __$CategoryDtoCopyWithImpl(this._self, this._then);

  final _CategoryDto _self;
  final $Res Function(_CategoryDto) _then;

/// Create a copy of CategoryDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? name = null,Object? kind = null,Object? icon = freezed,Object? archivedAt = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_CategoryDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,archivedAt: freezed == archivedAt ? _self.archivedAt : archivedAt // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ListCategoriesResponseDto {

 List<CategoryDto> get categories;
/// Create a copy of ListCategoriesResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ListCategoriesResponseDtoCopyWith<ListCategoriesResponseDto> get copyWith => _$ListCategoriesResponseDtoCopyWithImpl<ListCategoriesResponseDto>(this as ListCategoriesResponseDto, _$identity);

  /// Serializes this ListCategoriesResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ListCategoriesResponseDto&&const DeepCollectionEquality().equals(other.categories, categories));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(categories));

@override
String toString() {
  return 'ListCategoriesResponseDto(categories: $categories)';
}


}

/// @nodoc
abstract mixin class $ListCategoriesResponseDtoCopyWith<$Res>  {
  factory $ListCategoriesResponseDtoCopyWith(ListCategoriesResponseDto value, $Res Function(ListCategoriesResponseDto) _then) = _$ListCategoriesResponseDtoCopyWithImpl;
@useResult
$Res call({
 List<CategoryDto> categories
});




}
/// @nodoc
class _$ListCategoriesResponseDtoCopyWithImpl<$Res>
    implements $ListCategoriesResponseDtoCopyWith<$Res> {
  _$ListCategoriesResponseDtoCopyWithImpl(this._self, this._then);

  final ListCategoriesResponseDto _self;
  final $Res Function(ListCategoriesResponseDto) _then;

/// Create a copy of ListCategoriesResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categories = null,}) {
  return _then(_self.copyWith(
categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<CategoryDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [ListCategoriesResponseDto].
extension ListCategoriesResponseDtoPatterns on ListCategoriesResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ListCategoriesResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ListCategoriesResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ListCategoriesResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _ListCategoriesResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ListCategoriesResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _ListCategoriesResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<CategoryDto> categories)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ListCategoriesResponseDto() when $default != null:
return $default(_that.categories);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<CategoryDto> categories)  $default,) {final _that = this;
switch (_that) {
case _ListCategoriesResponseDto():
return $default(_that.categories);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<CategoryDto> categories)?  $default,) {final _that = this;
switch (_that) {
case _ListCategoriesResponseDto() when $default != null:
return $default(_that.categories);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ListCategoriesResponseDto implements ListCategoriesResponseDto {
  const _ListCategoriesResponseDto({required final  List<CategoryDto> categories}): _categories = categories;
  factory _ListCategoriesResponseDto.fromJson(Map<String, dynamic> json) => _$ListCategoriesResponseDtoFromJson(json);

 final  List<CategoryDto> _categories;
@override List<CategoryDto> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}


/// Create a copy of ListCategoriesResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ListCategoriesResponseDtoCopyWith<_ListCategoriesResponseDto> get copyWith => __$ListCategoriesResponseDtoCopyWithImpl<_ListCategoriesResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ListCategoriesResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ListCategoriesResponseDto&&const DeepCollectionEquality().equals(other._categories, _categories));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_categories));

@override
String toString() {
  return 'ListCategoriesResponseDto(categories: $categories)';
}


}

/// @nodoc
abstract mixin class _$ListCategoriesResponseDtoCopyWith<$Res> implements $ListCategoriesResponseDtoCopyWith<$Res> {
  factory _$ListCategoriesResponseDtoCopyWith(_ListCategoriesResponseDto value, $Res Function(_ListCategoriesResponseDto) _then) = __$ListCategoriesResponseDtoCopyWithImpl;
@override @useResult
$Res call({
 List<CategoryDto> categories
});




}
/// @nodoc
class __$ListCategoriesResponseDtoCopyWithImpl<$Res>
    implements _$ListCategoriesResponseDtoCopyWith<$Res> {
  __$ListCategoriesResponseDtoCopyWithImpl(this._self, this._then);

  final _ListCategoriesResponseDto _self;
  final $Res Function(_ListCategoriesResponseDto) _then;

/// Create a copy of ListCategoriesResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categories = null,}) {
  return _then(_ListCategoriesResponseDto(
categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<CategoryDto>,
  ));
}


}


/// @nodoc
mixin _$CategoryEnvelopeDto {

 CategoryDto get category;
/// Create a copy of CategoryEnvelopeDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryEnvelopeDtoCopyWith<CategoryEnvelopeDto> get copyWith => _$CategoryEnvelopeDtoCopyWithImpl<CategoryEnvelopeDto>(this as CategoryEnvelopeDto, _$identity);

  /// Serializes this CategoryEnvelopeDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryEnvelopeDto&&(identical(other.category, category) || other.category == category));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,category);

@override
String toString() {
  return 'CategoryEnvelopeDto(category: $category)';
}


}

/// @nodoc
abstract mixin class $CategoryEnvelopeDtoCopyWith<$Res>  {
  factory $CategoryEnvelopeDtoCopyWith(CategoryEnvelopeDto value, $Res Function(CategoryEnvelopeDto) _then) = _$CategoryEnvelopeDtoCopyWithImpl;
@useResult
$Res call({
 CategoryDto category
});


$CategoryDtoCopyWith<$Res> get category;

}
/// @nodoc
class _$CategoryEnvelopeDtoCopyWithImpl<$Res>
    implements $CategoryEnvelopeDtoCopyWith<$Res> {
  _$CategoryEnvelopeDtoCopyWithImpl(this._self, this._then);

  final CategoryEnvelopeDto _self;
  final $Res Function(CategoryEnvelopeDto) _then;

/// Create a copy of CategoryEnvelopeDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? category = null,}) {
  return _then(_self.copyWith(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as CategoryDto,
  ));
}
/// Create a copy of CategoryEnvelopeDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategoryDtoCopyWith<$Res> get category {
  
  return $CategoryDtoCopyWith<$Res>(_self.category, (value) {
    return _then(_self.copyWith(category: value));
  });
}
}


/// Adds pattern-matching-related methods to [CategoryEnvelopeDto].
extension CategoryEnvelopeDtoPatterns on CategoryEnvelopeDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategoryEnvelopeDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategoryEnvelopeDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategoryEnvelopeDto value)  $default,){
final _that = this;
switch (_that) {
case _CategoryEnvelopeDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategoryEnvelopeDto value)?  $default,){
final _that = this;
switch (_that) {
case _CategoryEnvelopeDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CategoryDto category)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CategoryEnvelopeDto() when $default != null:
return $default(_that.category);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CategoryDto category)  $default,) {final _that = this;
switch (_that) {
case _CategoryEnvelopeDto():
return $default(_that.category);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CategoryDto category)?  $default,) {final _that = this;
switch (_that) {
case _CategoryEnvelopeDto() when $default != null:
return $default(_that.category);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CategoryEnvelopeDto implements CategoryEnvelopeDto {
  const _CategoryEnvelopeDto({required this.category});
  factory _CategoryEnvelopeDto.fromJson(Map<String, dynamic> json) => _$CategoryEnvelopeDtoFromJson(json);

@override final  CategoryDto category;

/// Create a copy of CategoryEnvelopeDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryEnvelopeDtoCopyWith<_CategoryEnvelopeDto> get copyWith => __$CategoryEnvelopeDtoCopyWithImpl<_CategoryEnvelopeDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CategoryEnvelopeDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoryEnvelopeDto&&(identical(other.category, category) || other.category == category));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,category);

@override
String toString() {
  return 'CategoryEnvelopeDto(category: $category)';
}


}

/// @nodoc
abstract mixin class _$CategoryEnvelopeDtoCopyWith<$Res> implements $CategoryEnvelopeDtoCopyWith<$Res> {
  factory _$CategoryEnvelopeDtoCopyWith(_CategoryEnvelopeDto value, $Res Function(_CategoryEnvelopeDto) _then) = __$CategoryEnvelopeDtoCopyWithImpl;
@override @useResult
$Res call({
 CategoryDto category
});


@override $CategoryDtoCopyWith<$Res> get category;

}
/// @nodoc
class __$CategoryEnvelopeDtoCopyWithImpl<$Res>
    implements _$CategoryEnvelopeDtoCopyWith<$Res> {
  __$CategoryEnvelopeDtoCopyWithImpl(this._self, this._then);

  final _CategoryEnvelopeDto _self;
  final $Res Function(_CategoryEnvelopeDto) _then;

/// Create a copy of CategoryEnvelopeDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? category = null,}) {
  return _then(_CategoryEnvelopeDto(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as CategoryDto,
  ));
}

/// Create a copy of CategoryEnvelopeDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategoryDtoCopyWith<$Res> get category {
  
  return $CategoryDtoCopyWith<$Res>(_self.category, (value) {
    return _then(_self.copyWith(category: value));
  });
}
}

// dart format on
