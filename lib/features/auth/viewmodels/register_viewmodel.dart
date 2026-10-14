import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../model/auth/auth_response_model.dart';
import '../providers/auth_providers.dart';

final registerViewModelProvider =
    AsyncNotifierProvider<RegisterViewModel, AuthResponseModel?>(
  RegisterViewModel.new,
);

class RegisterViewModel extends AsyncNotifier<AuthResponseModel?> {
  @override
  Future<AuthResponseModel?> build() async {
    return null;
  }

  Future<void> register(String name, String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(authRepositoryProvider);
      return repository.register({
        'name': name,
        'email': email,
        'password': password,
      });
    });
  }
}
