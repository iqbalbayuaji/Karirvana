import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../styles/app_colors.dart';
import '../controllers/certification_manage_controller.dart';
import '../local_widgets/managed_certification_card.dart';

class CertificationManageView extends GetView<CertificationManageController> {
  const CertificationManageView({super.key});
  
  @override
  Widget build(BuildContext context) {
    print('🎯 CertificationManageView build() - Controller hashCode: ${controller.hashCode}');
    print('📋 Certifications count in view: ${controller.certifications.length}');
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        return SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: () {
                  print('🔍 View Decision: isLoading=${controller.isLoading.value}, hasCertifications=${controller.hasCertifications}, count=${controller.certifications.length}');
                  
                  if (controller.isLoading.value) {
                    print('➡️ Showing loading state');
                    return _buildLoadingState();
                  } else if (controller.hasCertifications) {
                    print('➡️ Showing certifications list');
                    return _buildCertificationsList();
                  } else {
                    print('➡️ Showing empty state');
                    return _buildEmptyState();
                  }
                }(),
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
    print('🎯 _buildCertificationsList() called with ${controller.certifications.length} items');
    for (int i = 0; i < controller.certifications.length; i++) {
      print('📋 Certification $i: ${controller.certifications[i].title}');
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.certifications.length,
      itemBuilder: (context, index) {
        final certification = controller.certifications[index];
        print('🎨 Building card for: ${certification.title}');
        return ManagedCertificationCard(
          certification: certification,
          onTap: () {
            // No action - just display certification info
            print('Tapped certification: ${certification.title}');
          },
        );
      },
    );
  }

}
