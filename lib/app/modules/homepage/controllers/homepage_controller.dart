import 'package:get/get.dart';
import '../../../widgets/personalization_popup.dart';
import '../../../services/firestore_service.dart';

class HomepageController extends GetxController {
  final count = 0.obs;
  final activeIndex = 0.obs;
  
  // Observable for user name
  final userName = 'Banon'.obs; // Default fallback name
  final isLoadingUserName = true.obs;
  
  // Static variable to track if popup has been shown in this session
  static bool _hasShownPopupInSession = false;
  
  @override
  void onInit() {
    super.onInit();
    print('🔍 DEBUG: HomepageController onInit() called');
    _loadUserName();
  }

  @override
  void onReady() {
    super.onReady();
    print('🔍 DEBUG: HomepageController onReady() called');
    print('🔍 DEBUG: Session popup flag: $_hasShownPopupInSession');
    _checkAndShowPersonalizationPopup();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  // Load user name from Firebase
  Future<void> _loadUserName() async {
    try {
      isLoadingUserName.value = true;
      
      final firestoreService = FirestoreService.instance;
      final profileData = await firestoreService.getUserProfile();
      
      if (profileData != null && profileData['name'] != null) {
        // Extract first word from name field (split by space and take first part)
        String fullName = profileData['name'].toString();
        String firstName = fullName.trim().split(' ').first;
        userName.value = firstName;
        print('✅ DEBUG: User name loaded: $firstName');
      } else {
        // Keep default name if no profile data
        print('ℹ️ DEBUG: No name found, keeping default name');
      }
    } catch (e) {
      print('⚠️ DEBUG: Error loading user name: $e');
      // Keep default name on error
    } finally {
      isLoadingUserName.value = false;
    }
  }

  // Public method to check personalization popup (can be called from view)
  Future<void> checkPersonalizationPopup() async {
    await _checkAndShowPersonalizationPopup();
  }

  // Check if personalization popup should be shown
  Future<void> _checkAndShowPersonalizationPopup() async {
    print('🔍 DEBUG: _checkAndShowPersonalizationPopup() method called');
    
    // If popup has already been shown in this session, don't show again
    if (_hasShownPopupInSession) {
      print('ℹ️ DEBUG: Popup already shown in this session, skipping');
      return;
    }
    
    // Wait a bit for the page to fully load
    await Future.delayed(const Duration(milliseconds: 1000));
    
    try {
      // Check if user profile is complete
      final firestoreService = FirestoreService.instance;
      final profileData = await firestoreService.getUserProfile();
      
      print('🔍 DEBUG: Profile data: $profileData');
      
      // For new users, always show popup regardless of other conditions
      if (profileData == null) {
        print('✅ DEBUG: New user (no profile data), showing popup');
        _hasShownPopupInSession = true;
        PersonalizationPopup.show();
        return;
      }
      
      // If profile exists and is complete, don't show popup
      if (profileData['isProfileComplete'] == true) {
        print('ℹ️ DEBUG: Profile is complete, not showing popup');
        return;
      }
      
      // Check if user has ever seen the popup before (persistent flag)
      if (profileData['hasSeenPersonalizationPopup'] == true) {
        print('ℹ️ DEBUG: User has already seen popup before, not showing again');
        return;
      }
      
      // If we reach here, user has incomplete profile and hasn't seen popup
      print('✅ DEBUG: User has incomplete profile and hasn\'t seen popup, showing it');
      print('🔍 DEBUG: hasSeenPersonalizationPopup: ${profileData['hasSeenPersonalizationPopup']}');
      print('🔍 DEBUG: isProfileComplete: ${profileData['isProfileComplete']}');
      _hasShownPopupInSession = true;
      PersonalizationPopup.show();
      
    } catch (e) {
      print('⚠️ DEBUG: Error checking profile status: $e');
      // For new users, show popup on error as fallback
      print('✅ DEBUG: Showing popup as fallback for potential new user');
      _hasShownPopupInSession = true;
      PersonalizationPopup.show();
    }
  }
  
  // Method to reset popup session state (can be called when user completes personalization)
  static void resetPopupSession() {
    _hasShownPopupInSession = false;
  }
}
