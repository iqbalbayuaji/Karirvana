import 'package:get/get.dart';

import '../controllers/course_store_controller.dart';

class CourseStoreBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CourseStoreController>(
      () => CourseStoreController(),
    );
  }
}
