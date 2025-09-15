import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/interview_practice_chat_controller.dart';
import '../../../styles/app_colors.dart';

class AnimatedCircle extends StatelessWidget {
  const AnimatedCircle({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<InterviewPracticeChatController>();
    
    return SizedBox(
      width: 280,
      height: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Ripple effects for listening state
          Obx(() => controller.isListening.value
              ? AnimatedBuilder(
                  animation: controller.rippleAnimation,
                  builder: (context, child) {
                    return Stack(
                      alignment: Alignment.center,
                      children: List.generate(3, (index) {
                        final delay = index * 0.3;
                        final animationValue = (controller.rippleAnimation.value - delay).clamp(0.0, 1.0);
                        return Container(
                          width: 280 * (0.5 + animationValue * 0.5),
                          height: 280 * (0.5 + animationValue * 0.5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.textOnPrimary.withOpacity(0.3 * (1 - animationValue)),
                              width: 2,
                            ),
                          ),
                        );
                      }),
                    );
                  },
                )
              : const SizedBox()),

          // Main pulsing circle
          AnimatedBuilder(
            animation: controller.pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: controller.pulseAnimation.value,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.textOnPrimary.withOpacity(0.1),
                    border: Border.all(
                      color: AppColors.textOnPrimary.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                ),
              );
            },
          ),

          // Inner circle - indicates AI response only
          Obx(() => Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: controller.isAISpeaking.value 
                  ? Colors.blue.withOpacity(0.8)
                  : AppColors.textOnPrimary,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(
              controller.isAISpeaking.value ? Icons.psychology : Icons.psychology,
              size: 48,
              color: controller.isAISpeaking.value 
                  ? Colors.white
                  : AppColors.primary,
            ),
          )),

          // Speaking indicator
          Obx(() => controller.isAISpeaking.value
              ? Positioned(
                  bottom: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.textOnPrimary.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'AI Berbicara...',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : const SizedBox()),
        ],
      ),
    );
  }
}