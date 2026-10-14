import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_providers.dart';

final logoutViewModelProvider =
    AsyncNotifierProvider<LogoutViewModel, void>(LogoutViewModel.new);

class LogoutViewModel extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> logout() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final result = await ref.read(authRepositoryProvider).logout();
      result.getOrThrow();
    });
  }
}
