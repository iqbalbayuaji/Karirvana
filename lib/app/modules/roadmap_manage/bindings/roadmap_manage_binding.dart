import 'package:get/get.dart';

import '../controllers/roadmap_manage_controller.dart';

class RoadmapManageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RoadmapManageController>(
      () => RoadmapManageController(),
    );
  }
}
