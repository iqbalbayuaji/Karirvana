import 'package:shared_preferences/shared_preferences.dart';

class UserPreferencesService {
  static const String _personalizationShownKey = 'personalization_popup_shown';
  static const String _isFirstTimeUserKey = 'is_first_time_user';

  // Check if personalization popup has been shown
  static Future<bool> hasPersonalizationPopupBeenShown() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_personalizationShownKey) ?? false;
  }

  // Mark personalization popup as shown
  static Future<void> markPersonalizationPopupAsShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_personalizationShownKey, true);
  }

  // Check if user is first time user
  static Future<bool> isFirstTimeUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isFirstTimeUserKey) ?? true;
  }

  // Mark user as not first time user
  static Future<void> markUserAsNotFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isFirstTimeUserKey, false);
  }

  // Reset all preferences (for testing purposes)
  static Future<void> resetPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
