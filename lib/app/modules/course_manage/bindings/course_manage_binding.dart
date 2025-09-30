import 'package:get/get.dart';

import '../controllers/course_manage_controller.dart';

class CourseManageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CourseManageController>(
      () => CourseManageController(),
    );
  }
}
