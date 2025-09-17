import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../styles/app_colors.dart';
import '../controllers/interview_practice_chat_controller.dart';
import '../local_widgets/anim_circle.dart';
import '../local_widgets/ai_respons.dart';

class InterviewPracticeChatView extends GetView<InterviewPracticeChatController> {
  const InterviewPracticeChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.heroGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header with back button
              _buildHeader(),
              
              // Main content area
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 80),

                    // Animated circle area
                    const AnimatedCircle(),
                    SizedBox(
                      height: 17,
                    ),
                    
                    // Status indicator - single position for both states
                    Obx(() {
                      // Priority: AI Speaking > Listening > Default
                      if (controller.isAISpeaking.value && !controller.isListening.value) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.volume_up,
                                size: 16,
                                color: AppColors.textOnPrimary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'AI Berbicara...',
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textOnPrimary,
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (controller.isListening.value) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.mic,
                                size: 16,
                                color: AppColors.textOnPrimary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Mendengarkan...',
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textOnPrimary,
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return const SizedBox(height: 33);
                      }
                    }),
                    SizedBox(height: 20),
                    
                    // AI Response area
                    const AIResponseArea(),
                    
                    const SizedBox(height: 40),
                    
                    // Control buttons
                    // const ControlButtons(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 30,
          ),

          const Text(
            'Interview Practice',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textOnPrimary,
            ),
          ),
          // End Interview Button - compact header style
          GestureDetector(
            onTap: () => controller.endInterview(),
            child: Container(
              width: 37,
              height: 37,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red.withOpacity(0.1),
                border: Border.all(
                  color: Colors.red.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.stop,
                color: Colors.red.shade400,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }





}
