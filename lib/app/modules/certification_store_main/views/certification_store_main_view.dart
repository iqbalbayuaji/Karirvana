import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../styles/app_colors.dart';
import '../controllers/certification_store_main_controller.dart';
import '../local_widgets/filter_chip.dart';
import '../local_widgets/certification_card.dart';

class CertificationStoreMainView extends GetView<CertificationStoreMainController> {
  const CertificationStoreMainView({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header with Search
            Container(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child: Icon(
                        Icons.arrow_back,
                        size: 30,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: AppColors.outline.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: TextField(
                        controller: controller.searchController,
                        decoration: InputDecoration(
                          hintText: "Cari sertifikasi...",
                          hintStyle: TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: 14,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w400,
                          ),
                          prefixIcon: Icon(
                            CupertinoIcons.search,
                            color: AppColors.textSecondary,
                            size: 20,
                          ),
                          suffixIcon: Obx(() => controller.searchQuery.value.isNotEmpty
                              ? GestureDetector(
                                  onTap: controller.clearSearch,
                                  child: Icon(
                                    CupertinoIcons.clear_circled_solid,
                                    color: AppColors.textSecondary,
                                    size: 20,
                                  ),
                                )
                              : SizedBox.shrink()),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                        style: TextStyle(
                          fontFamily: "Montserrat",
                          fontSize: 14,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Filter Section
            Container(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 20),
                itemCount: controller.filters.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: AppColors.outline.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          CupertinoIcons.slider_horizontal_3,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                    );
                  }
                  
                  final filter = controller.filters[index - 1];
                  return Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Obx(() => CustomFilterChip(
                      label: filter,
                      isSelected: controller.selectedFilter.value == filter,
                      onTap: () => controller.setFilter(filter),
                    )),
                  );
                },
              ),
            ),
            
            // Certification List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Memuat sertifikasi...',
                          style: TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: 14,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                
                if (controller.filteredCertifications.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.doc_checkmark,
                          size: 64,
                          color: AppColors.textSecondary.withOpacity(0.5),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Tidak ada sertifikasi ditemukan',
                          style: TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Coba ubah filter atau kata kunci pencarian',
                          style: TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: 14,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }
                
                return ListView.builder(
                  padding: EdgeInsets.all(20),
                  itemCount: controller.filteredCertifications.length,
                  itemBuilder: (context, index) {
                    final certification = controller.filteredCertifications[index];
                    return CertificationCard(
                      certification: certification,
                      onTap: () {
                        // Navigate to certification detail
                        Get.snackbar(
                          'Sertifikasi Dipilih',
                          'Navigasi ke ${certification.title}',
                          backgroundColor: AppColors.primary,
                          colorText: AppColors.textOnPrimary,
                          duration: Duration(seconds: 2),
                          snackPosition: SnackPosition.BOTTOM,
                          margin: EdgeInsets.all(16),
                          borderRadius: 12,
                        );
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
