import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/roadmap_edit_controller.dart';

class RoadmapEditView extends GetView<RoadmapEditController> {
  const RoadmapEditView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RoadmapEditView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'RoadmapEditView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
