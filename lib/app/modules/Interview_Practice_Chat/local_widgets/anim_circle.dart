import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/interview_practice_chat_controller.dart';
import '../../../styles/app_colors.dart';

class AnimatedCircle extends StatelessWidget {
  const AnimatedCircle({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<InterviewPracticeChatController>();
    
    return Obx(() => GestureDetector(
      onTap: () {
        if (controller.isListening.value) {
          controller.stopListening();
        } else if (!controller.isAISpeaking.value && !controller.isLoading.value) {
          controller.startListening();
        }
      },
      child: SizedBox(
        width: 250,
        height: 250,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Ripple effects for listening state
            controller.isListening.value
                ? AnimatedBuilder(
                    animation: controller.rippleAnimation,
                    builder: (context, child) {
                      return Stack(
                        alignment: Alignment.center,
                        children: List.generate(3, (index) {
                          final delay = index * 0.3;
                          final animationValue = (controller.rippleAnimation.value - delay).clamp(0.0, 1.0);
                          return Container(
                            width: 250 * (0.5 + animationValue * 0.5),
                            height: 250 * (0.5 + animationValue * 0.5),
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
                : const SizedBox(),

            // Main pulsing circle with scale animation
            AnimatedBuilder(
              animation: Listenable.merge([controller.pulseAnimation, controller.scaleAnimation]),
              builder: (context, child) {
                return Transform.scale(
                  scale: controller.pulseAnimation.value * controller.scaleAnimation.value,
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

            // Inner circle - changes color based on state with scale animation
            AnimatedBuilder(
              animation: controller.scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: controller.scaleAnimation.value,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: controller.isListening.value
                          ? AppColors.primary.withOpacity(0.8)
                          : controller.isAISpeaking.value 
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
                      controller.isListening.value
                          ? Icons.mic
                          : controller.isAISpeaking.value 
                              ? Icons.psychology 
                              : Icons.psychology,
                      size: 48,
                      color: controller.isListening.value || controller.isAISpeaking.value
                          ? Colors.white
                          : AppColors.primary,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    ));
  }
}