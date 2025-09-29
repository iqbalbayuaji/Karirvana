import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/roadmap_manage_controller.dart';

class RoadmapManageView extends GetView<RoadmapManageController> {
  const RoadmapManageView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RoadmapManageView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'RoadmapManageView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
