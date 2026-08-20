class UserAuthModel {
  final String id;
  final String name;
  final String email;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserAuthModel({
    required this.id,
    required this.name,
    required this.email,
    this.createdAt,
    this.updatedAt,
  });

  factory UserAuthModel.fromJson(Map<String, dynamic> json) {
    return UserAuthModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class AuthResponseModel {
  final UserAuthModel user;
  final String accessToken;

  const AuthResponseModel({required this.user, required this.accessToken});

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      user: UserAuthModel.fromJson(json['user'] as Map<String, dynamic>),
      accessToken: json['accessToken'] as String? ?? '',
    );
  }
}
