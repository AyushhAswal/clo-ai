import 'package:dio/dio.dart';
import 'api_config.dart';
import 'api_exception.dart';
import 'auth_interceptor.dart';

class ApiClient {
  static ApiClient? _instance;
  late final Dio _dio;
  late final AuthInterceptor _authInterceptor;

  factory ApiClient({Dio? dio, String? baseUrl}) {
    if (dio != null || baseUrl != null) {
      return ApiClient._internal(dio: dio, baseUrl: baseUrl);
    }
    _instance ??= ApiClient._internal();
    return _instance!;
  }

  ApiClient._internal({Dio? dio, String? baseUrl}) {
    _authInterceptor = AuthInterceptor();
    _dio =
        dio ??
        Dio(
          BaseOptions(
            baseUrl: baseUrl ?? ApiConfig.baseUrl,
            connectTimeout: ApiConfig.connectTimeout,
            receiveTimeout: ApiConfig.receiveTimeout,
            sendTimeout: ApiConfig.sendTimeout,
            headers: const {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        );

    _dio.interceptors.add(_authInterceptor);
  }

  Dio get dio => _dio;
  AuthInterceptor get authInterceptor => _authInterceptor;

  void setAuthToken(String? token) {
    _authInterceptor.setToken(token);
  }

  void clearAuthToken() {
    _authInterceptor.clearToken();
  }

  bool get isAuthenticated => _authInterceptor.hasToken;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
