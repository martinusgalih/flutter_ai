import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';

final userProvider =
    StateNotifierProvider<UserNotifier, AsyncValue<UserModel?>>((ref) {
  return UserNotifier();
});

class UserNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  UserNotifier() : super(const AsyncValue.loading()) {
    _init();
  }

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  void _init() {
    _auth.authStateChanges().listen((user) async {
      if (user != null) {
        await _fetchUser(user.uid);
      } else {
        state = const AsyncValue.data(null);
      }
    });
  }

  Future<void> _fetchUser(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        state = AsyncValue.data(UserModel.fromFirestore(doc));
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> registerUser(String email, String password, String? name) async {
    try {
      state = const AsyncValue.loading();

      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        final userModel = UserModel(
          id: userCredential.user!.uid,
          email: email,
          name: name,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(userModel.toMap());

        state = AsyncValue.data(userModel);
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> updateProfile({
    String? name,
    String? photoUrl,
    String? currentPassword,
    String? newPassword,
  }) async {
    try {
      state = const AsyncValue.loading();
      final user = _auth.currentUser;
      if (user == null) return;

      if (currentPassword != null && newPassword != null) {
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );
        await user.reauthenticateWithCredential(credential);
        await user.updatePassword(newPassword);
      }

      final updatedUser = (state.value ??
              UserModel(
                id: user.uid,
                email: user.email!,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              ))
          .copyWith(
        name: name,
        photoUrl: photoUrl,
      );

      await _firestore
          .collection('users')
          .doc(user.uid)
          .update(updatedUser.toMap());

      state = AsyncValue.data(updatedUser);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }
}
