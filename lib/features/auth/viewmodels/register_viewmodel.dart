import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../model/auth/user_model.dart';
import '../providers/auth_providers.dart';

final registerViewModelProvider =
    AsyncNotifierProvider<RegisterViewModel, UserModel?>(
  RegisterViewModel.new,
);

class RegisterViewModel extends AsyncNotifier<UserModel?> {
  @override
  Future<UserModel?> build() async {
    return null;
  }

  Future<void> register(String name, String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(authRepositoryProvider);
      final result = await repository.register({
        'name': name,
        'email': email,
        'password': password,
      });
      return result.getOrThrow();
    });
  }
}
