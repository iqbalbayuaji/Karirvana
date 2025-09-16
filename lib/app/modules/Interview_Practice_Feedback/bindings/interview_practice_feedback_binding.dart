import 'package:get/get.dart';

import '../controllers/interview_practice_feedback_controller.dart';

class InterviewPracticeFeedbackBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InterviewPracticeFeedbackController>(
      () => InterviewPracticeFeedbackController(),
    );
  }
}
