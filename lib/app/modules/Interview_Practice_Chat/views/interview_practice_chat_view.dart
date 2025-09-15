import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/interview_practice_chat_controller.dart';

class InterviewPracticeChatView
    extends GetView<InterviewPracticeChatController> {
  const InterviewPracticeChatView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('InterviewPracticeChatView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'InterviewPracticeChatView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
