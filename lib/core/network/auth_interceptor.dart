import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  String? _token;

  void setToken(String? token) {
    _token = token;
  }

  void clearToken() {
    _token = null;
  }

  bool get hasToken => _token != null && _token!.isNotEmpty;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (_token != null && _token!.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $_token';
    }
    super.onRequest(options, handler);
  }
}
