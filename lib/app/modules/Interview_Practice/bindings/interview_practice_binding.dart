import 'package:get/get.dart';

import '../controllers/interview_practice_controller.dart';

class InterviewPracticeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InterviewPracticeController>(
      () => InterviewPracticeController(),
    );
  }
}
