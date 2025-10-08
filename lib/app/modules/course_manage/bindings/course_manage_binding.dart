import 'package:get/get.dart';

import '../controllers/course_manage_controller.dart';

class CourseManageBinding extends Bindings {
  @override
  void dependencies() {
    // Use permanent controller to persist enrolled courses
    if (!Get.isRegistered<CourseManageController>()) {
      Get.put<CourseManageController>(
        CourseManageController(),
        permanent: true,
      );
    }
  }
}
