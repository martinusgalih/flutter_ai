import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'common/theme/app_theme.dart';
import 'common/router/router.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyAPkjvwyejAcqPkUQCZYsEZUWuM8bVz-nk',
      appId: '1:862598609639:android:82cbea03fafb63da704042',
      messagingSenderId: '862598609639',
      projectId: 'flutterai-7e7b2',
    )
  );

  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.debug,
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Flutter AI',
      theme: AppTheme.darkTheme,
      routerConfig: router,
    );
  }
}