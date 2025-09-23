import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pie_chart/pie_chart.dart' as pie;
import '../../../styles/app_colors.dart';
import '../controllers/cv_analysis_controller.dart';

class CvAnalysisView extends GetView<CvAnalysisController> {
  const CvAnalysisView({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        if (controller.hasError.value) {
          return _buildErrorView();
        } else if (controller.isCompleted) {
          return _buildResults();
        } else {
          return _buildProcessing();
        }
      }),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: Row(
        children: [
          GestureDetector(
            onTap: controller.goBack,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.outline),
              ),
              child: const Icon(Icons.arrow_back, size: 20),
            ),
          ),
          const SizedBox(width: 20),
          const Text("Analisis CV", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildProcessing() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 20),
          Obx(() => Text(controller.currentStatus, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, size: 60, color: Colors.red),
          const SizedBox(height: 20),
          Text(controller.errorMessage.value),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: controller.retryAnalysis,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildResults() {
    return Obx(() {
      final result = controller.analysisResult.value!;
      return SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 30, 0, 25),
              child: Center(
                child: Text(
                  "Analisis CV",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
            
            // Overall Performance Section with Pie Chart
            _buildOverallPerformanceSection(result),
            
            const SizedBox(height: 25),
            
            // Detailed Performance Section
            _buildDetailedPerformanceSection(result),
            
            const SizedBox(height: 20),
            
            // Improvement & Strengths Section
            _buildImprovementSection(result),
            
            const SizedBox(height: 20),
            
            
            // Action Buttons
            _buildActionButtons(),
          ],
        ),
      );
    });
  }

  Widget _buildOverallPerformanceSection(Map<String, dynamic> result) {
    final overallScore = result['overallScore'] ?? 0;
    final dataMap = <String, double>{
      'Score': overallScore.toDouble(),
      'Remaining': (100 - overallScore).toDouble(),
    };
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SizedBox(height: 20),
          SizedBox(
            height: 150,
            child: pie.PieChart(
              dataMap: dataMap,
              colorList: [Color(0xFF6366F1), Color(0xFFE0E7FF)],
              chartType: pie.ChartType.ring,
              ringStrokeWidth: 26,
              centerText: "$overallScore%",
              centerTextStyle: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Montserrat',
                  color: AppColors.textPrimary,
                ),
              legendOptions: const pie.LegendOptions(showLegends: false),
              chartValuesOptions: const pie.ChartValuesOptions(
                  showChartValueBackground: false,
                  showChartValues: false,
                ),
            ),
          ),
          SizedBox(height: 30),
          Text('Skor Keseluruhan: $overallScore/100', 
               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildDetailedPerformanceSection(Map<String, dynamic> result) {
    // Extract detailed scores from result
    final Map<String, int> detailedScores = {};
    
    // Add available scores from result - using common CV analysis categories
    detailedScores['Pengalaman Kerja'] = (result['experienceScore'] ?? 75);
    detailedScores['Keahlian Teknis'] = (result['technicalSkillsScore'] ?? 80);
    detailedScores['Presentasi CV'] = (result['presentationScore'] ?? 85);

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
            _getScoreColor(entry.value),
          )),
        ],
      ),
    );
  }

  Widget _buildImprovementSection(Map<String, dynamic> result) {
    final strengths = List<String>.from(result['strengths'] ?? []);
    final improvements = List<String>.from(result['improvements'] ?? []);
    
    return Column(
      children: [
        _buildExpandableSection('Kekuatan', Icons.thumb_up, Colors.green, strengths),
        const SizedBox(height: 16),
        _buildExpandableSection('Yang Perlu Diperbaiki', Icons.trending_up, Colors.orange, improvements),
      ],
    );
  }

  Widget _buildExpandableSection(String title, IconData icon, Color color, List<String> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10)],
      ),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
          childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          leading: Icon(icon, color: color, size: 20),
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
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6, right: 8),
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item,
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
            )
          ).toList(),
        ),
      ),
    );
  }

  Widget _buildAIInsightsSection(Map<String, dynamic> result) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.psychology_outlined, color: AppColors.primary),
              const SizedBox(width: 8),
              const Text('Analisis AI', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 12),
          Text('Analisis CV telah selesai dengan skor ${result['overallScore']}%'),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Kembali', style: TextStyle(fontSize: 16, color: Colors.white)),
          ),
        ),
      ],
    );
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

  Color _getScoreColor(int score) {
    if (score >= 80) return Colors.green.shade400;
    if (score >= 60) return Colors.orange.shade400;
    return Colors.red.shade400;
  }
}
