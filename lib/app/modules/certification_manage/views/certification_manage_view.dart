import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../styles/app_colors.dart';
import '../controllers/certification_manage_controller.dart';

class CertificationManageView extends GetView<CertificationManageController> {
  const CertificationManageView({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        return SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: controller.isLoading.value
                    ? _buildLoadingState()
                    : controller.hasCertifications
                        ? _buildCertificationsList()
                        : _buildEmptyState(),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 20, 25, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                color: AppColors.primary,
                size: 24,
              ),
            ),
          ),
          const Text(
            'Kelola Sertifikat',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(
            width: 24,
          )
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.workspace_premium,
              size: 60,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 24),
            const Text(
              'Belum Ada Sertifikat',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              'Mulai perjalanan sertifikasi Anda untuk meningkatkan kredibilitas profesional',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Montserrat',
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated loading circle similar to Interview Practice
          const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Memuat Sertifikat...',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCertificationsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.certifications.length,
      itemBuilder: (context, index) {
        final certification = controller.certifications[index];
        return _buildCertificationCard(certification);
      },
    );
  }

  Widget _buildCertificationCard(ManagedCertification certification) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: AppColors.outline,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    certification.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: certification.isCompleted ? AppColors.tertiary : AppColors.secondary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    certification.isCompleted ? 'Selesai' : 'Dalam Progress',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              certification.provider,
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'Montserrat',
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              certification.description,
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'Montserrat',
                color: AppColors.textSecondary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (certification.completedDate != null) ...[
              const SizedBox(height: 8),
              Text(
                'Selesai: ${certification.completedDate!.day}/${certification.completedDate!.month}/${certification.completedDate!.year}',
                style: const TextStyle(
                  fontSize: 12,
                  fontFamily: 'Montserrat',
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
