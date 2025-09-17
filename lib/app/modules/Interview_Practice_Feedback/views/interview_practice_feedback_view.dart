import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pie_chart/pie_chart.dart' as pie;
import '../../../styles/app_colors.dart';
import '../controllers/interview_practice_feedback_controller.dart';

class InterviewPracticeFeedbackView
    extends GetView<InterviewPracticeFeedbackController> {
  const InterviewPracticeFeedbackView({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Feedback Interview',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Feedback Interview",
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: AppColors.textPrimary,
              ),
            ),
            // Overall Performance Section
            _buildOverallPerformanceSection(),
            
            const SizedBox(height: 32),
            
            // Detailed Performance Section
            _buildDetailedPerformanceSection(),
            
            const SizedBox(height: 32),
            
            // Improvement & Strengths Section
            _buildImprovementSection(),
            
            const SizedBox(height: 32),
            
            // Action Buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildOverallPerformanceSection() {
    // Sample data - will be replaced with actual data from controller
    final Map<String, double> dataMap = {
      "Excellent": 35,
      "Good": 40,
      "Needs Improvement": 25,
    };

    final colorList = <Color>[
      AppColors.primary,
      Colors.green.shade400,
      Colors.orange.shade400,
    ];

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
            'Performa Keseluruhan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          
          // Pie Chart
          SizedBox(
            height: 200,
            child: pie.PieChart(
              dataMap: dataMap,
              animationDuration: const Duration(milliseconds: 800),
              chartLegendSpacing: 32,
              chartRadius: MediaQuery.of(Get.context!).size.width / 3.2,
              colorList: colorList,
              initialAngleInDegree: 0,
              chartType: pie.ChartType.ring,
              ringStrokeWidth: 32,
              centerText: "75%",
              centerTextStyle: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
                color: AppColors.textPrimary,
              ),
              legendOptions: const pie.LegendOptions(
                showLegendsInRow: false,
                legendPosition: pie.LegendPosition.right,
                showLegends: true,
                legendTextStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Montserrat',
                  fontSize: 12,
                ),
              ),
              chartValuesOptions: const pie.ChartValuesOptions(
                showChartValueBackground: false,
                showChartValues: false,
                showChartValuesInPercentage: true,
                showChartValuesOutside: false,
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Overall Score
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.star,
                  color: AppColors.primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Skor Keseluruhan: 75/100',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Montserrat',
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedPerformanceSection() {
    // Sample performance data
    final performanceData = [
      {'label': 'Kelancaran Berbicara', 'score': 80, 'color': Colors.blue.shade400},
      {'label': 'Kepercayaan Diri', 'score': 70, 'color': Colors.green.shade400},
      {'label': 'Durasi Berbicara', 'score': 85, 'color': Colors.purple.shade400},
      {'label': 'Power Words Usage', 'score': 60, 'color': Colors.orange.shade400},
      {'label': 'Struktur Jawaban', 'score': 75, 'color': Colors.red.shade400},
    ];

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
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          
          ...performanceData.map((data) => _buildPerformanceBar(
            data['label'] as String,
            data['score'] as int,
            data['color'] as Color,
          )),
        ],
      ),
    );
  }

  Widget _buildPerformanceBar(String label, int score, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
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
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Montserrat',
                  color: color,
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
    return Column(
      children: [
        // Strengths Section
        Container(
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
                    Icons.thumb_up,
                    color: Colors.green.shade400,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Yang Perlu Dipertahankan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              _buildFeedbackItem(
                '✓ Durasi berbicara sudah optimal dan tidak terlalu panjang',
                Colors.green.shade400,
              ),
              _buildFeedbackItem(
                '✓ Struktur jawaban cukup terorganisir dengan baik',
                Colors.green.shade400,
              ),
              _buildFeedbackItem(
                '✓ Penggunaan bahasa formal sudah tepat',
                Colors.green.shade400,
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Improvement Section
        Container(
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
                    Icons.trending_up,
                    color: Colors.orange.shade400,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Yang Perlu Diperbaiki',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              _buildFeedbackItem(
                '• Tingkatkan kepercayaan diri dengan berlatih lebih sering',
                Colors.orange.shade400,
              ),
              _buildFeedbackItem(
                '• Gunakan lebih banyak power words untuk memperkuat jawaban',
                Colors.orange.shade400,
              ),
              _buildFeedbackItem(
                '• Kurangi penggunaan filler words seperti "ehm", "anu"',
                Colors.orange.shade400,
              ),
            ],
          ),
        ),
      ],
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
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              // Navigate back to practice setup
              Get.back();
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
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
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Back to Home Button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton(
            onPressed: () {
              // Navigate to home
              Get.offAllNamed('/homepage');
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.outline),
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
}
