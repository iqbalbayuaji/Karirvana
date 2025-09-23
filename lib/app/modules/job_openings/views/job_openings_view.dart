import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/job_openings_controller.dart';

class JobOpeningsView extends GetView<JobOpeningsController> {
  const JobOpeningsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JobOpeningsView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'JobOpeningsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
