import 'package:flutter_riverpod/flutter_riverpod.dart';

final clientBottomNavbarIndexProvider =
    NotifierProvider<ClientBottomNavbarNotifier, int>(ClientBottomNavbarNotifier.new);

class ClientBottomNavbarNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setIndex(int newIndex) {
    state = newIndex;
  }
}

final providerBottomNavbarIndexProvider =
    NotifierProvider<ProviderBottomNavbarNotifier, int>(ProviderBottomNavbarNotifier.new);

class ProviderBottomNavbarNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setIndex(int newIndex) {
    state = newIndex;
  }
}
