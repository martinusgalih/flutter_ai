import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../common/widgets/custom_button.dart';
import '../../../common/widgets/custom_ghost_button.dart';
import '../../../common/widgets/custom_text_field.dart';
import '../../../common/widgets/custom_bottom_sheet.dart';
import '../providers/auth_state.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        ref
            .read(authStateProvider.notifier)
            .register(
              _emailController.text.trim(),
              _passwordController.text,
              _nameController.text.trim(),
            )
            .then((_) {
          if (mounted) {
            context.go('/');
          }
        }).catchError((error) {
          CustomBottomSheet.show(
            context: context,
            title: 'Registration Error',
            message: _getReadableErrorMessage(error.toString()),
            primaryButtonText: 'OK',
            isError: true,
          );
        });
      } catch (e) {
        CustomBottomSheet.show(
          context: context,
          title: 'Registration Error',
          message: _getReadableErrorMessage(e.toString()),
          primaryButtonText: 'OK',
          isError: true,
        );
      }
    }
  }

  String _getReadableErrorMessage(String error) {
    if (error.contains('email-already-in-use')) {
      return 'This email is already registered. Please use a different email or sign in.';
    } else if (error.contains('weak-password')) {
      return 'The password provided is too weak.';
    } else if (error.contains('invalid-email')) {
      return 'The email address is invalid.';
    }
    return error;
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 32),
                  CustomTextField(
                    controller: _nameController,
                    label: 'Name',
                    placeholder: 'Enter your name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
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
                  const SizedBox(height: 24),
                  CustomTextField(
                    controller: _confirmPasswordController,
                    label: 'Confirm Password',
                    placeholder: 'Confirm your password',
                    isSecure: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  CustomButton(
                    text: 'Create Account',
                    onPressed: _handleRegister,
                    isLoading: authState.isLoading,
                  ),
                  const SizedBox(height: 16),
                  CustomGhostButton(
                    text: "Already have an account? Sign in",
                    highlightedText: "Sign in",
                    onPressed: () => context.pop(),
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
