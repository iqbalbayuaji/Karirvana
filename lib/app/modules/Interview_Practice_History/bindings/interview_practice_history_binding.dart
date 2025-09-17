import 'package:get/get.dart';

import '../controllers/interview_practice_history_controller.dart';

class InterviewPracticeHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InterviewPracticeHistoryController>(
      () => InterviewPracticeHistoryController(),
    );
  }
}
