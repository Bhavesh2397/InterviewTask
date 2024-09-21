import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:interviewtask/screen/splash_screen.dart';
import 'utils/app_color.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workout Tracker App',
      color: AppColors.clrDeepPurple,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.clrDeepPurple),
        useMaterial3: true,
      ),
      home:  SplashScreen(),
    );
  }
}

