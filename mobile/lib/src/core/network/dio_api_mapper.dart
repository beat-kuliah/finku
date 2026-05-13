import 'package:dio/dio.dart';
import 'package:finku_mobile/src/core/errors/api_error.dart';
import 'package:finku_mobile/src/features/auth/data/dto/auth_dto.dart';

/// Maps [DioException] and other errors to [ApiError] for consistent UI handling.
ApiError mapDioToApiError(Object error) {
  if (error is DioException) {
    final status = error.response?.statusCode ?? 0;
    final payload = error.response?.data;
    if (payload is Map<String, dynamic>) {
      final envelope = ApiErrorEnvelopeDto.fromJson(payload);
      return ApiError(
        message: envelope.error?.message ?? error.message ?? 'Request failed',
        statusCode: status,
        code: envelope.error?.code,
      );
    }
    return ApiError(message: error.message ?? 'Request failed', statusCode: status);
  }
  if (error is ApiError) return error;
  return ApiError(message: error.toString(), statusCode: 0);
}
