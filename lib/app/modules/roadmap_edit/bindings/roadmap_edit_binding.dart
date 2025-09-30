import 'package:get/get.dart';

import '../controllers/roadmap_edit_controller.dart';

class RoadmapEditBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RoadmapEditController>(
      () => RoadmapEditController(),
    );
  }
}
