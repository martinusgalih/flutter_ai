import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ai/common/widgets/custom_ghost_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../common/widgets/custom_bottom_sheet.dart';
import '../../../common/widgets/custom_text_field.dart';
import '../providers/auth_state.dart';
import '../../../common/widgets/custom_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        ref
            .read(authStateProvider.notifier)
            .signIn(
              _emailController.text.trim(),
              _passwordController.text,
            )
            .then((_) {
          if (FirebaseAuth.instance.currentUser != null) {
            if (mounted) {
              context.go('/');
            }
          }
        }).catchError((error) {
          CustomBottomSheet.show(
            context: context,
            title: 'Authentication Error',
            message: _getReadableErrorMessage(error.toString()),
            primaryButtonText: 'OK',
            isError: true,
          );
        });
      } catch (e) {
        CustomBottomSheet.show(
          context: context,
          title: 'Authentication Error',
          message: _getReadableErrorMessage(e.toString()),
          primaryButtonText: 'OK',
          isError: true,
        );
      }
    }
  }

  String _getReadableErrorMessage(String error) {
    if (error.contains('No AppCheckProvider installed')) {
      return 'App verification failed. Please try again later.';
    } else if (error.contains('auth credential is incorrect')) {
      return 'Invalid email or password. Please check your credentials and try again.';
    }
    return error;
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    if (authState.hasError) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        CustomBottomSheet.show(
          context: context,
          title: 'Authentication Error',
          message: _getReadableErrorMessage(authState.error.toString()),
          primaryButtonText: 'OK',
          isError: true,
        );
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 32),
                  CustomTextField(
                    controller: _emailController,
                    label: 'Email',
                    placeholder: 'Enter your email address',
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      final emailRegExp =
                          RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (!emailRegExp.hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  CustomTextField(
                    controller: _passwordController,
                    label: 'Password',
                    placeholder: 'Enter your password',
                    isSecure: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  CustomButton(
                    text: 'Sign In',
                    onPressed: _handleLogin,
                    isLoading: authState.isLoading,
                  ),
                  const SizedBox(height: 16),
                  CustomGhostButton(
                    text: "Don't have an account? Create one",
                    highlightedText: "Create one",
                    onPressed: () {
                      context.push('/register');
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
