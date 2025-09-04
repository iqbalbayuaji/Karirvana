import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/course_store_controller.dart';

class CourseStoreView extends GetView<CourseStoreController> {
  const CourseStoreView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CourseStoreView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'CourseStoreView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
