import 'package:flutter_riverpod/flutter_riverpod.dart';

class DesignSystemState {
  final int selectedCategory;
  final bool isButtonLoading;
  final bool isButtonDisabled;
  final bool checkboxValue;
  final int starRating;
  final String selectedDropdown;
  final String lastAction;

  const DesignSystemState({
    this.selectedCategory = 0,
    this.isButtonLoading = false,
    this.isButtonDisabled = false,
    this.checkboxValue = true,
    this.starRating = 4,
    this.selectedDropdown = 'Standard Plan',
    this.lastAction = 'Ready to test components',
  });

  DesignSystemState copyWith({
    int? selectedCategory,
    bool? isButtonLoading,
    bool? isButtonDisabled,
    bool? checkboxValue,
    int? starRating,
    String? selectedDropdown,
    String? lastAction,
  }) {
    return DesignSystemState(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isButtonLoading: isButtonLoading ?? this.isButtonLoading,
      isButtonDisabled: isButtonDisabled ?? this.isButtonDisabled,
      checkboxValue: checkboxValue ?? this.checkboxValue,
      starRating: starRating ?? this.starRating,
      selectedDropdown: selectedDropdown ?? this.selectedDropdown,
      lastAction: lastAction ?? this.lastAction,
    );
  }
}

class DesignSystemViewModel extends Notifier<DesignSystemState> {
  @override
  DesignSystemState build() {
    return const DesignSystemState();
  }

  void selectCategory(int index) {
    state = state.copyWith(selectedCategory: index);
  }

  void toggleButtonLoading() {
    state = state.copyWith(isButtonLoading: !state.isButtonLoading);
  }

  void toggleButtonDisabled() {
    state = state.copyWith(isButtonDisabled: !state.isButtonDisabled);
  }

  void setCheckboxValue(bool value) {
    state = state.copyWith(
      checkboxValue: value,
      lastAction: 'Checkbox toggled: $value',
    );
  }

  void setStarRating(int rating) {
    state = state.copyWith(
      starRating: rating,
      lastAction: 'Rating changed: $rating stars',
    );
  }

  void setSelectedDropdown(String value) {
    state = state.copyWith(
      selectedDropdown: value,
      lastAction: 'Dropdown selected: $value',
    );
  }

  void logAction(String message) {
    state = state.copyWith(lastAction: message);
  }
}

final designSystemViewModelProvider =
    NotifierProvider<DesignSystemViewModel, DesignSystemState>(
  DesignSystemViewModel.new,
);
