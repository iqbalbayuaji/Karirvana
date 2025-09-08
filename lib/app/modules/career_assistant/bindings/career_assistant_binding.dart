import 'package:get/get.dart';

import '../controllers/career_assistant_controller.dart';

class CareerAssistantBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CareerAssistantController>(
      () => CareerAssistantController(),
    );
  }
}
