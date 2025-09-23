import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../styles/app_colors.dart';
import '../controllers/job_openings_main_controller.dart';
import '../local_widgets/filter_chip.dart';
import '../local_widgets/job_card.dart';

class JobOpeningsView extends GetView<JobOpeningsController> {
  const JobOpeningsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildFilterSection(),
            _buildJobList(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.arrow_back, size: 30, color: AppColors.textPrimary),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.outline.withOpacity(0.2)),
              ),
              child: TextField(
                controller: controller.searchController,
                decoration: InputDecoration(
                  hintText: "Cari lowongan kerja...",
                  hintStyle: TextStyle(fontFamily: "Montserrat", fontSize: 14, color: AppColors.textSecondary),
                  prefixIcon: Icon(CupertinoIcons.search, color: AppColors.textSecondary, size: 20),
                  suffixIcon: Obx(() => controller.searchQuery.value.isNotEmpty
                      ? GestureDetector(
                          onTap: controller.clearSearch,
                          child: Icon(CupertinoIcons.clear_circled_solid, color: AppColors.textSecondary, size: 20),
                        )
                      : SizedBox.shrink()),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
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
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.outline.withOpacity(0.2)),
                ),
                child: Icon(CupertinoIcons.slider_horizontal_3, color: AppColors.primary, size: 20),
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
    );
  }

  Widget _buildJobList() {
    return Expanded(
      child: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator(color: AppColors.primary));
        }
        
        if (controller.filteredJobs.isEmpty) {
          return Center(
            child: Text(
              'Tidak ada lowongan kerja ditemukan',
              style: TextStyle(fontFamily: "Montserrat", fontSize: 16, color: AppColors.textSecondary),
            ),
          );
        }
        
        return ListView.builder(
          padding: EdgeInsets.all(20),
          itemCount: controller.filteredJobs.length,
          itemBuilder: (context, index) {
            final job = controller.filteredJobs[index];
            return JobCard(job: job);
          },
        );
      }),
    );
  }
}
