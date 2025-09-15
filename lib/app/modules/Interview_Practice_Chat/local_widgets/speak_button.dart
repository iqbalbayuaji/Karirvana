import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/interview_practice_chat_controller.dart';
import '../../../styles/app_colors.dart';

class SpeakButton extends StatelessWidget {
  const SpeakButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<InterviewPracticeChatController>();
    
    return GestureDetector(
      onTap: () {
        if (controller.isListening.value) {
          controller.stopListening();
        } else {
          controller.startListening();
        }
      },
      child: Obx(() => Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: controller.isListening.value 
              ? Colors.red.withOpacity(0.8)
              : AppColors.textOnPrimary,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Icon(
          controller.isListening.value ? Icons.mic : Icons.mic_none,
          size: 26,
          color: controller.isListening.value 
              ? Colors.white
              : AppColors.primary,
        ),
      )),
    );
  }
}