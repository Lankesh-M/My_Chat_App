import 'package:chat_app/services/auth/auth_gate.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/themes/dark_mode.dart';
import 'package:chat_app/themes/light_mode.dart';
import 'package:chat_app/themes/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
  // runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ChatApp',
      // theme: darkMode,
      theme: Provider.of<ThemeProvider>(context).themeData,
      // theme: lightMode,
      home: const AuthGate(),
    );
  }
}
