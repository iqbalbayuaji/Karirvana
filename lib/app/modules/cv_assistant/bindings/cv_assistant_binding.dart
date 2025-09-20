import 'package:get/get.dart';

import '../controllers/cv_assistant_controller.dart';

class CvAssistantBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CvAssistantController>(
      () => CvAssistantController(),
    );
  }
}
