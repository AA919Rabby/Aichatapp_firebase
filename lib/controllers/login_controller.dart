import 'package:ai_chatbot/views/chat_screen.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;

  Future<void> handleGoogleSignIn() async {
    isLoading.value = true;
    try {
      //  Google Sign In
      final GoogleSignIn googleSignIn = GoogleSignIn(
        serverClientId: 'Enter server client id',
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