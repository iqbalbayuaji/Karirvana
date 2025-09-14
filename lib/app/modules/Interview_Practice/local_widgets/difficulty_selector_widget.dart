import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/interview_practice_controller.dart';
import 'difficulty_chip_widget.dart';

class DifficultySelectorWidget extends GetView<InterviewPracticeController> {
  const DifficultySelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Row(
      children: [
        DifficultyChipWidget(
          label: 'Easy',
          isSelected: controller.selectedDifficulty.value == 'Easy',
          onTap: () => controller.setDifficulty('Easy'),
        ),
        const SizedBox(width: 12),
        DifficultyChipWidget(
          label: 'Medium',
          isSelected: controller.selectedDifficulty.value == 'Medium',
          onTap: () => controller.setDifficulty('Medium'),
        ),
        const SizedBox(width: 12),
        DifficultyChipWidget(
          label: 'Hard',
          isSelected: controller.selectedDifficulty.value == 'Hard',
          onTap: () => controller.setDifficulty('Hard'),
        ),
      ],
    ));
  }
}
