import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../styles/app_colors.dart';
import '../../roadmap_manage/models/roadmap_models.dart';

class RoadmapDisplayWidget extends StatelessWidget {
  final String roadmapTitle;
  final String roadmapDescription;
  final List<RoadmapMainStep> steps;
  final RxList<String> expandedSteps;
  final RxList<String> expandedSubSteps;
  final VoidCallback onSave;
  final VoidCallback onRegenerate;

  const RoadmapDisplayWidget({
    super.key,
    required this.roadmapTitle,
    required this.roadmapDescription,
    required this.steps,
    required this.expandedSteps,
    required this.expandedSubSteps,
    required this.onSave,
    required this.onRegenerate,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Roadmap Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.route,
                      color: AppColors.textOnPrimary,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        roadmapTitle,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Montserrat',
                          color: AppColors.textOnPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                if (roadmapDescription.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    roadmapDescription,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      color: AppColors.textOnPrimary.withOpacity(0.9),
                      height: 1.4,
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Roadmap Steps
          ...steps.asMap().entries.map((entry) {
            final index = entry.key;
            final step = entry.value;
            final isLastStep = index == steps.length - 1;
            
            return _buildMainStepCard(step, index + 1, isLastStep, screenWidth);
          }).toList(),
          
          const SizedBox(height: 24),
          
          // Action Buttons
          _buildActionButtons(screenWidth),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildMainStepCard(RoadmapMainStep step, int stepNumber, bool isLastStep, double screenWidth) {
    return Obx(() {
      final isExpanded = expandedSteps.contains(step.id);
      
      return Column(
        children: [
          // Main Step Card
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: step.isCompleted 
                  ? Colors.green.withOpacity(0.5)
                  : AppColors.outline.withOpacity(0.3),
                width: step.isCompleted ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => _toggleStepExpansion(step.id),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Step Header
                      Row(
                        children: [
                          // Step Number
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: step.isCompleted 
                                  ? Colors.green 
                                  : AppColors.primary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: step.isCompleted
                                  ? Icon(
                                      Icons.check,
                                      color: AppColors.textOnPrimary,
                                      size: 20,
                                    )
                                  : Text(
                                      stepNumber.toString(),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Montserrat',
                                        color: AppColors.textOnPrimary,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          
                          // Step Content
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  step.title,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Montserrat',
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  step.description,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Montserrat',
                                    color: AppColors.textSecondary,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.schedule,
                                        size: 16,
                                        color: AppColors.primary,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        step.estimatedDuration,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Montserrat',
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // Expand Icon
                          Icon(
                            isExpanded ? Icons.expand_less : Icons.expand_more,
                            color: AppColors.textSecondary,
                            size: 24,
                          ),
                        ],
                      ),
                      
                      // Sub-steps (when expanded)
                      if (isExpanded && step.subSteps.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        ...step.subSteps.map((subStep) => _buildSubStepCard(step.id, subStep, screenWidth)).toList(),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Connection Line (except for last step)
          if (!isLastStep)
            Container(
              width: 2,
              height: 20,
              margin: const EdgeInsets.only(left: 40),
              decoration: BoxDecoration(
                color: AppColors.outline.withOpacity(0.3),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
        ],
      );
    });
  }

  Widget _buildSubStepCard(String mainStepId, RoadmapSubStep subStep, double screenWidth) {
    return Obx(() {
      final isExpanded = expandedSubSteps.contains(subStep.id);
      
      return Container(
        margin: const EdgeInsets.only(bottom: 12, left: 20),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: subStep.isCompleted 
                ? Colors.green.withOpacity(0.3)
                : AppColors.outline.withOpacity(0.2),
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _toggleSubStepExpansion(subStep.id),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sub-step Header
                  Row(
                    children: [
                      // Sub-step Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              subStep.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Montserrat',
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              subStep.description,
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'Montserrat',
                                color: AppColors.textSecondary,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Duration and Expand Icon
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.outline.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              subStep.estimatedDuration,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Montserrat',
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Icon(
                            isExpanded ? Icons.expand_less : Icons.expand_more,
                            color: AppColors.textSecondary,
                            size: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  // Resources (when expanded)
                  if (isExpanded && subStep.resources.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Rekomendasi:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Montserrat',
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...subStep.resources.map((resource) => _buildResourceItem(resource)).toList(),
                  ],
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildResourceItem(RoadmapResource resource) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.outline.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          // Resource Icon
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: _getResourceColor(resource.type).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getResourceIcon(resource.type),
              size: 18,
              color: _getResourceColor(resource.type),
            ),
          ),
          const SizedBox(width: 12),
          
          // Resource Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  resource.title,
                  style: TextStyle(
                    fontSize: 14,
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
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Montserrat',
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (resource.location != null) ...[
                      Text(
                        ' • ${resource.location}',
                        style: TextStyle(
                          fontSize: 12,
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
        ],
      ),
    );
  }

  Widget _buildActionButtons(double screenWidth) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Apakah roadmap ini sesuai dengan kebutuhan Anda?',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'Montserrat',
              color: AppColors.textOnPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // Save Button
              GestureDetector(
                onTap: onSave,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Icon(
                        CupertinoIcons.checkmark_alt,
                        color: AppColors.textOnPrimary,
                        size: 20,
                      ),
                    ),
                    Text(
                      'Simpan',
                      style: TextStyle(
                        color: AppColors.textOnPrimary,
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(width: 12),
              
              // Regenerate Button
              GestureDetector(
                onTap: onRegenerate,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Icon(
                        CupertinoIcons.xmark,
                        color: AppColors.textOnPrimary,
                        size: 20,
                      ),
                    ),
                    Text(
                      'Buat Ulang',
                      style: TextStyle(
                        color: AppColors.textOnPrimary,
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _toggleStepExpansion(String stepId) {
    if (expandedSteps.contains(stepId)) {
      expandedSteps.remove(stepId);
    } else {
      expandedSteps.add(stepId);
    }
  }

  void _toggleSubStepExpansion(String subStepId) {
    if (expandedSubSteps.contains(subStepId)) {
      expandedSubSteps.remove(subStepId);
    } else {
      expandedSubSteps.add(subStepId);
    }
  }

  // Get resource icon (consistent with roadmap_manage)
  IconData _getResourceIcon(String type) {
    switch (type) {
      case 'course':
        return Icons.play_circle_outline;
      case 'certificate':
        return Icons.verified_outlined;
      case 'job':
        return Icons.work_outline;
      case 'tool':
        return Icons.build_outlined;
      default:
        return Icons.link;
    }
  }

  // Get resource color (consistent with roadmap_manage)
  Color _getResourceColor(String type) {
    switch (type) {
      case 'course':
        return AppColors.primary;
      case 'certificate':
        return Colors.green;
      case 'job':
        return Colors.orange;
      case 'tool':
        return AppColors.tertiary;
      default:
        return AppColors.textSecondary;
    }
  }
}
