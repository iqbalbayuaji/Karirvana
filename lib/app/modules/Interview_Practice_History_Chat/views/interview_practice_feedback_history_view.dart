import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pie_chart/pie_chart.dart' as pie;

import '../../../styles/app_colors.dart';
import '../../Interview_Practice_Feedback/controllers/interview_practice_feedback_controller.dart';

class InterviewPracticeFeedbackHistoryView
    extends GetView<InterviewPracticeFeedbackController> {
  const InterviewPracticeFeedbackHistoryView({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 30, 0, 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Icon(
                            Icons.arrow_back,
                            color: AppColors.textPrimary,
                            size: 27,
                          ),
                        ),
                        Text(
                          "Feedback Interview",
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 25,)
                      ],
                    ),
                  ),
                  // Overall Performance Section
                  _buildOverallPerformanceSection(),
                  
                  const SizedBox(height: 25),
                  
                  // Detailed Performance Section
                  _buildDetailedPerformanceSection(),
                  
                  const SizedBox(height: 20),
                  
                  // Improvement & Strengths Section
                  _buildImprovementSection(),
                  
                  const SizedBox(height: 20),
                  
                  // AI Insights Section
                  _buildAIInsightsSection(),
                  
                  const SizedBox(height: 20),
                  
                  // // Action Buttons
                  // _buildActionButtons(),
                ],
              ),
            ),
      ),
    );
  }

  Widget _buildOverallPerformanceSection() {
    return Obx(() {
      final dataMap = controller.performanceData;
      final colorList = controller.getPerformanceColors();
      final overallScore = controller.overallScore.value;

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            SizedBox(
              height: 150,
              child: pie.PieChart(
                dataMap: dataMap,
                colorList: colorList,
                initialAngleInDegree: 0,
                chartType: pie.ChartType.ring,
                ringStrokeWidth: 26,
                centerText: "$overallScore%",
                centerTextStyle: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Montserrat',
                  color: AppColors.textPrimary,
                ),
                legendOptions: const pie.LegendOptions(
                  showLegends: false,
                ),
                chartValuesOptions: const pie.ChartValuesOptions(
                  showChartValueBackground: false,
                  showChartValues: false,
                ),
              ),
            ),
            
            SizedBox(height: 30),
            // Overall Score
            Text(
              'Skor Keseluruhan: $overallScore/100',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'Montserrat',
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 15),
          ],
        ),
      );
    });
  }

  Widget _buildDetailedPerformanceSection() {
    return Obx(() {
      final detailedScores = controller.detailedScores;

      return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rincian Performa',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'Montserrat',
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          
          ...detailedScores.entries.map((entry) => _buildPerformanceBar(
            entry.key,
            entry.value,
            controller.getScoreColor(entry.value),
          )),
        ],
      ),
    );
    });
  }

  Widget _buildPerformanceBar(String label, int score, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Montserrat',
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '$score%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Montserrat',
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: score / 100,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImprovementSection() {
    return Obx(() {
      final strengths = controller.strengths;
      final improvements = controller.improvements;
      
      return Column(
        children: [
          // Strengths Section
          _buildExpandableSection(
            title: 'Yang Perlu Dipertahankan',
            icon: Icons.thumb_up,
            iconColor: Colors.green.shade400,
            items: strengths.map((item) => '✓  $item').toList(),
            itemColor: Colors.green.shade400,
          ),
          
          const SizedBox(height: 16),
          
          // Improvement Section
          _buildExpandableSection(
            title: 'Yang Perlu Diperbaiki',
            icon: Icons.trending_up,
            iconColor: Colors.orange.shade400,
            items: improvements.map((item) => '•  $item').toList(),
            itemColor: Colors.orange.shade400,
          ),
        ],
      );
    });
  }

  Widget _buildExpandableSection({
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<String> items,
    required Color itemColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
          childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          leading: Icon(
            icon,
            color: iconColor,
            size: 20,
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Montserrat',
              color: AppColors.textPrimary,
            ),
          ),
          iconColor: AppColors.textPrimary,
          collapsedIconColor: AppColors.textPrimary,
          children: items.map((item) => 
            Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: _buildFeedbackItem(item, itemColor),
            )
          ).toList(),
        ),
      ),
    );
  }

  Widget _buildFeedbackItem(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontFamily: 'Montserrat',
          color: AppColors.textSecondary,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Practice Again Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // Navigate back to interview practice
              Get.offAllNamed('/interview-practice');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Latihan Lagi',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Montserrat',
                color: AppColors.textOnPrimary,
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Back to Home Button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              // Navigate back to home
              Get.offAllNamed('/homepage');
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Kembali ke Beranda',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Montserrat',
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAIInsightsSection() {
    return Obx(() {
      final detailedAnalysis = controller.detailedAnalysis.value;
      final recommendedActions = controller.recommendedActions;
      
      // Only show AI insights if they exist
      if (detailedAnalysis.isEmpty && recommendedActions.isEmpty) {
        return const SizedBox.shrink();
      }
      
      return Column(
        children: [
          // AI Analysis Section
          if (detailedAnalysis.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.psychology_outlined,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Analisis AI',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Montserrat',
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    detailedAnalysis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          
          // Spacing between sections
          if (detailedAnalysis.isNotEmpty && recommendedActions.isNotEmpty)
            const SizedBox(height: 16),
          
          // Recommended Actions Section
          if (recommendedActions.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        color: Colors.amber.shade600,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Rekomendasi Aksi',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Montserrat',
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...recommendedActions.map((action) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 6, right: 8),
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.amber.shade600,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            action,
                            style: const TextStyle(
                              fontSize: 14,
                              fontFamily: 'Montserrat',
                              color: AppColors.textSecondary,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )).toList(),
                ],
              ),
            ),
        ],
      );
    });
  }
}
