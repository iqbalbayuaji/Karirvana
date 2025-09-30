import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/course_manage_controller.dart';

class CourseManageView extends GetView<CourseManageController> {
  const CourseManageView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CourseManageView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'CourseManageView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
