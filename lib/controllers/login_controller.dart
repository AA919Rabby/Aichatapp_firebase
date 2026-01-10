import 'package:ai_chatbot/views/chat_screen.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;

  Future<void> handleGoogleSignIn() async {
    isLoading.value = true;
    try {
      // Configuration for Google Sign In
      final GoogleSignIn googleSignIn = GoogleSignIn(
        serverClientId: "956533700482-7ouqgh6v1n7lamb8dr33ndcklfudss43.apps.googleusercontent.com",
      );

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await FirebaseAuth.instance.signInWithCredential(credential);
        Get.offAll(() => const ChatScreen());
      }
    } catch (e) {
      Get.snackbar("Error", "Login failed: $e");
    } finally {
      isLoading.value = false;
    }
  }
}