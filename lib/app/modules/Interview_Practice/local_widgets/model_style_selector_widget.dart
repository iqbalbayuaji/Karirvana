import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/interview_practice_controller.dart';
import 'style_chip_widget.dart';

class ModelStyleSelectorWidget extends GetView<InterviewPracticeController> {
  const ModelStyleSelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
      children: [
        Row(
          children: [
            StyleChipWidget(
              label: 'Friendly',
              isSelected: controller.selectedStyle.value == 'Friendly',
              onTap: () => controller.setStyle('Friendly'),
            ),
            const SizedBox(width: 12),
            StyleChipWidget(
              label: 'Strict',
              isSelected: controller.selectedStyle.value == 'Strict',
              onTap: () => controller.setStyle('Strict'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            StyleChipWidget(
              label: 'Technical',
              isSelected: controller.selectedStyle.value == 'Technical',
              onTap: () => controller.setStyle('Technical'),
            ),
            const SizedBox(width: 12),
            StyleChipWidget(
              label: 'Behavioral',
              isSelected: controller.selectedStyle.value == 'Behavioral',
              onTap: () => controller.setStyle('Behavioral'),
            ),
          ],
        ),
      ],
    ));
  }
}
