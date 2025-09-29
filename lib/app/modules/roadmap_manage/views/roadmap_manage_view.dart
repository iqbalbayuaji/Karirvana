import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../styles/app_colors.dart';
import '../controllers/roadmap_manage_controller.dart';

class RoadmapManageView extends GetView<RoadmapManageController> {
  RoadmapManageView({super.key});
  
  // State untuk mengontrol expand/collapse setiap step
  final RxList<bool> expandedSteps = <bool>[false, false, false, false, false].obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header (unchanged)
            Padding(
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
              ),
            
            // Content Area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: _buildContent(),
              ),
            ),
          ],
        ),
      )
    );
  }

  Widget _buildContent() {
    // For now, show roadmap list directly to display examples
    // Empty state handling commented out for demo
    // if (controller.roadmaps.isEmpty) {
    //   return _buildEmptyState();
    // } else {
      return _buildRoadmapList();
    // }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(60),
            ),
            child: Icon(
              Icons.route_outlined,
              size: 60,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Belum Ada Roadmap',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'Montserrat',
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Buat roadmap karir pertama Anda\ndengan bantuan AI',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Montserrat',
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 32),
          GestureDetector(
            onTap: () {
              // Navigate to career_roadmap page
              // Get.toNamed(Routes.CAREER_ROADMAP);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Buat Roadmap dengan AI',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Montserrat',
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoadmapList() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Single Roadmap Header
          _buildRoadmap(),
          const SizedBox(height: 20),
          
        ],
      ),
    );
  }

  Widget _buildRoadmap() {
    return Container(
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and overall progress
          Center(
            child: const Expanded(
              child: Text(
                'Frontend Developer Roadmap',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Montserrat',
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Overall progress
          _buildProgressIndicator(0.4), // 2 out of 5 steps completed
          
          const SizedBox(height: 17),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                Icons.edit_outlined,
                color: AppColors.primary,
              ),
              const SizedBox(
                width: 8,
              ),
              Icon(
                Icons.delete_outlined,
                color: Colors.red[400],
              )
            ],
          ),
          const SizedBox(height: 25),
          _buildSequentialSteps(), 
        ],
      ),
    );
  }

  Widget _buildSequentialSteps() {
    final steps = [
      {
        'title': 'Belajar HTML & CSS',
        'status': 'completed',
        'courses': 3,
        'certificates': 1,
      },
      {
        'title': 'Belajar JavaScript',
        'status': 'completed',
        'courses': 4,
        'certificates': 2,
      },
      {
        'title': 'Belajar React',
        'status': 'in_progress',
        'courses': 5,
        'certificates': 2,
      },
      {
        'title': 'Membuat Portfolio',
        'status': 'not_started',
        'courses': 2,
        'certificates': 0,
        'extras': ['CV Building', 'GitHub Portfolio']
      },
      {
        'title': 'Melamar Pekerjaan',
        'status': 'not_started',
        'courses': 1,
        'certificates': 0,
        'extras': ['Interview Practice', 'Job Recommendations']
      },
    ];

    return Column(
      children: List.generate(steps.length, (index) {
        final step = steps[index];
        
        return Column(
          children: [
            _buildStepItem(step, index),
            if (index < steps.length - 1) const SizedBox(height: 16), // Spacing between steps
          ],
        );
      }),
    );
  }

  Widget _buildStepItem(Map<String, dynamic> step, int index) {
    return Obx(() {
      final isExpanded = expandedSteps[index];
      
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Main step container
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Main step content
                  GestureDetector(
                    onTap: () {
                      // Toggle expand/collapse
                      expandedSteps[index] = !expandedSteps[index];
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          // Step number and status indicator
                          _buildStepIndicator(index + 1, step['status']),
                          
                          const SizedBox(width: 16),
                          
                          // Step content
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  step['title'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Montserrat',
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                _buildStepChips(step),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Expanded content (recommendations) with integrated bottom extension
                  if (isExpanded) _buildExpandedContent(step),
                ],
              ),
            ),
            
            // Tonjolan kecil di bagian bawah (selalu ada sebagai visual hint)
            Positioned(
              bottom: -6,
              left: 7,
              right: 7,
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  color: isExpanded 
                      ? AppColors.surfaceVariant 
                      : AppColors.surfaceVariant,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isExpanded 
                          ? AppColors.surfaceVariant.withOpacity(0.3)
                          : AppColors.surfaceVariant.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildStepIndicator(int stepNumber, String status) {
    Color backgroundColor;
    Color borderColor;
    Widget child;
    
    switch (status) {
      case 'completed':
        backgroundColor = const Color(0xFF4CAF50);
        borderColor = const Color(0xFF4CAF50);
        child = const Icon(Icons.check, color: Colors.white, size: 16);
        break;
      case 'in_progress':
        backgroundColor = const Color(0xFFFF9800);
        borderColor = const Color(0xFFFF9800);
        child = Text(
          stepNumber.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        );
        break;
      default: // not_started
        backgroundColor = Colors.white;
        borderColor = AppColors.outline;
        child = Text(
          stepNumber.toString(),
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        );
    }
    
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor, width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(child: child),
    );
  }


  Widget _buildStepChips(Map<String, dynamic> step) {
    List<Widget> chips = [];
    
    if (step['courses'] > 0) {
      chips.add(_buildChip('${step['courses']} Course', Icons.play_circle_outline, Colors.blue));
    }
    
    if (step['certificates'] > 0) {
      chips.add(_buildChip('${step['certificates']} Sertifikat', Icons.verified_outlined, Colors.green));
    }
    
    if (step['extras'] != null) {
      for (String extra in step['extras']) {
        chips.add(_buildChip(extra, Icons.star_outline, Colors.orange));
      }
    }
    
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: chips,
    );
  }

  Widget _buildExpandedContent(Map<String, dynamic> step) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rekomendasi Detail',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: 'Montserrat',
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          
          // Course recommendations
          if (step['courses'] > 0) ...[
            _buildRecommendationSection('Course', Icons.play_circle_outline, Colors.blue, [
              'HTML & CSS Fundamentals',
              'Responsive Web Design',
              'CSS Grid & Flexbox',
            ]),
            const SizedBox(height: 12),
          ],
          
          // Certificate recommendations
          if (step['certificates'] > 0) ...[
            _buildRecommendationSection('Sertifikat', Icons.verified_outlined, Colors.green, [
              'Web Development Certificate',
            ]),
            const SizedBox(height: 12),
          ],
          
          // Extra recommendations
          if (step['extras'] != null) ...[
            _buildRecommendationSection('Lainnya', Icons.star_outline, Colors.orange, step['extras']),
          ],
        ],
      ),
    );
  }

  Widget _buildRecommendationSection(String title, IconData icon, Color color, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                fontFamily: 'Montserrat',
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...items.map((item) => Padding(
          padding: const EdgeInsets.only(left: 22, bottom: 4),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'Montserrat',
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        )).toList(),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    Color backgroundColor;
    Color textColor;
    
    switch (status.toLowerCase()) {
      case 'completed':
        backgroundColor = const Color(0xFF4CAF50).withOpacity(0.2);
        textColor = const Color(0xFF4CAF50);
        break;
      case 'in progress':
        backgroundColor = const Color(0xFFFF9800).withOpacity(0.2);
        textColor = const Color(0xFFFF9800);
        break;
      default: // Not Started
        backgroundColor = AppColors.textSecondary.withOpacity(0.2);
        textColor = AppColors.textSecondary;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          fontFamily: 'Montserrat',
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Progress',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                fontFamily: 'Montserrat',
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                fontFamily: 'Montserrat',
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: AppColors.outline.withOpacity(0.3),
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          minHeight: 6,
          borderRadius: BorderRadius.circular(6),
        ),
      ],
    );
  }

  Widget _buildRecommendationChips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Rekomendasi',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            fontFamily: 'Montserrat',
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildChip('3 Course', Icons.play_circle_outline, Colors.blue),
            _buildChip('2 Sertifikat', Icons.verified_outlined, Colors.green),
          ],
        ),
      ],
    );
  }

  Widget _buildChip(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              fontFamily: 'Montserrat',
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              // Generate schedule from roadmap
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.schedule,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Buat Jadwal',
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
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () {
            // Edit roadmap
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.outline),
            ),
            child: const Icon(
              Icons.edit_outlined,
              size: 16,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () {
            // Delete roadmap
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.withOpacity(0.3)),
            ),
            child: const Icon(
              Icons.delete_outline,
              size: 16,
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }
}
