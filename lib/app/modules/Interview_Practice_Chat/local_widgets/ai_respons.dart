import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/interview_practice_chat_controller.dart';
import 'respons_content.dart';

class AIResponseArea extends StatelessWidget {
  const AIResponseArea({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<InterviewPracticeChatController>();
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: SizedBox(
        height: 120, // Fixed height for the response area
        child: ClipRect(
          child: Obx(() {
            final currentCount = controller.responseCount.value;
            final previousCount = currentCount - 1;
            
            return Stack(
              children: [
                // Previous response - gets pushed up and fades out
                if (previousCount >= 0)
                  TweenAnimationBuilder<double>(
                    key: ValueKey('previous_$previousCount'),
                    tween: Tween<double>(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeInOut,
                    builder: (context, animationValue, child) {
                      final translateY = animationValue * -120.0; // Move up
                      final opacity = 1.0 - animationValue; // Fade out
                      
                      return Transform.translate(
                        offset: Offset(0, translateY),
                        child: Opacity(
                          opacity: opacity,
                          child: ResponseContent(response: controller.previousAIResponse.value),
                        ),
                      );
                    },
                  ),
                
                // Current response - pushes from bottom and fades in
                TweenAnimationBuilder<double>(
                  key: ValueKey('current_$currentCount'),
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOut,
                  builder: (context, animationValue, child) {
                    final translateY = (1.0 - animationValue) * 120.0; // Move up from bottom
                    final opacity = animationValue; // Fade in
                    
                    return Transform.translate(
                      offset: Offset(0, translateY),
                      child: Opacity(
                        opacity: opacity,
                        child: ResponseContent(response: controller.currentAIResponse.value),
                      ),
                    );
                  },
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}