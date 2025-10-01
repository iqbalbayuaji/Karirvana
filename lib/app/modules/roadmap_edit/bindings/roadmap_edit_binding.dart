import 'package:get/get.dart';

import '../controllers/roadmap_edit_controller.dart';
import '../../roadmap_manage/controllers/roadmap_manage_controller.dart';

class RoadmapEditBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure RoadmapManageController is available
    if (!Get.isRegistered<RoadmapManageController>()) {
      Get.lazyPut<RoadmapManageController>(
        () => RoadmapManageController(),
      );
    }
    
    Get.lazyPut<RoadmapEditController>(
      () => RoadmapEditController(),
    );
  }
}
