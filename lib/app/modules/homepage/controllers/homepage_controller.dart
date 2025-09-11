import 'package:get/get.dart';
import '../../../widgets/personalization_popup.dart';

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
    print('🔍 DEBUG: Waiting 500ms for page to load...');
    await Future.delayed(const Duration(milliseconds: 500));
    print('🔍 DEBUG: Wait completed, checking popup conditions...');
    
    // For now, let's just show the popup directly to test if it works
    print('✅ DEBUG: Force showing personalization popup for testing');
    PersonalizationPopup.show();
    
    // Original logic commented out for debugging
    /*
    try {
      final hasBeenShown = await UserPreferencesService.hasPersonalizationPopupBeenShown();
      final isFirstTime = await UserPreferencesService.isFirstTimeUser();
      
      print('🔍 DEBUG: Popup check - hasBeenShown: $hasBeenShown, isFirstTime: $isFirstTime');
      
      // Show popup if it hasn't been shown before (regardless of first time status)
      // This ensures popup shows for newly registered users
      if (!hasBeenShown) {
        print('✅ DEBUG: Showing personalization popup');
        PersonalizationPopup.show();
      } else {
        print('ℹ️ DEBUG: Popup not shown - already been shown before');
      }
    } catch (e) {
      print('⚠️ DEBUG: SharedPreferences error in popup check: $e');
      // If SharedPreferences fails, show popup anyway for new users
      print('✅ DEBUG: Showing popup as fallback due to SharedPreferences error');
      PersonalizationPopup.show();
    }
    */
  }
}
