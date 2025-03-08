import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../common/widgets/custom_button.dart';
import '../../../common/widgets/custom_text_field.dart';
import '../models/user_model.dart';
import '../providers/user_provider.dart';

import '../../home/providers/image_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final UserModel user;

  const EditProfileScreen({
    super.key,
    required this.user,
  });

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  String? _selectedPhotoUrl;
  bool _isUploadingImage = false;
  bool _isSaving = false;

  Future<void> _handleImagePick() async {
    try {
      setState(() => _isUploadingImage = true);
      final imageUrl = await ref.read(imagePickerProvider.notifier).pickImage();
      print("Image: ${imageUrl ?? ''}");
      if (imageUrl != null) {
        setState(() => _selectedPhotoUrl = imageUrl);
      }
    } finally {
      setState(() => _isUploadingImage = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.user.name ?? '';
    _selectedPhotoUrl = widget.user.photoUrl;
  }

  Future<void> _handleSave() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await ref.read(userProvider.notifier).updateProfile(
              name: _nameController.text.trim(),
              photoUrl: _selectedPhotoUrl,
              currentPassword: _currentPasswordController.text.isNotEmpty
                  ? _currentPasswordController.text
                  : null,
              newPassword: _newPasswordController.text.isNotEmpty
                  ? _newPasswordController.text
                  : null,
            );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully')),
          );
          context.pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _isUploadingImage ? null : _handleImagePick,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Theme.of(context).primaryColor,
                          backgroundImage: _selectedPhotoUrl != null
                              ? NetworkImage(_selectedPhotoUrl!)
                              : null,
                          child: _isUploadingImage
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : _selectedPhotoUrl == null
                                  ? const Icon(Icons.person, size: 50)
                                  : null,
                        ),
                        if (!_isUploadingImage)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
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
                    controller: _currentPasswordController,
                    label: 'Current Password',
                    placeholder: 'Enter current password',
                    isSecure: true,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _newPasswordController,
                    label: 'New Password',
                    placeholder: 'Enter new password',
                    isSecure: true,
                    validator: (value) {
                      if (value != null &&
                          value.isNotEmpty &&
                          value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  CustomButton(
                    text: 'Save Changes',
                    onPressed: _handleSave,
                    isLoading: userState.isLoading,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
