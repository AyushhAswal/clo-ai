enum ApiEnvironment { local, dev, prod }

class ApiConfig {
  static const String localBaseUrl = 'http://10.0.2.2:3000';
  static const String devBaseUrl = 'https://dev-api.clo.ai';
  static const String prodBaseUrl = 'https://api.clo.ai';

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
  static const Duration sendTimeout = Duration(seconds: 15);

  static ApiEnvironment environment = ApiEnvironment.local;

  static String get baseUrl {
    switch (environment) {
      case ApiEnvironment.local:
        return localBaseUrl;
      case ApiEnvironment.dev:
        return devBaseUrl;
      case ApiEnvironment.prod:
        return prodBaseUrl;
    }
  }
}
