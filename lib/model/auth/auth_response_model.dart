import 'user_model.dart';

class AuthResponseModel {
  final String token;
  final String? refreshToken;
  final UserModel user;

  const AuthResponseModel({
    required this.token,
    this.refreshToken,
    required this.user,
  });

  /// Missing fields parse to empty values; `AuthRepositoryImpl` rejects a
  /// response whose [token] is empty.
  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      token: json['token'] as String? ?? '',
      refreshToken: json['refresh_token'] as String?,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>? ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      if (refreshToken != null) 'refresh_token': refreshToken,
      'user': user.toJson(),
    };
  }
}
