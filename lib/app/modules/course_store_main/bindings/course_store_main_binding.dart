import 'package:get/get.dart';

import '../controllers/course_store_main_controller.dart';

class CourseStoreMainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CourseStoreMainController>(
      () => CourseStoreMainController(),
    );
  }
}
