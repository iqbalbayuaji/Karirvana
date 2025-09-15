import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../styles/app_colors.dart';
import '../controllers/interview_practice_chat_controller.dart';

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
                    const SizedBox(height: 30),

                    // Animated circle area
                    _buildAnimatedCircle(),
                    
                    const SizedBox(height: 50),
                    
                    // AI Response area
                    _buildAIResponseArea(),
                    
                    const SizedBox(height: 40),
                    
                    // Control buttons
                    _buildControlButtons(),
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
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: const EdgeInsets.all(8),
              child: const Icon(
                Icons.arrow_back,
                color: AppColors.textOnPrimary,
                size: 24,
              ),
            ),
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

  Widget _buildAnimatedCircle() {
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

  Widget _buildAIResponseArea() {
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
                          child: _buildResponseContent(controller.previousAIResponse.value),
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
                        child: _buildResponseContent(controller.currentAIResponse.value),
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

  Widget _buildResponseContent(String response) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                Icons.psychology,
                color: AppColors.textOnPrimary,
                size: 25,
              ),
              const SizedBox(width: 6),
              const Text(
                'HR Assistant',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 15,
                  color: AppColors.textOnPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const SizedBox(width: 31), // Align with icon spacing
              Flexible(
                child: Text(
                  response,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                    color: AppColors.textOnPrimary,
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControlButtons() {
    return Column(
      children: [
        // Speak Button
        _buildSpeakButton(),
        
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

  Widget _buildSpeakButton() {
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
