import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../../styles/app_colors.dart';
import '../controllers/interview_practice_controller.dart';
import '../local_widgets/section_title_widget.dart';
import '../local_widgets/difficulty_selector_widget.dart';
import '../local_widgets/model_style_selector_widget.dart';
import '../local_widgets/additional_prompts_field_widget.dart';

class InterviewPracticeView extends GetView<InterviewPracticeController> {
  const InterviewPracticeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.outline),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: AppColors.textPrimary,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Interview Practice Setup',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Customisasi untuk pengalaman lebih',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Montserrat',
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // HRD Difficulty Level
                    const SectionTitleWidget(title: 'Tingkat kesulitan'),
                    const SizedBox(height: 12),
                    const DifficultySelectorWidget(),
                    
                    const SizedBox(height: 30),
                    
                    // HRD Model/Style
                    const SectionTitleWidget(title: 'Model'),
                    const SizedBox(height: 12),
                    const ModelStyleSelectorWidget(),
                    
                    const SizedBox(height: 30),
                    
                    // Additional Prompts
                    const SectionTitleWidget(title: 'Prompt Tambahan'),
                    const SizedBox(height: 12),
                    const AdditionalPromptsFieldWidget(),
                    
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            
            // Bottom Button
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Mulai Interview Practice',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
