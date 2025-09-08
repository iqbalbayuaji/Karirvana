import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/career_assistant_controller.dart';

class CareerAssistantView extends GetView<CareerAssistantController> {
  const CareerAssistantView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CareerAssistantView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'CareerAssistantView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
