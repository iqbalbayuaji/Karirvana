import 'package:get/get.dart';
import '../../../services/user_preferences_service.dart';
import '../../../widgets/personalization_popup.dart';

class HomepageController extends GetxController {
  final count = 0.obs;
  final activeIndex = 0.obs;
  
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    _checkAndShowPersonalizationPopup();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  // Check if personalization popup should be shown
  Future<void> _checkAndShowPersonalizationPopup() async {
    // Wait a bit for the page to fully load
    await Future.delayed(const Duration(milliseconds: 500));
    
    try {
      final hasBeenShown = await UserPreferencesService.hasPersonalizationPopupBeenShown();
      final isFirstTime = await UserPreferencesService.isFirstTimeUser();
      
      print('🔍 DEBUG: Popup check - hasBeenShown: $hasBeenShown, isFirstTime: $isFirstTime');
      
      // Show popup only if it hasn't been shown before and user is not first time (has registered)
      if (!hasBeenShown && !isFirstTime) {
        print('✅ DEBUG: Showing personalization popup');
        PersonalizationPopup.show();
      } else {
        print('ℹ️ DEBUG: Popup not shown - conditions not met');
      }
    } catch (e) {
      print('⚠️ DEBUG: SharedPreferences error in popup check: $e');
      // If SharedPreferences fails, show popup anyway for new users
      PersonalizationPopup.show();
    }
  }
}
