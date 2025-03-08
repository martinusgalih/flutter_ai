import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/providers/auth_state.dart';
import '../../../auth/providers/user_provider.dart';

class ProfileTab extends ConsumerStatefulWidget {
  final User user;

  const ProfileTab({
    super.key,
    required this.user,
  });

  @override
  ConsumerState<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends ConsumerState<ProfileTab> {
  bool _isSigningOut = false;

  Future<void> _handleSignOut() async {
    setState(() => _isSigningOut = true);
    try {
      await ref.read(authStateProvider.notifier).signOut();
      if (mounted) {
        context.go('/login');
      }
    } finally {
      if (mounted) {
        setState(() => _isSigningOut = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);

    return userState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
      data: (currentUser) => Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Theme.of(context).primaryColor,
              backgroundImage: currentUser?.photoUrl != null
                  ? NetworkImage(currentUser?.photoUrl ?? '')
                  : null,
              child: currentUser?.photoUrl == null
                  ? const Icon(Icons.person, size: 50)
                  : null,
            ),

            const SizedBox(height: 16),
            if (currentUser?.name != null) ...[
              Text(
                currentUser!.name!,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
            ],
            Text(
              currentUser?.email ?? 'No email',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Profile'),
              onTap: () {
                if (currentUser != null) {
                  context.push('/edit-profile', extra: currentUser);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              title: const Text('Delete Account',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                if (currentUser != null) {
                  context.push('/delete-account', extra: currentUser);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: _isSigningOut ? null : _handleSignOut,
              trailing: _isSigningOut 
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : null,
            ),

          ],
        ),
      ),
    );
  }
}