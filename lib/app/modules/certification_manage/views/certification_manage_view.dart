import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../styles/app_colors.dart';
import '../controllers/certification_manage_controller.dart';
import '../../certification_store_main/local_widgets/certification_card.dart';
import '../../certification_store_main/controllers/certification_store_main_controller.dart' as store;

class CertificationManageView extends GetView<CertificationManageController> {
  const CertificationManageView({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        return SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: controller.hasCertifications
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
                color: AppColors.textPrimary,
                size: 20,
              ),
            ),
          ),
          const Text(
            'Certification Manage',
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              child: const Icon(
                Icons.workspace_premium,
                size: 60,
                color: AppColors.textSecondary,
              ),
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
            ),
            const SizedBox(height: 12),
            const Text(
              'Anda belum memiliki sertifikat apapun.\nMulai tambahkan sertifikat untuk melacak pencapaian Anda!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Montserrat',
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildCertificationsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.certifications.length,
      itemBuilder: (context, index) {
        final certification = controller.certifications[index];
        // Convert to store certification model
        final storeCertification = _convertToStoreCertification(certification);
        return _buildCustomCertificationCard(certification, storeCertification);
      },
    );
  }

  // Convert manage certification to store certification model
  store.Certification _convertToStoreCertification(Certification certification) {
    return store.Certification(
      id: certification.id,
      title: certification.title,
      provider: certification.provider,
      category: 'IT & Programming', // Default category
      level: '', // Empty level to hide default text
      rating: 4.5, // Default rating
      totalParticipants: 0, // Default participants
      totalModules: 1, // Default modules
      duration: '1 bulan', // Default duration
      originalPrice: 0, // Free for managed certifications
      discountedPrice: 0,
      isFree: true,
      showDiscount: false,
      discount: '',
      validityPeriod: '2 tahun', // Default validity
      description: certification.description,
      imageUrl: '', // No image for managed certifications
      totalReviews: 0,
      benefits: ['Sertifikasi yang disesuaikan dengan kebutuhan'],
      requirements: ['Tidak ada persyaratan khusus'],
    );
  }

  // Build custom certification card with proper status display
  Widget _buildCustomCertificationCard(Certification certification, store.Certification storeCertification) {
    return Stack(
      children: [
        CertificationCard(
          certification: storeCertification,
          onTap: () {
            // Handle certification tap - no popup
          },
        ),
        // Override status text
        Positioned(
          right: 22,
          bottom: 26,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              _getStatusText(certification),
              style: TextStyle(
                fontFamily: "Montserrat",
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _getStatusColor(certification),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Get status text for display
  String _getStatusText(Certification certification) {
    return certification.isCompleted ? 'Completed' : 'Added';
  }

  // Get status color
  Color _getStatusColor(Certification certification) {
    return certification.isCompleted 
        ? const Color(0xFF10B981) // Green for completed
        : const Color(0xFFF59E0B); // Orange for added
  }
}
