import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../styles/app_colors.dart';
import '../controllers/cv_analysis_controller.dart';

class CvAnalysisView extends GetView<CvAnalysisController> {
  const CvAnalysisView({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Obx(() {
                if (controller.hasError.value) {
                  return _buildErrorView();
                } else if (controller.isCompleted) {
                  return _buildResults();
                } else {
                  return _buildProcessing();
                }
              }),
            ),
          ],
        ),
      ),
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
      return ListView(
        padding: const EdgeInsets.all(25),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text('Score: ${result['overallScore']}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(result['profileSummary'] ?? ''),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Strengths:', style: TextStyle(fontWeight: FontWeight.bold)),
                  ...List<String>.from(result['strengths'] ?? []).map((s) => Text('• $s')),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Improvements:', style: TextStyle(fontWeight: FontWeight.bold)),
                  ...List<String>.from(result['improvements'] ?? []).map((s) => Text('• $s')),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}
