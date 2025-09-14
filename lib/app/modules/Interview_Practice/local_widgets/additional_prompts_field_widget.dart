import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../styles/app_colors.dart';
import '../controllers/interview_practice_controller.dart';

class AdditionalPromptsFieldWidget extends GetView<InterviewPracticeController> {
  const AdditionalPromptsFieldWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outline),
      ),
      child: TextField(
        controller: controller.additionalPromptsController,
        maxLines: 4,
        decoration: const InputDecoration(
          hintText: 'Add any specific requirements or context for your interview practice...',
          hintStyle: TextStyle(
            fontSize: 14,
            fontFamily: 'Montserrat',
            color: AppColors.textSecondary,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
        ),
        style: const TextStyle(
          fontSize: 14,
          fontFamily: 'Montserrat',
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
