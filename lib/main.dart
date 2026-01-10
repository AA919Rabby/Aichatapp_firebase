import 'package:ai_chatbot/views/view_schreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBe7uLiMb9U10YyzvG2vMdM39QwZAsqSZo",
      appId: "1:956533700482:android:2ddb549a3c470fbe4e419b",
      messagingSenderId: "956533700482",
      projectId: "ai-bot-55a05",
      storageBucket: "ai-bot-55a05.firebasestorage.app",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: ViewScreen(),
    );
  }
}