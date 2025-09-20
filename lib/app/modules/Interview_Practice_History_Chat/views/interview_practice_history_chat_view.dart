import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karirvana/app/styles/app_colors.dart';
import '../controllers/interview_practice_history_chat_controller.dart';

class InterviewPracticeHistoryChatView
    extends GetView<InterviewPracticeHistoryChatController> {
  const InterviewPracticeHistoryChatView({super.key});
  
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.heroGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 45),
          child: Column(
            children: [
              _buildHeader(context),
              const SizedBox(height: 20),
              _buildChatView(context, screenHeight),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: const Icon(
              Icons.arrow_back,
              color: AppColors.textOnPrimary,
              size: 24,
            ),
          ),
        ),
        Expanded(
          child: Obx(() => Text(
            controller.sessionTitle.value.isNotEmpty 
              ? controller.sessionTitle.value 
              : "Interview History",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: AppColors.textOnPrimary,
            ),
          )),
        ),
        const SizedBox(width: 65),
      ],
    );
  }

  Widget _buildChatView(BuildContext context, double screenHeight) {
    return Expanded(
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.textOnPrimary),
            ),
          );
        }

        return ListView.builder(
          controller: controller.scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          itemCount: controller.messages.length,
          itemBuilder: (context, index) {
            final message = controller.messages[index];
            return Padding(
              padding: EdgeInsets.only(bottom: screenHeight * 0.03),
              child: message.isUser
                  ? _buildUserMessage(message.content, context)
                  : _buildBotMessage(message.content, context),
            );
          },
        );
      }),
    );
  }

  Widget _buildBotMessage(String message, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: screenWidth * 0.04),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.psychology,
                    color: AppColors.textOnPrimary,
                    size: 25,
                  ),
                  SizedBox(width: 6),
                  Text(
                    "HR Interviewer",
                    style: TextStyle(
                      fontFamily: "Montserrat",
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
                  SizedBox(width: screenWidth * 0.04),
                  Flexible(
                    child: Text(
                      message,
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
        ),
      ],
    );
  }

  Widget _buildUserMessage(String message, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: screenWidth * 0.75,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(4),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              message,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 14,
                color: AppColors.textOnPrimary,
                fontWeight: FontWeight.w400,
                height: 1.4,
              ),
            ),
          ),
        ),
        SizedBox(width: screenWidth * 0.04),
      ],
    );
  }
}
