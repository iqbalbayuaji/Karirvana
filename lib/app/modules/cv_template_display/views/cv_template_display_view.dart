import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../styles/app_colors.dart';
import '../controllers/cv_template_display_controller.dart';

class CvTemplateDisplayView extends GetView<CvTemplateDisplayController> {
  const CvTemplateDisplayView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Template CV'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Obx(() => _buildContent()),
    );
  }

  Widget _buildContent() {
    if (controller.cvData.value == null) {
      return const Center(child: Text('Data tidak ditemukan'));
    }

    final cvData = controller.cvData.value!;
    final personalInfo = cvData['personalInfo'] ?? {};

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Success Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              children: [
                Icon(Icons.check_circle, color: Colors.white, size: 40),
                SizedBox(height: 8),
                Text(
                  'Template CV Berhasil Dibuat!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'File PDF telah tersimpan di folder Downloads',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // CV Preview
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    personalInfo['fullName'] ?? 'Nama Lengkap',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(personalInfo['title'] ?? 'Posisi'),
                  const SizedBox(height: 8),
                  Text('Email: ${personalInfo['email'] ?? 'N/A'}'),
                  Text('Phone: ${personalInfo['phone'] ?? 'N/A'}'),
                  
                  const SizedBox(height: 16),
                  const Text('Ringkasan:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(cvData['summary'] ?? 'N/A'),
                  
                  const SizedBox(height: 16),
                  const Text('Keahlian:', style: TextStyle(fontWeight: FontWeight.bold)),
                  ...((cvData['skills'] as List?)?.map((skill) => Text('• $skill')) ?? []),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Action Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: controller.openPDF,
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text('Buka PDF'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
