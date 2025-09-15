import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/interview_practice_chat_controller.dart';
import '../../../styles/app_colors.dart';
import 'speak_button.dart';

class ControlButtons extends StatelessWidget {
  const ControlButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<InterviewPracticeChatController>();
    
    return Column(
      children: [
        // Speak Button
        const SpeakButton(),
        
        const SizedBox(height: 10),
        
        // Status Indicator
        Obx(() => Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            controller.isListening.value 
                ? 'Mendengarkan...' 
                : controller.isAISpeaking.value 
                    ? 'AI Berbicara...'
                    : 'Tekan untuk berbicara',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: controller.isListening.value
                  ? Colors.red.shade400
                  : AppColors.textOnPrimary,
            ),
          ),
        )),
      ],
    );
  }
}