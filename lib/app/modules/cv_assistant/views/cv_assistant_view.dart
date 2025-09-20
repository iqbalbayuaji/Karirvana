import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/cv_assistant_controller.dart';

class CvAssistantView extends GetView<CvAssistantController> {
  const CvAssistantView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CvAssistantView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'CvAssistantView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
