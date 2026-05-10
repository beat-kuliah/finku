class ApiError implements Exception {
  ApiError({
    required this.message,
    required this.statusCode,
    this.code,
  });

  final String message;
  final int statusCode;
  final String? code;

  @override
  String toString() => 'ApiError(statusCode: $statusCode, code: $code, message: $message)';
}
