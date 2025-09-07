import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/course_store_main_controller.dart';

class CourseStoreMainView extends GetView<CourseStoreMainController> {
  const CourseStoreMainView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CourseStoreMainView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'CourseStoreMainView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
