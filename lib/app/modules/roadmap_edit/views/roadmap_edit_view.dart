import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../styles/app_colors.dart';
import '../controllers/roadmap_edit_controller.dart';
import '../../roadmap_manage/models/roadmap_models.dart';

class RoadmapEditView extends GetView<RoadmapEditController> {
  const RoadmapEditView({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRoadmapCard(),
                    const SizedBox(height: 20),
                    _buildRoadmapSteps(),
                    const SizedBox(height: 100), // Space for bottom button
                  ],
                ),
              ),
            ),
            _buildBottomSaveButton(),
          ],
        ),
      ),
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
            'Edit Roadmap Karir',
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

  Widget _buildRoadmapCard() {
    return Obx(() => Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.roadmapTitle.value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Montserrat',
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '${(controller.overallProgress * 100).toInt()}% Selesai',
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'Montserrat',
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 7),
                Obx(() => LinearProgressIndicator(
                  value: controller.overallProgress,
                  backgroundColor: AppColors.primaryContainer,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(16),
                )),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              controller.editRoadmapTitle();
            },
            child: const Icon(
              Icons.edit_outlined,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    ));
  }

  Widget _buildRoadmapSteps() {
    return Obx(() => Column(
      children: controller.roadmapSteps.asMap().entries.map((entry) {
        int index = entry.key;
        RoadmapMainStep step = entry.value;
        return _buildMainStepCard(step, index);
      }).toList(),
    ));
  }

  Widget _buildMainStepCard(RoadmapMainStep mainStep, int index) {
    bool isExpanded = controller.expandedSteps.contains(mainStep.id);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          // Main step header
          InkWell(
            onTap: () => controller.toggleMainStep(mainStep.id),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Step number
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: mainStep.isCompleted ? AppColors.primary : AppColors.outline.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: mainStep.isCompleted ? Colors.white : AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Step content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mainStep.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Montserrat',
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],
                    ),
                  ),
                  // Delete step button
                  GestureDetector(
                    onTap: () => controller.deleteMainStep(mainStep.id),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Icon(
                        Icons.delete_outline,
                        color: Colors.red[400],
                        size: 20,
                      ),
                    ),
                  ),
                  // Expand/collapse icon
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: AppColors.textSecondary,
                    size: 24,
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
                children: [
                  ...mainStep.subSteps.map((subStep) => _buildSubStepCard(subStep, mainStep.id)),
                  const SizedBox(height: 8),
                  // Add sub-step button
                  GestureDetector(
                    onTap: () => controller.addSubStep(mainStep.id),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, color: AppColors.primary, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Tambah Sub-Step',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSubStepCard(RoadmapSubStep subStep, String mainStepId) {
    bool isExpanded = controller.expandedSubSteps.contains(subStep.id);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.outline.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          // Sub-step header
          InkWell(
            onTap: () => controller.toggleSubStep(subStep.id),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // Completion indicator
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: subStep.isCompleted ? Colors.green : Colors.transparent,
                      border: Border.all(
                        color: subStep.isCompleted ? Colors.green : AppColors.outline,
                        width: 2,
                      ),
                    ),
                    child: subStep.isCompleted
                        ? const Icon(Icons.check, color: Colors.white, size: 12)
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
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Montserrat',
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subStep.description,
                          style: const TextStyle(
                            fontSize: 11,
                            fontFamily: 'Montserrat',
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Delete sub-step button
                  GestureDetector(
                    onTap: () => controller.deleteSubStep(mainStepId, subStep.id),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        Icons.delete_outline,
                        color: Colors.red[400],
                        size: 20,
                      ),
                    ),
                  ),
                  // Expand/collapse icon for resources
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: AppColors.textSecondary,
                    size: 25,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Rekomendasi',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Montserrat',
                          color: AppColors.textSecondary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => controller.addResource(mainStepId, subStep.id),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add, color: AppColors.primary, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                'Add',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...subStep.resources.map((resource) => _buildResourceItem(resource, mainStepId, subStep.id)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildResourceItem(RoadmapResource resource, String mainStepId, String subStepId) {
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
        border: Border.all(color: AppColors.outline.withOpacity(0.2)),
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
                Text(
                  resource.provider,
                  style: const TextStyle(
                    fontSize: 10,
                    fontFamily: 'Montserrat',
                    color: AppColors.textSecondary,
                  ),
                ),
                if (resource.location != null) ...[
                  Text(
                    resource.location!,
                    style: const TextStyle(
                      fontSize: 10,
                      fontFamily: 'Montserrat',
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Edit resource button
          GestureDetector(
            onTap: () => controller.editResource(mainStepId, subStepId, resource),
            child: Container(
              padding: const EdgeInsets.all(4),
              child: Icon(
                Icons.edit_outlined,
                color: AppColors.textSecondary,
                size: 20,
              ),
            ),
          ),
          // Delete resource button
          GestureDetector(
            onTap: () => controller.deleteResource(mainStepId, subStepId, resource),
            child: Container(
              padding: const EdgeInsets.all(4),
              child: Icon(
                Icons.delete_outline,
                color: Colors.red[400],
                size: 20,
              ),
            ),
          ),
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
        return Icon(
          Icons.arrow_forward_ios,
          size: 12,
          color: AppColors.textSecondary.withOpacity(0.5),
        );
      
      case JobApplicationStatus.applied:
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
        return Icon(
          Icons.arrow_forward_ios,
          size: 12,
          color: AppColors.textSecondary.withOpacity(0.5),
        );
      
      case ResourceStatus.added:
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

  Widget _buildBottomSaveButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              controller.saveRoadmap();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Save Roadmap',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
                fontFamily: 'Montserrat',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
