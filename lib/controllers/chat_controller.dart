import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/ai_service.dart';

class ChatController extends GetxController {
  final AIService _aiService = AIService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var messages = <Map<String, dynamic>>[].obs;
  var isTyping = false.obs;
  var currentChatId = "".obs;

  @override
  void onInit() {
    super.onInit();
    startNewChat();
  }

  //  RefreshIndicator
  Future<void> refreshData() async {
    await Future.delayed(const Duration(seconds: 1));
    update();
  }

  void startNewChat() {
    messages.clear();
    currentChatId.value = DateTime.now().millisecondsSinceEpoch.toString();
  }

  void loadChat(String id, List<dynamic> oldMessages) {
    currentChatId.value = id;
    messages.value = List<Map<String, dynamic>>.from(oldMessages);
    Get.back();
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Add Message
    messages.add({"user": "Me", "text": text});
    isTyping.value = true;

    try {
      // AI Reply directly
      String reply = await _aiService.sendMessage(text);

      // Add AI Message
      messages.add({"user": "AI", "text": reply});

      // Save to Database
      _saveToFirestore();

    } catch (e) {
      messages.add({"user": "AI", "text": "Error: $e"});
    } finally {
      isTyping.value = false;
    }
  }

  void _saveToFirestore() async {
    String? uid = _auth.currentUser?.uid;
    if (uid == null) return;

    await _firestore.collection('users').doc(uid).collection('history').doc(currentChatId.value).set({
      'last_msg': messages.last['text'],
      'timestamp': FieldValue.serverTimestamp(),
      'full_chat': messages.toList(),
    });
  }

  void deleteChat(String id) async {
    String? uid = _auth.currentUser?.uid;
    if (uid != null) {
      await _firestore.collection('users').doc(uid).collection('history').doc(id).delete();

      if (currentChatId.value == id) {
        startNewChat();
      }
    }
  }
}