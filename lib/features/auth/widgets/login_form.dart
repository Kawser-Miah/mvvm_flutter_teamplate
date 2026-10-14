import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/pages.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../viewmodels/login_viewmodel.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // TEMPORARY LOGIN BYPASS: skips validation and the API call and goes
  // straight to home. No token is stored, so the next cold start opens on
  // login again. Restore the commented block to re-enable real sign-in.
  void _onLogin() {
    context.go(PAGES.home.screenPath);

    // if (_formKey.currentState?.validate() ?? false) {
    //   ref.read(loginViewModelProvider.notifier).login(
    //         _emailController.text.trim(),
    //         _passwordController.text,
    //       );
    // }
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginViewModelProvider);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          AppTextField(
            label: 'Email',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: Validators.email,
          ),
          SizedBox(height: 16.h),
          AppTextField(
            label: 'Password',
            controller: _passwordController,
            obscureText: true,
            validator: Validators.password,
          ),
          SizedBox(height: 24.h),
          AppButton(
            text: 'Sign In',
            isLoading: loginState.isLoading,
            onPressed: _onLogin,
          ),
        ],
      ),
    );
  }
}
