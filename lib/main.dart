import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'mock_firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MockFirebaseService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Review',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFED8B2E)),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF6F4F7),
        fontFamily: 'Roboto',
      ),
      home: const HomeScreen(),
    );
  }
}
 
