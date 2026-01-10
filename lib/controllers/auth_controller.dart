import 'package:ai_chatbot/services/auth_service.dart';
import 'package:ai_chatbot/views/chat_screen.dart';
import 'package:ai_chatbot/views/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Listen to user changes (Logged in vs Logged out)
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        Get.offAll(() => const LoginScreen());
      } else {
        Get.offAll(() => const ChatScreen());
      }
    });
  }

  Future<void> login() async {
    isLoading.value = true;
    await _authService.signInWithGoogle();
    isLoading.value = false;
  }

  Future<void> logout() async {
    isLoading.value = true;
    await _authService.signOut();
    isLoading.value = false;
  }
}