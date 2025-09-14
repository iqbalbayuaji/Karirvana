import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../styles/app_colors.dart';
import '../services/firestore_service.dart';

class PersonalizationPopup {
  static void show() {
    final screenWidth = MediaQuery.of(Get.context!).size.width;
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'apakah Anda ingin mempersonalisasi akun?',
                      style: TextStyle(
                        fontSize: screenWidth * 0.045, // Responsive font size
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  SizedBox(
                    width: screenWidth * 0.2,
                  )
                ],
              ),
              const SizedBox(height: 40),
              
              // Buttons
              Column(
                children: [
                  // Continue Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        print('🔍 DEBUG: Continue button pressed');
                        try {
                          // Mark popup as seen in Firestore
                          final firestoreService = FirestoreService.instance;
                          await firestoreService.markPersonalizationPopupAsSeen();
                          print('✅ DEBUG: Popup marked as seen in Firestore');
                        } catch (e) {
                          print('⚠️ DEBUG: Firestore error in continue button: $e');
                          // Continue anyway
                        }
                        print('🔍 DEBUG: Closing popup and navigating to personalization');
                        Get.back();
                        Get.toNamed('/personalization');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Isi Sekarang',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Montserrat',
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 6),
                  // Skip Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () async {
                        print('🔍 DEBUG: Skip button pressed');
                        try {
                          // Mark popup as seen in Firestore
                          final firestoreService = FirestoreService.instance;
                          await firestoreService.markPersonalizationPopupAsSeen();
                          print('✅ DEBUG: Popup marked as seen in Firestore');
                        } catch (e) {
                          print('⚠️ DEBUG: Firestore error in skip button: $e');
                          // Continue anyway
                        }
                        print('🔍 DEBUG: Closing popup');
                        Get.back();
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.outline),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Nanti Saja',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Montserrat',
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
