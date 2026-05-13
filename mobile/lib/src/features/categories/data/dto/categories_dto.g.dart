// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categories_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CategoryDto _$CategoryDtoFromJson(Map<String, dynamic> json) => _CategoryDto(
  id: json['id'] as String,
  userId: json['userId'] as String,
  name: json['name'] as String,
  kind: json['kind'] as String,
  icon: json['icon'] as String?,
  archivedAt: json['archivedAt'] as String?,
  createdAt: json['createdAt'] as String,
  updatedAt: json['updatedAt'] as String,
);

Map<String, dynamic> _$CategoryDtoToJson(_CategoryDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'name': instance.name,
      'kind': instance.kind,
      'icon': instance.icon,
      'archivedAt': instance.archivedAt,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

_ListCategoriesResponseDto _$ListCategoriesResponseDtoFromJson(
  Map<String, dynamic> json,
) => _ListCategoriesResponseDto(
  categories: (json['categories'] as List<dynamic>)
      .map((e) => CategoryDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ListCategoriesResponseDtoToJson(
  _ListCategoriesResponseDto instance,
) => <String, dynamic>{'categories': instance.categories};

_CategoryEnvelopeDto _$CategoryEnvelopeDtoFromJson(Map<String, dynamic> json) =>
    _CategoryEnvelopeDto(
      category: CategoryDto.fromJson(json['category'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CategoryEnvelopeDtoToJson(
  _CategoryEnvelopeDto instance,
) => <String, dynamic>{'category': instance.category};
