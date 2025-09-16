import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/interview_practice_feedback_controller.dart';

class InterviewPracticeFeedbackView
    extends GetView<InterviewPracticeFeedbackController> {
  const InterviewPracticeFeedbackView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('InterviewPracticeFeedbackView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'InterviewPracticeFeedbackView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
