import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/interview_practice_controller.dart';

class InterviewPracticeView extends GetView<InterviewPracticeController> {
  const InterviewPracticeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('InterviewPracticeView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'InterviewPracticeView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
