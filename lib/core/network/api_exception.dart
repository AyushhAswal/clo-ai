import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic errorData;

  const ApiException({required this.message, this.statusCode, this.errorData});

  factory ApiException.fromDioException(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
        return const ApiException(
          message: 'Connection timeout. Please check your internet connection.',
        );
      case DioExceptionType.sendTimeout:
        return const ApiException(message: 'Send timeout. Please try again.');
      case DioExceptionType.receiveTimeout:
        return const ApiException(
          message: 'Receive timeout. Server is taking too long to respond.',
        );
      case DioExceptionType.connectionError:
        return const ApiException(
          message:
              'Unable to connect to server. Please verify network connection.',
        );
      case DioExceptionType.cancel:
        return const ApiException(message: 'Request was cancelled.');
      case DioExceptionType.badResponse:
        final statusCode = dioException.response?.statusCode;
        final responseData = dioException.response?.data;
        String message = 'Unexpected server response';

        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('message')) {
          final serverMessage = responseData['message'];
          if (serverMessage is String) {
            message = serverMessage;
          } else if (serverMessage is List) {
            message = serverMessage.join(', ');
          }
        }

        switch (statusCode) {
          case 400:
            return ApiException(
              message: message.isNotEmpty ? message : 'Bad request',
              statusCode: 400,
              errorData: responseData,
            );
          case 401:
            return ApiException(
              message: message.isNotEmpty ? message : 'Unauthorized access',
              statusCode: 401,
              errorData: responseData,
            );
          case 403:
            return ApiException(
              message: message.isNotEmpty ? message : 'Access forbidden',
              statusCode: 403,
              errorData: responseData,
            );
          case 404:
            return ApiException(
              message: message.isNotEmpty ? message : 'Resource not found',
              statusCode: 404,
              errorData: responseData,
            );
          case 409:
            return ApiException(
              message: message.isNotEmpty ? message : 'Conflict occurred',
              statusCode: 409,
              errorData: responseData,
            );
          case 500:
          default:
            return ApiException(
              message: message.isNotEmpty ? message : 'Internal server error',
              statusCode: statusCode,
              errorData: responseData,
            );
        }
      case DioExceptionType.badCertificate:
        return const ApiException(message: 'Invalid server certificate.');
      case DioExceptionType.unknown:
      default:
        return ApiException(
          message:
              dioException.message ?? 'An unexpected network error occurred',
        );
    }
  }

  @override
  String toString() =>
      'ApiException(statusCode: $statusCode, message: $message)';
}
