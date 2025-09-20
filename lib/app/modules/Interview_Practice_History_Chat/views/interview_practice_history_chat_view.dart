import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/interview_practice_history_chat_controller.dart';

class InterviewPracticeHistoryChatView
    extends GetView<InterviewPracticeHistoryChatController> {
  const InterviewPracticeHistoryChatView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('InterviewPracticeHistoryChatView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'InterviewPracticeHistoryChatView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
