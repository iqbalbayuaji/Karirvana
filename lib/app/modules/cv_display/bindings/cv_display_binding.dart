import 'package:get/get.dart';

import '../controllers/cv_display_controller.dart';

class CvDisplayBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CvDisplayController>(
      () => CvDisplayController(),
    );
  }
}
