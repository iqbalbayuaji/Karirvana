import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../styles/app_colors.dart';
import '../controllers/cv_assistant_controller.dart';

class DottedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;

  DottedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashWidth,
    required this.dashSpace,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(15),
      ));

    _drawDashedPath(canvas, path, paint);
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    final pathMetrics = path.computeMetrics();
    for (final pathMetric in pathMetrics) {
      double distance = 0.0;
      while (distance < pathMetric.length) {
        final extractPath = pathMetric.extractPath(distance, distance + dashWidth);
        canvas.drawPath(extractPath, paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class CvAssistantView extends GetView<CvAssistantController> {
  const CvAssistantView({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Column(
                    children: [
                      _buildUploadSection(),
                      const SizedBox(height: 15),
                      _buildTemplateSection(),
                      const SizedBox(height: 40), // Extra space for keyboard
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
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
                      Text(
                        "CV Assistant",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(width: 40)
                    ],
                  ),
    );
  }

  Widget _buildUploadSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
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
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Scan CV Anda',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Scan CV dan dapatkan analisis mendalam dari AI',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Montserrat',
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Obx(() => GestureDetector(
            onTap: controller.isUploading.value ? null : controller.pickAndUploadFile,
            child: CustomPaint(
              painter: DottedBorderPainter(
                color: AppColors.primary.withOpacity(0.4),
                strokeWidth: 2,
                dashWidth: 7,
                dashSpace: 5,
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: controller.isUploading.value
                  ? Column(
                      children: [
                        const CircularProgressIndicator(color: AppColors.primary),
                        const SizedBox(height: 15),
                        Text(
                          'Mengupload... ${(controller.uploadProgress.value * 100).toInt()}%',
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    )
                  : controller.uploadedFile.value != null
                    ? Column(
                        children: [
                          const Icon(CupertinoIcons.checkmark_circle_fill, 
                            color: Colors.green, size: 50),
                          const SizedBox(height: 15),
                          Text(
                            'File berhasil diupload!',
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            controller.uploadedFile.value!['fileName'],
                            style: const TextStyle(
                              fontSize: 12,
                              fontFamily: 'Montserrat',
                              color: AppColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )
                    : const Column(
                        children: [
                          Icon(CupertinoIcons.cloud_upload, color: AppColors.primary, size: 50),
                          SizedBox(height: 15),
                          Text(
                            'Pilih File CV ',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Format: PDF, DOCX',
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Montserrat',
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          )),
          const SizedBox(height: 20),
          Obx(() => SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: controller.uploadedFile.value != null 
                ? controller.navigateToScanPage 
                : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: controller.uploadedFile.value != null 
                  ? AppColors.primary 
                  : AppColors.primary.withOpacity(0.5),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "Scan CV",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Montserrat',
                  color: AppColors.textOnPrimary
                ),
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildTemplateSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
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
            'Buat Template CV Anda',
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Buat template CV secara custom dalam format PDF atau DOCX',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Montserrat',
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            minLines: 1,
            controller: controller.templatePromptController,
                decoration: InputDecoration(
                  // contentPadding: const EdgeInsets.all(10),
                  hintText: 'Buat template CV...',
                  hintStyle: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontFamily: 'Montserrat',
                  ),
                  prefixIcon: const Icon(
                          Icons.edit_document,
                          color: AppColors.textSecondary,
                          size: 20,
                        ),
                  border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(
                    color: AppColors.outline,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(
                    color: AppColors.outline,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 1,
                  ),
                ),
                filled: true,
                fillColor: AppColors.surface,
              ),
            ),
            const SizedBox(height: 15),
            Obx(() => SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.isGeneratingTemplate.value 
                    ? null 
                    : controller.generateCVTemplate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: controller.isGeneratingTemplate.value
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text('Sedang membuat template...'),
                        ],
                      )
                    : const Text(
                        'Buat Template CV',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textOnPrimary,
                        ),
                      ),
              ),
            )),
        ],
      ),
    );
  }
}
