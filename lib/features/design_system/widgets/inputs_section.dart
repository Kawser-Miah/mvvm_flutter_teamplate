import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_texts.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/country_code_selector.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../viewmodels/design_system_viewmodel.dart';
import 'component_section_card.dart';

class InputsSection extends ConsumerStatefulWidget {
  const InputsSection({super.key});

  @override
  ConsumerState<InputsSection> createState() => _InputsSectionState();
}

class _InputsSectionState extends ConsumerState<InputsSection> {
  late final TextEditingController _standardController;
  late final TextEditingController _passwordController;
  late final TextEditingController _errorController;
  late final TextEditingController _appFieldController;
  String _selectedDialCode = '+1';

  @override
  void initState() {
    super.initState();
    _standardController = TextEditingController(text: 'John Doe');
    _passwordController = TextEditingController(text: 'SecretPassword123');
    _errorController = TextEditingController(text: 'invalid-email');
    _appFieldController = TextEditingController();
  }

  @override
  void dispose() {
    _standardController.dispose();
    _passwordController.dispose();
    _errorController.dispose();
    _appFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.read(designSystemViewModelProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ComponentSectionCard(
          title: 'CustomTextField Variations',
          description: 'Dark-themed rounded text fields with labels, password toggle, and error states.',
          child: Column(
            children: [
              CustomTextField(
                title: 'Full Name',
                isRequired: true,
                hintText: 'Enter your full name',
                controller: _standardController,
                onChanged: (val) => viewModel.logAction('Name changed: $val'),
              ),
              SizedBox(height: 16.h),
              CustomTextField(
                title: 'Password',
                isRequired: true,
                hintText: 'Enter secure password',
                isPassword: true,
                controller: _passwordController,
                onChanged: (val) => viewModel.logAction('Password edited'),
              ),
              SizedBox(height: 16.h),
              CustomTextField(
                title: 'Email Address',
                hintText: 'user@example.com',
                controller: _errorController,
                errorText: 'Please enter a valid email address',
                onChanged: (val) => viewModel.logAction('Email edited: $val'),
              ),
              SizedBox(height: 16.h),
              const CustomTextField(
                title: 'Disabled Field',
                hintText: 'You cannot edit this field',
                isDisabled: true,
              ),
            ],
          ),
        ),
        ComponentSectionCard(
          title: 'Country Code Selector & AppTextField',
          description: 'Specialized input selectors and core form text fields.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Country Code Selector:',
                style: AppTexts.txsr.copyWith(color: AppColors.textSecondary),
              ),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: AppColors.containerBackground,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    CountryCodeSelector(
                      dialCode: _selectedDialCode,
                      onTap: () {
                        setState(() {
                          _selectedDialCode = _selectedDialCode == '+1'
                              ? '+44'
                              : (_selectedDialCode == '+44' ? '+880' : '+1');
                        });
                        viewModel.logAction('Dial code toggled to $_selectedDialCode');
                      },
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        '(Tap selector to switch codes)',
                        style: AppTexts.txsr.copyWith(color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'AppTextField (Core Component):',
                style: AppTexts.txsr.copyWith(color: AppColors.textSecondary),
              ),
              SizedBox(height: 8.h),
              AppTextField(
                label: 'Security Notes',
                controller: _appFieldController,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
