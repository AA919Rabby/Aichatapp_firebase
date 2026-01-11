import 'dart:async';
import 'package:ai_chatbot/controllers/auth_controller.dart';
import 'package:ai_chatbot/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewScreen extends StatefulWidget {
  const ViewScreen({super.key});

  @override
  State<ViewScreen> createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Get.put(AuthController());
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea (
        child: Center (
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column (
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
               crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox.shrink(),
                  Column(
                    children: [
                      Text('Ai Chatbot',
                        style: TextStyle(
                         color: Colors.white,
                          fontSize: 46,
                        ),
                      ),
                    ],
                  ),
                  CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}