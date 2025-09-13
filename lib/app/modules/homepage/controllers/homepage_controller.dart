import 'package:get/get.dart';
import '../../../widgets/personalization_popup.dart';
import '../../../services/firestore_service.dart';

class HomepageController extends GetxController {
  final count = 0.obs;
  final activeIndex = 0.obs;
  
  @override
  void onInit() {
    super.onInit();
    print('🔍 DEBUG: HomepageController onInit() called');
  }

  @override
  void onReady() {
    super.onReady();
    print('🔍 DEBUG: HomepageController onReady() called');
    _checkAndShowPersonalizationPopup();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  // Check if personalization popup should be shown
  Future<void> _checkAndShowPersonalizationPopup() async {
    print('🔍 DEBUG: _checkAndShowPersonalizationPopup() method called');
    
    // Wait a bit for the page to fully load
    await Future.delayed(const Duration(milliseconds: 500));
    
    try {
      // Check if user profile is complete
      final firestoreService = FirestoreService.instance;
      final profileData = await firestoreService.getUserProfile();
      
      print('🔍 DEBUG: Profile data: $profileData');
      
      // If profile exists and is complete, don't show popup
      if (profileData != null && profileData['isProfileComplete'] == true) {
        print('ℹ️ DEBUG: Profile is complete, not showing popup');
        return;
      }
      
      // If profile doesn't exist or is not complete, show popup
      // This ensures new users always see the popup
      if (profileData == null || profileData['isProfileComplete'] != true) {
        print('✅ DEBUG: Profile incomplete or missing, showing personalization popup');
        PersonalizationPopup.show();
      }
    } catch (e) {
      print('⚠️ DEBUG: Error checking profile status: $e');
      // On error, show popup for safety (better to show than not show for new users)
      print('✅ DEBUG: Showing popup as fallback due to error');
      PersonalizationPopup.show();
    }
  }
}
