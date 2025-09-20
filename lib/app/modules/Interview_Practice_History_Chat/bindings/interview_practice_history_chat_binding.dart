import 'package:get/get.dart';

import '../controllers/interview_practice_history_chat_controller.dart';

class InterviewPracticeHistoryChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InterviewPracticeHistoryChatController>(
      () => InterviewPracticeHistoryChatController(),
    );
  }
}
