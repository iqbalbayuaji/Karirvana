import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karirvana/app/routes/app_pages.dart';
import '../../../styles/app_colors.dart';
import '../controllers/roadmap_manage_controller.dart';
import '../models/roadmap_models.dart';

class RoadmapManageView extends GetView<RoadmapManageController> {
  const RoadmapManageView({Key? key}) : super(key: key);

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
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProgressOverview(),
                    const SizedBox(height: 24),
                    _buildRoadmapSteps(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildHeader() {
    return Padding(
              padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
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
                    'Roadmap Karir',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 33),
                ],
              ),
            );
  }

  Widget _buildProgressOverview() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Roadmap Web Frontend Programmer',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Montserrat',
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Obx(() => Text(
                      '${(controller.overallProgress * 100).toInt()}% Selesai',
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Montserrat',
                        color: AppColors.textSecondary,
                      ),
                    )),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.ROADMAP_EDIT);
                },
                child: Icon(
                  Icons.edit_outlined,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(
                width: 15
              ),
              GestureDetector(
                onTap: () {

                },
                child: Icon(
                  Icons.delete_outlined,
                  color: Colors.red[400],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Obx(() => LinearProgressIndicator(
            value: controller.overallProgress,
            backgroundColor: AppColors.primaryContainer,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            minHeight: 8,
            borderRadius: BorderRadius.circular(16),
          )),
        ],
      ),
    );
  }

  Widget _buildRoadmapSteps() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() => Column(
          children: controller.roadmapSteps.asMap().entries.map((entry) {
            final index = entry.key;
            final step = entry.value;
            return _buildMainStepCard(step, index);
          }).toList(),
        )),
      ],
    );
  }

  Widget _buildMainStepCard(RoadmapMainStep step, int index) {
    final isExpanded = controller.expandedSteps.contains(step.id);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => controller.toggleMainStep(step.id),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // Step number and status
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: step.isCompleted 
                          ? Colors.green 
                          : AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: step.isCompleted
                          ? const Icon(Icons.check, color: Colors.white, size: 20)
                          : Text(
                              '${index + 1}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Montserrat',
                                color: AppColors.primary,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Step content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Montserrat',
                            color: step.isCompleted 
                                ? AppColors.textSecondary 
                                : AppColors.textPrimary,
                            decoration: step.isCompleted 
                                ? TextDecoration.lineThrough 
                                : null,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          step.description,
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Montserrat',
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.schedule,
                              size: 16,
                              color: AppColors.textSecondary.withOpacity(0.7),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              step.estimatedDuration,
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'Montserrat',
                                color: AppColors.textSecondary.withOpacity(0.7),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Icon(
                              Icons.list_alt,
                              size: 16,
                              color: AppColors.textSecondary.withOpacity(0.7),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${step.subSteps.length} sub-langkah',
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'Montserrat',
                                color: AppColors.textSecondary.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Expand/collapse icon
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
          // Sub-steps (expanded content)
          if (isExpanded) ...[
            Divider(height: 1, color: AppColors.outline.withOpacity(0.3)),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: step.subSteps.map((subStep) => 
                  _buildSubStepCard(subStep)).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSubStepCard(RoadmapSubStep subStep) {
    final isExpanded = controller.expandedSubSteps.contains(subStep.id);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.outline.withOpacity(0.5),
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => controller.toggleSubStep(subStep.id),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Status indicator (read-only)
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: subStep.isCompleted 
                          ? Colors.green 
                          : Colors.transparent,
                      border: Border.all(
                        color: subStep.isCompleted 
                            ? Colors.green 
                            : AppColors.textSecondary.withOpacity(0.5),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: subStep.isCompleted
                        ? const Icon(Icons.check, color: Colors.white, size: 16)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  // Sub-step content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subStep.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Montserrat',
                            color: subStep.isCompleted 
                                ? AppColors.textSecondary 
                                : AppColors.textPrimary,
                            decoration: subStep.isCompleted 
                                ? TextDecoration.lineThrough 
                                : null,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subStep.description,
                          style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'Montserrat',
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              Icons.schedule,
                              size: 14,
                              color: AppColors.textSecondary.withOpacity(0.7),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              subStep.estimatedDuration,
                              style: TextStyle(
                                fontSize: 11,
                                fontFamily: 'Montserrat',
                                color: AppColors.textSecondary.withOpacity(0.7),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Icon(
                              Icons.library_books,
                              size: 14,
                              color: AppColors.textSecondary.withOpacity(0.7),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${subStep.resources.length} resources',
                              style: TextStyle(
                                fontSize: 11,
                                fontFamily: 'Montserrat',
                                color: AppColors.textSecondary.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Expand/collapse icon for resources
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          // Resources (expanded content)
          if (isExpanded) ...[
            Divider(height: 1, color: AppColors.outline.withOpacity(0.3)),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Rekomendasi Resources:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Montserrat',
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...subStep.resources.map((resource) => _buildResourceItem(resource)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildResourceItem(RoadmapResource resource) {
    IconData icon;
    Color color;
    
    switch (resource.type) {
      case 'course':
        icon = Icons.play_circle_outline;
        color = AppColors.primary;
        break;
      case 'certificate':
        icon = Icons.verified_outlined;
        color = Colors.green;
        break;
      case 'job':
        icon = Icons.work_outline;
        color = Colors.orange;
        break;
      case 'guide':
        icon = Icons.menu_book_outlined;
        color = Colors.blue;
        break;
      case 'tool':
        icon = Icons.build_outlined;
        color = AppColors.tertiary;
        break;
      default:
        icon = Icons.link;
        color = AppColors.textSecondary;
    }
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  resource.title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Montserrat',
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      resource.provider,
                      style: const TextStyle(
                        fontSize: 11,
                        fontFamily: 'Montserrat',
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (resource.location != null) ...[
                      const Text(' • ', style: TextStyle(color: AppColors.textSecondary)),
                      Text(
                        resource.location!,
                        style: const TextStyle(
                          fontSize: 11,
                          fontFamily: 'Montserrat',
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          _buildResourceStatusIndicator(resource),
        ],
      ),
    );
  }

  Widget _buildResourceStatusIndicator(RoadmapResource resource) {
    // For job type, use job-specific status
    if (resource.type == 'job') {
      return _buildJobStatusIndicator(resource.jobStatus ?? JobApplicationStatus.notApplied);
    }
    
    // For course and certificate, use general resource status
    return _buildGeneralResourceStatusIndicator(resource.status);
  }

  Widget _buildJobStatusIndicator(JobApplicationStatus status) {
    switch (status) {
      case JobApplicationStatus.notApplied:
        // Kondisi 1: Belum apply - tampilan normal dengan panah
        return Icon(
          Icons.arrow_forward_ios,
          size: 12,
          color: AppColors.textSecondary.withOpacity(0.5),
        );
      
      case JobApplicationStatus.applied:
        // Kondisi 2: Sudah apply
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.orange.withOpacity(0.3)),
          ),
          child: Text(
            'Applied',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.orange,
            ),
          ),
        );
      
      case JobApplicationStatus.accepted:
        // Kondisi 3: Sudah diterima
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green.withOpacity(0.3)),
          ),
          child: Text(
            'Accepted',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.green,
            ),
          ),
        );
    }
  }

  Widget _buildGeneralResourceStatusIndicator(ResourceStatus status) {
    switch (status) {
      case ResourceStatus.notAdded:
        // Kondisi 1: Belum ditambahkan - tampilan normal dengan panah
        return Icon(
          Icons.arrow_forward_ios,
          size: 12,
          color: AppColors.textSecondary.withOpacity(0.5),
        );
      
      case ResourceStatus.added:
        // Kondisi 2: Sudah ditambahkan tapi belum dimulai
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.withOpacity(0.3)),
          ),
          child: Text(
            'Added',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.blue,
            ),
          ),
        );
      
      case ResourceStatus.inProgress:
        // Kondisi 3: Sedang dikerjakan/on progress
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.orange.withOpacity(0.3)),
          ),
          child: Text(
            'In Progress',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.orange,
            ),
          ),
        );
      
      case ResourceStatus.completed:
        // Kondisi 4: Sudah selesai
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green.withOpacity(0.3)),
          ),
          child: Text(
            'Completed',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.green,
            ),
          ),
        );
    }
  }
}
