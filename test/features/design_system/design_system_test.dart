import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guard_well/core/constants/app_constants.dart';
import 'package:guard_well/core/widgets/custom_checkbox.dart';
import 'package:guard_well/features/design_system/views/design_system_view.dart';
import 'package:guard_well/features/design_system/widgets/buttons_section.dart';
import 'package:guard_well/features/design_system/widgets/selectors_section.dart';

Widget createTestWidget(Widget child) {
  return ProviderScope(
    child: ScreenUtilInit(
      designSize: const Size(
        AppConstants.designWidth,
        AppConstants.designHeight,
      ),
      builder: (context, _) => MaterialApp(
        home: child,
      ),
    ),
  );
}

void main() {
  testWidgets('DesignSystemView renders title and all sections', (tester) async {
    await tester.pumpWidget(createTestWidget(const DesignSystemView()));
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Design System Showcase'), findsOneWidget);
    expect(find.byType(ButtonsSection), findsOneWidget);
    expect(find.text('All Components'), findsOneWidget);
  });

  testWidgets('Tapping category chip filters content', (tester) async {
    await tester.pumpWidget(createTestWidget(const DesignSystemView()));
    await tester.pump(const Duration(milliseconds: 200));

    // Tap 'Buttons' chip
    await tester.tap(find.text('Buttons'));
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.byType(ButtonsSection), findsOneWidget);
    expect(find.byType(SelectorsSection), findsNothing);

    // Tap 'Selectors' chip
    await tester.tap(find.text('Selectors'));
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.byType(SelectorsSection), findsOneWidget);
    expect(find.byType(ButtonsSection), findsNothing);
  });

  testWidgets('Tapping CustomCheckBox toggles value', (tester) async {
    await tester.pumpWidget(createTestWidget(const DesignSystemView()));
    await tester.pump(const Duration(milliseconds: 200));

    await tester.tap(find.text('Selectors'));
    await tester.pump(const Duration(milliseconds: 200));

    final checkboxFinder = find.byType(CustomCheckBox);
    expect(checkboxFinder, findsOneWidget);

    await tester.tap(checkboxFinder);
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.textContaining('Checkbox toggled'), findsOneWidget);
  });
}
