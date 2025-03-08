import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../common/widgets/custom_button.dart';
import '../../../common/widgets/custom_text_field.dart';
import '../../../common/widgets/custom_bottom_sheet.dart';
import '../providers/auth_state.dart';
import '../models/user_model.dart';

class DeleteAccountScreen extends ConsumerStatefulWidget {
  final UserModel user;

  const DeleteAccountScreen({
    super.key,
    required this.user,
  });

  @override
  ConsumerState<DeleteAccountScreen> createState() =>
      _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends ConsumerState<DeleteAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  String _getReadableErrorMessage(String error) {
    if (error.contains('wrong-password')) {
      return 'The password you entered is incorrect.';
    } else if (error.contains('requires-recent-login')) {
      return 'For security reasons, please log out and log in again before deleting your account.';
    } else if (error.contains('too-many-requests')) {
      return 'Too many attempts. Please wait a few minutes before trying again.';
    }
    return error;
  }

  Future<void> _deleteAccount() async {
    if (!_formKey.currentState!.validate()) return;

    CustomBottomSheet.show(
      context: context,
      title: 'Delete Account',
      message: 'Are you sure you want to delete your account? This action cannot be undone.',
      primaryButtonText: 'Delete Account',
      secondaryButtonText: 'Cancel',
      isError: true,
      onPrimaryPressed: () async {
        setState(() => _isLoading = true);

        try {
          await ref.read(authStateProvider.notifier).deleteAccount(_passwordController.text);
          if (mounted) {
            context.go('/login'); // Replace Navigator with GoRouter
          }
        } catch (e) {
          if (mounted) {
            CustomBottomSheet.show(
              context: context,
              title: 'Delete Account Error',
              message: _getReadableErrorMessage(e.toString()),
              primaryButtonText: 'OK',
              isError: true,
            );
          }
        } finally {
          if (mounted) {
            setState(() => _isLoading = false);
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete Account'),
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
                    controller: _passwordController,
                    label: 'Confirm Password',
                    placeholder: 'Enter your password',
                    isSecure: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  CustomButton(
                    text: 'Delete My Account',
                    onPressed: _deleteAccount,
                    isLoading: _isLoading,
                    backgroundColor: Colors.red,
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
