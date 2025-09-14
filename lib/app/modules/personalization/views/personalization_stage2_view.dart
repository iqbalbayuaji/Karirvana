import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../styles/app_colors.dart';
import '../controllers/personalization_controller.dart';

class PersonalizationStage2View extends GetView<PersonalizationController> {
  const PersonalizationStage2View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            // Progress indicator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Header with back button
            Padding(
              padding: const EdgeInsets.all(25),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => controller.goToStage1(),
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
                          'Personalisasi Karir',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Lengkapi Personalisasi Karir Anda',
                          style: TextStyle(
                            fontSize: 14,
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
                        
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    
                    // Purpose of joining section
                    const Text(
                      'Apa tujuan Anda bergabung?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Montserrat',
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Obx(() => _buildChipSelection(
                      options: controller.purposeOptions,
                      selectedValues: controller.selectedPurposes,
                      isMultiSelect: true,
                      onTap: (value) => controller.togglePurpose(value),
                    )),
                    
                    const SizedBox(height: 30),
                    
                    // Work readiness section
                    const Text(
                      'Seberapa siap Anda memasuki dunia kerja?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Montserrat',
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Obx(() => _buildChipSelection(
                      options: controller.readinessOptions,
                      selectedValues: [controller.selectedReadiness.value].where((e) => e.isNotEmpty).toList(),
                      isMultiSelect: false,
                      onTap: (value) => controller.selectReadiness(value),
                    )),
                    
                    const SizedBox(height: 30),
                    
                    // Current status section
                    const Text(
                      'Saat ini Anda sebagai?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Montserrat',
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Obx(() => _buildChipSelection(
                      options: controller.statusOptions,
                      selectedValues: [controller.selectedStatus.value].where((e) => e.isNotEmpty).toList(),
                      isMultiSelect: false,
                      onTap: (value) => controller.selectStatus(value),
                    )),
                    
                    const SizedBox(height: 30),
                    
                    // Interest fields section
                    const Text(
                      'Bidang apa yang Anda minati?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Montserrat',
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Obx(() => _buildChipSelection(
                      options: controller.interestFieldOptions,
                      selectedValues: controller.selectedInterestFields,
                      isMultiSelect: true,
                      onTap: (value) => controller.toggleInterestField(value),
                    )),
                    
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            
            // Bottom button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              child: SizedBox(
                width: double.infinity,
                child: Obx(() => ElevatedButton(
                  onPressed: controller.isLoading.value ? null : controller.completePersonalization,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: controller.isLoading.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Selesai',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Montserrat',
                            color: Colors.white,
                          ),
                        ),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChipSelection({
    required List<String> options,
    required List<String> selectedValues,
    required bool isMultiSelect,
    Function(String)? onTap,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((option) {
        final isSelected = selectedValues.contains(option);
        return GestureDetector(
          onTap: () {
            if (onTap != null) {
              onTap(option);
            } else if (isMultiSelect) {
              if (isSelected) {
                selectedValues.remove(option);
              } else {
                selectedValues.add(option);
              }
              controller.update();
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected 
                  ? AppColors.primary.withOpacity(0.1) 
                  : Colors.transparent,
              border: Border.all(
                color: isSelected 
                    ? AppColors.primary 
                    : AppColors.outline,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              option,
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Montserrat',
                color: isSelected 
                    ? AppColors.primary 
                    : AppColors.textPrimary,
                fontWeight: isSelected 
                    ? FontWeight.w600 
                    : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
