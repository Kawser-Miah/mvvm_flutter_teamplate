import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../model/auth/auth_response_model.dart';
import '../../../model/auth/login_request_model.dart';
import '../providers/auth_providers.dart';

final loginViewModelProvider =
    AsyncNotifierProvider<LoginViewModel, AuthResponseModel?>(
  LoginViewModel.new,
);

class LoginViewModel extends AsyncNotifier<AuthResponseModel?> {
  @override
  Future<AuthResponseModel?> build() async {
    return null;
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(authRepositoryProvider);
      return repository.login(
        LoginRequestModel(email: email, password: password),
      );
    });
  }
}
