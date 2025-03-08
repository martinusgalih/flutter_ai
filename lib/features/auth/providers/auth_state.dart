import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

final authStateProvider =
    StateNotifierProvider<AuthStateNotifier, AsyncValue<User?>>((ref) {
  return AuthStateNotifier();
});

class AuthStateNotifier extends StateNotifier<AsyncValue<User?>> {
  AuthStateNotifier() : super(const AsyncValue.loading()) {
    _init();
  }

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  void _init() {
    _auth.authStateChanges().listen((user) {
      state = AsyncValue.data(user);
    });
  }

  Future<void> signIn(String email, String password) async {
    try {
      state = const AsyncValue.loading();
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        state = AsyncValue.data(userCredential.user);
      } else {
        state = const AsyncValue.error('Sign in failed', StackTrace.empty);
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> register(String email, String password, String? name) async {
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

        state = AsyncValue.data(userCredential.user);
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> deleteAccount(String password) async {
    try {
      state = const AsyncValue.loading();
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: password,
        );
        await user.reauthenticateWithCredential(credential);

        await _firestore.collection('users').doc(user.uid).delete();

        await user.delete();
        state = const AsyncValue.data(null);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'too-many-requests') {
        throw Exception('Please wait a few minutes before trying again');
      } else if (e.code == 'wrong-password') {
        throw Exception('Incorrect password');
      }
      throw Exception(e.message ?? 'Failed to delete account');
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
