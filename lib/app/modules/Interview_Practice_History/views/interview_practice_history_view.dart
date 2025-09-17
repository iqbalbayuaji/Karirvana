import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/interview_practice_history_controller.dart';

class InterviewPracticeHistoryView
    extends GetView<InterviewPracticeHistoryController> {
  const InterviewPracticeHistoryView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('InterviewPracticeHistoryView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'InterviewPracticeHistoryView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
