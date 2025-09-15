import 'package:get/get.dart';

import '../controllers/interview_practice_chat_controller.dart';

class InterviewPracticeChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InterviewPracticeChatController>(
      () => InterviewPracticeChatController(),
    );
  }
}
