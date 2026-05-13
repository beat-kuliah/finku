import 'package:freezed_annotation/freezed_annotation.dart';

part 'categories_dto.freezed.dart';
part 'categories_dto.g.dart';

@freezed
abstract class CategoryDto with _$CategoryDto {
  const factory CategoryDto({
    required String id,
    required String userId,
    required String name,
    required String kind,
    String? icon,
    String? archivedAt,
    required String createdAt,
    required String updatedAt,
  }) = _CategoryDto;

  factory CategoryDto.fromJson(Map<String, dynamic> json) => _$CategoryDtoFromJson(json);
}

@freezed
abstract class ListCategoriesResponseDto with _$ListCategoriesResponseDto {
  const factory ListCategoriesResponseDto({
    required List<CategoryDto> categories,
  }) = _ListCategoriesResponseDto;

  factory ListCategoriesResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ListCategoriesResponseDtoFromJson(json);
}

@freezed
abstract class CategoryEnvelopeDto with _$CategoryEnvelopeDto {
  const factory CategoryEnvelopeDto({
    required CategoryDto category,
  }) = _CategoryEnvelopeDto;

  factory CategoryEnvelopeDto.fromJson(Map<String, dynamic> json) => _$CategoryEnvelopeDtoFromJson(json);
}
