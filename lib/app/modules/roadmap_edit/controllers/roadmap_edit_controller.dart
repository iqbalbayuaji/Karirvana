import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../styles/app_colors.dart';
import '../../roadmap_manage/models/roadmap_models.dart';

class RoadmapEditController extends GetxController {
  // Roadmap data - same structure as roadmap_manage
  final isLoading = false.obs;
  final roadmapTitle = 'Frontend Developer Career Path'.obs;
  final roadmapSteps = <RoadmapMainStep>[].obs;
  final expandedSteps = <String>{}.obs;
  final expandedSubSteps = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeSampleData();
  }

  void _initializeSampleData() {
    isLoading.value = true;
    // Copy same data structure as roadmap_manage
    roadmapSteps.value = [
      RoadmapMainStep(
        id: '1',
        title: 'Mempelajari Frontend Development',
        description: 'Kuasai teknologi dasar untuk pengembangan web frontend',
        isCompleted: false,
        estimatedDuration: '3-4 bulan',
        subSteps: [
          RoadmapSubStep(
            id: '1-1',
            title: 'Belajar HTML & CSS',
            description: 'Pelajari struktur dan styling dasar website',
            isCompleted: true,
            estimatedDuration: '2-3 minggu',
            resources: [
              RoadmapResource(
                type: 'course',
                title: 'HTML & CSS Fundamentals',
                provider: 'Karirvana Academy',
                status: ResourceStatus.completed,
              ),
              RoadmapResource(
                type: 'certificate',
                title: 'Web Development Certificate',
                provider: 'Karirvana',
                status: ResourceStatus.inProgress,
              ),
              RoadmapResource(
                type: 'certificate',
                title: 'HTML5 & CSS3 Certificate',
                provider: 'TechCert',
                status: ResourceStatus.added,
              ),
              RoadmapResource(
                type: 'certificate',
                title: 'Web Design Fundamentals',
                provider: 'DesignPro',
                status: ResourceStatus.notAdded,
              ),
            ],
          ),
          RoadmapSubStep(
            id: '1-2',
            title: 'Belajar JavaScript',
            description: 'Kuasai bahasa pemrograman untuk interaktivitas web',
            isCompleted: false,
            estimatedDuration: '4-6 minggu',
            resources: [
              RoadmapResource(
                type: 'course', 
                title: 'JavaScript Essentials', 
                provider: 'CodeAcademy',
                status: ResourceStatus.notAdded,
              ),
              RoadmapResource(
                type: 'course', 
                title: 'Modern JavaScript ES6+', 
                provider: 'DevSkills',
                status: ResourceStatus.added,
              ),
            ],
          ),
          RoadmapSubStep(
            id: '1-3',
            title: 'Belajar React.js',
            description: 'Pelajari framework React untuk aplikasi web modern',
            isCompleted: false,
            estimatedDuration: '6-8 minggu',
            resources: [
              RoadmapResource(
                type: 'course', 
                title: 'React.js Complete Guide', 
                provider: 'ReactMasters',
                status: ResourceStatus.notAdded,
              ),
              RoadmapResource(
                type: 'certificate', 
                title: 'React Developer Certificate', 
                provider: 'ReactCert',
                status: ResourceStatus.notAdded,
              ),
            ],
          ),
        ],
      ),
      RoadmapMainStep(
        id: '2',
        title: 'Create Portfolio',
        description: 'Bangun portfolio yang menarik dan dapatkan sertifikasi',
        isCompleted: false,
        estimatedDuration: '1-2 bulan',
        subSteps: [
          RoadmapSubStep(
            id: '2-1',
            title: 'Mengikuti Sertifikasi',
            description: 'Dapatkan sertifikasi untuk meningkatkan kredibilitas',
            isCompleted: false,
            estimatedDuration: '2-3 minggu',
            resources: [
              RoadmapResource(
                type: 'certificate', 
                title: 'Frontend Developer Professional', 
                provider: 'TechCert',
                status: ResourceStatus.notAdded,
              ),
              RoadmapResource(
                type: 'certificate', 
                title: 'React.js Specialist', 
                provider: 'ReactCert',
                status: ResourceStatus.notAdded,
              ),
            ],
          ),
          RoadmapSubStep(
            id: '2-2',
            title: 'Membuat CV',
            description: 'Buat CV yang menarik dan profesional',
            isCompleted: false,
            estimatedDuration: '1 minggu',
            resources: [
              RoadmapResource(
                type: 'tool', 
                title: 'CV Assistant', 
                provider: 'Karirvana',
                status: ResourceStatus.notAdded,
              ),
            ],
          ),
          RoadmapSubStep(
            id: '2-3',
            title: 'Bangun Portfolio Website',
            description: 'Buat website portfolio untuk showcase project',
            isCompleted: false,
            estimatedDuration: '2-3 minggu',
            resources: [
              RoadmapResource(
                type: 'course', 
                title: 'Portfolio Website Development', 
                provider: 'WebAcademy',
                status: ResourceStatus.notAdded,
              ),
            ],
          ),
        ],
      ),
      RoadmapMainStep(
        id: '3',
        title: 'Melamar Pekerjaan',
        description: 'Mulai melamar pekerjaan sebagai Frontend Developer',
        isCompleted: false,
        estimatedDuration: '1-3 bulan',
        subSteps: [
          RoadmapSubStep(
            id: '3-1',
            title: 'Persiapan Interview',
            description: 'Siapkan diri untuk proses interview',
            isCompleted: false,
            estimatedDuration: '2-3 minggu',
            resources: [
              RoadmapResource(
                type: 'course', 
                title: 'Technical Interview Mastery', 
                provider: 'InterviewAce',
                status: ResourceStatus.notAdded,
              ),
              RoadmapResource(
                type: 'tool', 
                title: 'Interview Practice', 
                provider: 'Karirvana',
                status: ResourceStatus.notAdded,
              ),
            ],
          ),
          RoadmapSubStep(
            id: '3-2',
            title: 'Apply to Companies',
            description: 'Mulai melamar ke perusahaan target',
            isCompleted: false,
            estimatedDuration: '4-8 minggu',
            resources: [
              RoadmapResource(
                type: 'job', 
                title: 'Frontend Developer - Tokopedia', 
                provider: 'Tokopedia', 
                location: 'Jakarta',
                jobStatus: JobApplicationStatus.applied,
              ),
              RoadmapResource(
                type: 'job', 
                title: 'React Developer - Gojek', 
                provider: 'Gojek', 
                location: 'Jakarta',
                jobStatus: JobApplicationStatus.accepted,
              ),
              RoadmapResource(
                type: 'job', 
                title: 'Web Developer - Shopee', 
                provider: 'Shopee', 
                location: 'Jakarta',
                jobStatus: JobApplicationStatus.notApplied,
              ),
              RoadmapResource(
                type: 'job', 
                title: 'Frontend Engineer - Traveloka', 
                provider: 'Traveloka', 
                location: 'Jakarta',
                jobStatus: JobApplicationStatus.notApplied,
              ),
            ],
          ),
        ],
      ),
    ];
    
    isLoading.value = false;
  }

  // Toggle methods
  void toggleMainStep(String stepId) {
    if (expandedSteps.contains(stepId)) {
      expandedSteps.remove(stepId);
      // Also collapse all sub-steps when main step is collapsed
      final mainStep = roadmapSteps.firstWhere((step) => step.id == stepId);
      for (final subStep in mainStep.subSteps) {
        expandedSubSteps.remove(subStep.id);
      }
    } else {
      expandedSteps.add(stepId);
    }
    expandedSteps.refresh();
    expandedSubSteps.refresh();
  }

  void toggleSubStep(String subStepId) {
    if (expandedSubSteps.contains(subStepId)) {
      expandedSubSteps.remove(subStepId);
    } else {
      expandedSubSteps.add(subStepId);
    }
    expandedSubSteps.refresh();
  }

  // Edit methods
  void editRoadmapTitle() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Edit Roadmap Title',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: 'Montserrat',
            color: AppColors.textPrimary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: roadmapTitle.value,
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Montserrat',
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                labelText: 'Roadmap Title',
                labelStyle: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Montserrat',
                  color: AppColors.textSecondary,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.outline),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.outline),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.primary, width: 2),
                ),
                filled: true,
                fillColor: AppColors.background,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: (value) {
                roadmapTitle.value = value;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'Montserrat',
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.snackbar(
                'Berhasil',
                'Judul roadmap berhasil diperbarui',
                backgroundColor: Colors.green,
                colorText: Colors.white,
                borderRadius: 12,
                margin: const EdgeInsets.all(16),
                snackPosition: SnackPosition.TOP,
                duration: const Duration(seconds: 2),
                titleText: Text(
                  'Berhasil',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                  ),
                ),
                messageText: Text(
                  'Judul roadmap berhasil diperbarui',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 2,
            ),
            child: Text(
              'Save',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'Montserrat',
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Delete methods
  void deleteMainStep(String stepId) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.warning_rounded,
              color: Colors.red,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              'Hapus Step',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                fontFamily: 'Montserrat',
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Apakah Anda yakin ingin menghapus step ini?',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Montserrat',
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tindakan ini tidak dapat dibatalkan dan akan menghapus semua sub-step di dalamnya.',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Montserrat',
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Batal',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'Montserrat',
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              roadmapSteps.removeWhere((step) => step.id == stepId);
              expandedSteps.remove(stepId);
              Get.back();
              Get.snackbar(
                'Berhasil',
                'Step berhasil dihapus',
                backgroundColor: Colors.red,
                colorText: Colors.white,
                borderRadius: 12,
                margin: const EdgeInsets.all(16),
                snackPosition: SnackPosition.TOP,
                duration: const Duration(seconds: 2),
                titleText: Text(
                  'Berhasil',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                  ),
                ),
                messageText: Text(
                  'Step berhasil dihapus',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 2,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.delete_outline, size: 18, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  'Hapus',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void deleteSubStep(String mainStepId, String subStepId) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.warning_rounded,
              color: Colors.red,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              'Hapus Sub-Step',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                fontFamily: 'Montserrat',
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Apakah Anda yakin ingin menghapus sub-step ini?',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Montserrat',
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tindakan ini tidak dapat dibatalkan dan akan menghapus semua rekomendasi di dalamnya.',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Montserrat',
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Batal',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'Montserrat',
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final mainStepIndex = roadmapSteps.indexWhere((step) => step.id == mainStepId);
              if (mainStepIndex != -1) {
                roadmapSteps[mainStepIndex].subSteps.removeWhere((subStep) => subStep.id == subStepId);
                expandedSubSteps.remove(subStepId);
                roadmapSteps.refresh();
              }
              Get.back();
              Get.snackbar(
                'Berhasil',
                'Sub-step berhasil dihapus',
                backgroundColor: Colors.red,
                colorText: Colors.white,
                borderRadius: 12,
                margin: const EdgeInsets.all(16),
                snackPosition: SnackPosition.TOP,
                duration: const Duration(seconds: 2),
                titleText: Text(
                  'Berhasil',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                  ),
                ),
                messageText: Text(
                  'Sub-step berhasil dihapus',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 2,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.delete_outline, size: 18, color:Colors.white),
                const SizedBox(width: 8),
                Text(
                  'Hapus',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void deleteResource(String mainStepId, String subStepId, RoadmapResource resource) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.warning_rounded,
              color: Colors.red,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              'Hapus Rekomendasi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                fontFamily: 'Montserrat',
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Apakah Anda yakin ingin menghapus rekomendasi ini?',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Montserrat',
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.outline.withOpacity(0.5)),
              ),
              child: Row(
                children: [
                  Icon(
                    resource.type == 'course' ? Icons.school_outlined :
                    resource.type == 'certificate' ? Icons.verified_outlined :
                    resource.type == 'job' ? Icons.work_outline :
                    Icons.link_outlined,
                    size: 20,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '"${resource.title}"',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Montserrat',
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tindakan ini tidak dapat dibatalkan.',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Montserrat',
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Batal',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'Montserrat',
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final mainStepIndex = roadmapSteps.indexWhere((step) => step.id == mainStepId);
              if (mainStepIndex != -1) {
                final subStepIndex = roadmapSteps[mainStepIndex].subSteps.indexWhere((subStep) => subStep.id == subStepId);
                if (subStepIndex != -1) {
                  roadmapSteps[mainStepIndex].subSteps[subStepIndex].resources.remove(resource);
                  roadmapSteps.refresh();
                }
              }
              Get.back();
              Get.snackbar(
                'Berhasil',
                'Rekomendasi berhasil dihapus',
                backgroundColor: Colors.red,
                colorText: Colors.white,
                borderRadius: 12,
                margin: const EdgeInsets.all(16),
                snackPosition: SnackPosition.TOP,
                duration: const Duration(seconds: 2),
                titleText: Text(
                  'Berhasil',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                  ),
                ),
                messageText: Text(
                  'Rekomendasi berhasil dihapus',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 2,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.delete_outline, size: 18, color:Colors.white),
                const SizedBox(width: 8),
                Text(
                  'Hapus',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Add methods
  void addSubStep(String mainStepId) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final durationController = TextEditingController();

    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Tambah Sub-Step',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: 'Montserrat',
            color: AppColors.textPrimary,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title Field
              TextFormField(
                controller: titleController,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Montserrat',
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  labelText: 'Judul Sub-Step',
                  labelStyle: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Montserrat',
                    color: AppColors.textSecondary,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.outline),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.outline),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                  ),
                  filled: true,
                  fillColor: AppColors.background,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 16),
              // Description Field
              TextFormField(
                controller: descriptionController,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Montserrat',
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  labelText: 'Deskripsi',
                  labelStyle: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Montserrat',
                    color: AppColors.textSecondary,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.outline),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.outline),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                  ),
                  filled: true,
                  fillColor: AppColors.background,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              // Duration Field
              TextFormField(
                controller: durationController,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Montserrat',
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  labelText: 'Estimasi Durasi',
                  hintText: 'Contoh: 1 minggu, 3 hari',
                  labelStyle: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Montserrat',
                    color: AppColors.textSecondary,
                  ),
                  hintStyle: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Montserrat',
                    color: AppColors.textSecondary.withOpacity(0.7),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.outline),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.outline),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                  ),
                  filled: true,
                  fillColor: AppColors.background,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Batal',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'Montserrat',
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                final mainStepIndex = roadmapSteps.indexWhere((step) => step.id == mainStepId);
                if (mainStepIndex != -1) {
                  final newSubStep = RoadmapSubStep(
                    id: '${mainStepId}-${DateTime.now().millisecondsSinceEpoch}',
                    title: titleController.text,
                    description: descriptionController.text,
                    isCompleted: false,
                    estimatedDuration: durationController.text.isEmpty ? '1 minggu' : durationController.text,
                    resources: [],
                  );
                  roadmapSteps[mainStepIndex].subSteps.add(newSubStep);
                  roadmapSteps.refresh();
                }
                Get.back();
                Get.snackbar(
                  'Berhasil',
                  'Sub-step berhasil ditambahkan',
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                  borderRadius: 12,
                  margin: const EdgeInsets.all(16),
                  snackPosition: SnackPosition.TOP,
                  duration: const Duration(seconds: 2),
                  titleText: Text(
                    'Berhasil',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Montserrat',
                      color: Colors.white,
                    ),
                  ),
                  messageText: Text(
                    'Sub-step berhasil ditambahkan',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      color: Colors.white,
                    ),
                  ),
                );
              } else {
                Get.snackbar(
                  'Peringatan',
                  'Judul sub-step tidak boleh kosong',
                  backgroundColor: Colors.orange,
                  colorText: Colors.white,
                  borderRadius: 12,
                  margin: const EdgeInsets.all(16),
                  snackPosition: SnackPosition.TOP,
                  duration: const Duration(seconds: 2),
                  titleText: Text(
                    'Peringatan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Montserrat',
                      color: Colors.white,
                    ),
                  ),
                  messageText: Text(
                    'Judul sub-step tidak boleh kosong',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      color: Colors.white,
                    ),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 2,
            ),
            child: Text(
              'Tambah',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'Montserrat',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void addResource(String mainStepId, String subStepId) {
    final titleController = TextEditingController();
    final providerController = TextEditingController();
    final locationController = TextEditingController();
    String selectedType = 'course';
    ResourceStatus selectedStatus = ResourceStatus.notAdded;
    JobApplicationStatus selectedJobStatus = JobApplicationStatus.notApplied;

    Get.dialog(
      AlertDialog(
        title: const Text('Add Resource'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedType,
                decoration: const InputDecoration(
                  labelText: 'Type',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'course', child: Text('Course')),
                  DropdownMenuItem(value: 'certificate', child: Text('Certificate')),
                  DropdownMenuItem(value: 'job', child: Text('Job')),
                  DropdownMenuItem(value: 'tool', child: Text('Tool')),
                ],
                onChanged: (value) {
                  selectedType = value!;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: providerController,
                decoration: const InputDecoration(
                  labelText: 'Provider',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: locationController,
                decoration: const InputDecoration(
                  labelText: 'Location (for jobs)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty && providerController.text.isNotEmpty) {
                final mainStepIndex = roadmapSteps.indexWhere((step) => step.id == mainStepId);
                if (mainStepIndex != -1) {
                  final subStepIndex = roadmapSteps[mainStepIndex].subSteps.indexWhere((subStep) => subStep.id == subStepId);
                  if (subStepIndex != -1) {
                    final newResource = RoadmapResource(
                      type: selectedType,
                      title: titleController.text,
                      provider: providerController.text,
                      location: locationController.text.isEmpty ? null : locationController.text,
                      status: selectedStatus,
                      jobStatus: selectedType == 'job' ? selectedJobStatus : null,
                    );
                    roadmapSteps[mainStepIndex].subSteps[subStepIndex].resources.add(newResource);
                    roadmapSteps.refresh();
                  }
                }
                Get.back();
                Get.snackbar(
                  'Added',
                  'Resource has been added',
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void editResource(String mainStepId, String subStepId, RoadmapResource resource) {
    final titleController = TextEditingController(text: resource.title);
    final providerController = TextEditingController(text: resource.provider);
    final locationController = TextEditingController(text: resource.location ?? '');

    Get.dialog(
      AlertDialog(
        title: const Text('Edit Resource'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: providerController,
                decoration: const InputDecoration(
                  labelText: 'Provider',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              if (resource.type == 'job')
                TextFormField(
                  controller: locationController,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(),
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final mainStepIndex = roadmapSteps.indexWhere((step) => step.id == mainStepId);
              if (mainStepIndex != -1) {
                final subStepIndex = roadmapSteps[mainStepIndex].subSteps.indexWhere((subStep) => subStep.id == subStepId);
                if (subStepIndex != -1) {
                  final resourceIndex = roadmapSteps[mainStepIndex].subSteps[subStepIndex].resources.indexOf(resource);
                  if (resourceIndex != -1) {
                    // Update the resource
                    final updatedResource = RoadmapResource(
                      type: resource.type,
                      title: titleController.text,
                      provider: providerController.text,
                      location: locationController.text.isEmpty ? null : locationController.text,
                      status: resource.status,
                      jobStatus: resource.jobStatus,
                    );
                    roadmapSteps[mainStepIndex].subSteps[subStepIndex].resources[resourceIndex] = updatedResource;
                    roadmapSteps.refresh();
                  }
                }
              }
              Get.back();
              Get.snackbar(
                'Updated',
                'Resource has been updated',
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void saveRoadmap() {
    // TODO: Implement save to Firebase or local storage
    Get.snackbar(
      'Saved',
      'Roadmap has been saved successfully',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
    Get.back(); // Return to roadmap_manage
  }

  double get overallProgress {
    if (roadmapSteps.isEmpty) return 0.0;
    
    int totalSteps = 0;
    int completedSteps = 0;
    
    for (final mainStep in roadmapSteps) {
      totalSteps += 1 + mainStep.subSteps.length;
      if (mainStep.isCompleted) completedSteps++;
      for (final subStep in mainStep.subSteps) {
        if (subStep.isCompleted) completedSteps++;
      }
    }
    
    return totalSteps > 0 ? completedSteps / totalSteps : 0.0;
  }
}
