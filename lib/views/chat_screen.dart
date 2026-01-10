import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';
import '../controllers/chat_controller.dart';
import 'login_screen.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatController chatController = Get.put(ChatController());
    final TextEditingController textController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ai Chatbot', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.mark_chat_unread_outlined, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () async {
              await GoogleSignIn().signOut();
              await FirebaseAuth.instance.signOut();
              Get.offAll(() => const LoginScreen());
            },
          )
        ],
      ),
      //Drawer for new message and history
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.blue),
              child: Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    chatController.startNewChat();
                    Get.back();
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("New Chat"),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("History", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              //Stream builder rebuilds itself when new event comes
              //Query snapshot is collections of docs from firebase firestore
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser?.uid)
                    .collection('history')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                  return RefreshIndicator(
                    onRefresh: chatController.refreshData,
                    child: ListView.builder(
                      // Allows pull even if list is short
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var doc = snapshot.data!.docs[index];
                        var data = doc.data() as Map<String, dynamic>;

                        return ListTile(
                          leading: const Icon(Icons.chat_bubble_outline, color: Colors.blue),
                          title: Text(data['last_msg'] ?? "Chat", maxLines: 1, overflow: TextOverflow.ellipsis),
                          onTap: () => chatController.loadChat(doc.id, data['full_chat']),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => chatController.deleteChat(doc.id),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // chat body
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: chatController.refreshData,
              child: Obx(() => ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(15),
                itemCount: chatController.messages.length,
                itemBuilder: (context, index) {
                  final msg = chatController.messages[index];
                  final isMe = msg["user"] == "Me";

                  return Align(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isMe ? Colors.blue[600] : Colors.grey[300],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        msg["text"],
                        style: TextStyle(color: isMe ? Colors.white : Colors.black, fontSize: 16),
                      ),
                    ),
                  );
                },
              )),
            ),
          ),

          Obx(() => chatController.isTyping.value
              ? const Padding(padding: EdgeInsets.all(8), child: Text("Ai is thinking..."))
              : const SizedBox()),
           //Input Area
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(24)),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "Type your message...",
                      hintStyle: TextStyle(color: Colors.white70),
                      border: InputBorder.none,
                    ),
                    onSubmitted: (val) {
                      chatController.sendMessage(val);
                      textController.clear();
                    },
                  ),
                ),
                //Button
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: () {
                    chatController.sendMessage(textController.text);
                    textController.clear();
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}