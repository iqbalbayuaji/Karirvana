import 'package:get/get.dart';

import '../controllers/course_user_controller.dart';

class CourseUserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CourseUserController>(
      () => CourseUserController(),
    );
  }
}
