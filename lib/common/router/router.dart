import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/models/user_model.dart';
import '../../features/auth/views/delete_account_screen.dart';
import '../../features/auth/views/login_screen.dart';
import '../../features/auth/views/register_screen.dart';
import '../../features/chat/views/chat_screen.dart';
import '../../features/auth/views/edit_profile_screen.dart';
import '../../features/home/views/home_screen.dart';
import '../../features/image_processing/views/image_analysis_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final router = RouterNotifier(ref);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: router,
    redirect: router._redirectLogic,
    routes: router._routes,
  );
});

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      notifyListeners();
    });
  }

  String? _redirectLogic(BuildContext context, GoRouterState state) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      if (state.matchedLocation == '/register') {
        return null;
      }
      return '/login';
    }

    if (state.matchedLocation == '/login' ||
        state.matchedLocation == '/register') {
      return '/';
    }

    return null;
  }

  List<RouteBase> get _routes => [
        GoRoute(
          path: '/',
          builder: (context, state) =>
              HomeScreen(user: FirebaseAuth.instance.currentUser!),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen(),
        ),
      ];
}

final router = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final user = FirebaseAuth.instance.currentUser;
    final isLoggingIn = state.matchedLocation == '/login';
    final isRegistering = state.matchedLocation == '/register';

    if (user == null) {
      return isLoggingIn || isRegistering ? null : '/login';
    }

    if (isLoggingIn || isRegistering) {
      return '/';
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          return const LoginScreen();
        }
        return HomeScreen(user: user);
      },
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/chat',
      builder: (context, state) => const ChatScreen(),
    ),
    GoRoute(
      path: '/image-analysis',
      builder: (context, state) => const ImageAnalysisScreen(),
    ),
    GoRoute(
      path: '/edit-profile',
      builder: (context, state) {
        final user = state.extra as UserModel;
        return EditProfileScreen(user: user);
      },
    ),
    GoRoute(
      path: '/delete-account',
      builder: (context, state) {
        final user = state.extra as UserModel;
        return DeleteAccountScreen(user: user);
      },
    ),
  ],
);
