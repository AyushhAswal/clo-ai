import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/storage/token_storage.dart';
import '../../domain/models/user_auth_model.dart';

class AuthRepository {
  final ApiClient _apiClient;
  final TokenStorage _tokenStorage;

  AuthRepository({ApiClient? apiClient, TokenStorage? tokenStorage})
    : _apiClient = apiClient ?? ApiClient(),
      _tokenStorage = tokenStorage ?? TokenStorage();

  ApiClient get apiClient => _apiClient;
  TokenStorage get tokenStorage => _tokenStorage;

  Future<UserAuthModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.auth.register,
      data: {'name': name, 'email': email, 'password': password},
    );

    final authResponse = AuthResponseModel.fromJson(
      response.data as Map<String, dynamic>,
    );

    await _tokenStorage.saveToken(authResponse.accessToken);
    _apiClient.setAuthToken(authResponse.accessToken);

    return authResponse.user;
  }

  Future<UserAuthModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.auth.login,
      data: {'email': email, 'password': password},
    );

    final authResponse = AuthResponseModel.fromJson(
      response.data as Map<String, dynamic>,
    );

    await _tokenStorage.saveToken(authResponse.accessToken);
    _apiClient.setAuthToken(authResponse.accessToken);

    return authResponse.user;
  }

  Future<UserAuthModel> getMe() async {
    final response = await _apiClient.get(ApiEndpoints.auth.me);
    return UserAuthModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<UserAuthModel?> restoreSession() async {
    final token = await _tokenStorage.getToken();
    if (token == null || token.isEmpty) {
      return null;
    }

    // Set token into AuthInterceptor FIRST
    _apiClient.setAuthToken(token);

    try {
      return await getMe();
    } on ApiException catch (e) {
      if (e.statusCode == 401) {
        await logout();
      } else {
        await logout();
      }
      return null;
    } catch (_) {
      await logout();
      return null;
    }
  }

  Future<void> logout() async {
    await _tokenStorage.clearToken();
    _apiClient.clearAuthToken();
  }
}
