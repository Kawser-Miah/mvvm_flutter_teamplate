import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../model/auth/login_request_model.dart';
import '../../../model/auth/user_model.dart';
import '../providers/auth_providers.dart';

final loginViewModelProvider =
    AsyncNotifierProvider<LoginViewModel, UserModel?>(
  LoginViewModel.new,
);

class LoginViewModel extends AsyncNotifier<UserModel?> {
  @override
  Future<UserModel?> build() async {
    return null;
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(authRepositoryProvider);
      final result = await repository.login(
        LoginRequestModel(email: email, password: password),
      );
      return result.getOrThrow();
    });
  }
}
