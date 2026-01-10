import 'package:ai_chatbot/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
  //controller for read ,write etc
    final LoginController loginController = Get.put(LoginController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Obx(() {
          if (loginController.isLoading.value) {
            return const CircularProgressIndicator();
          }else return Column
            (
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Welcome",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              const SizedBox(height: 80),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                onPressed: () => loginController.handleGoogleSignIn(),
                icon: const Icon(Icons.login),
                label: const Text("Sign in with Google",
                    style: TextStyle(fontSize: 18)),
              ),
            ],
          );
        }),
      ),
    );
  }
}
