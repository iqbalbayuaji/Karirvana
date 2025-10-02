import 'package:get/get.dart';

import '../controllers/homepage_controller.dart';
import '../../course_store_main/controllers/course_store_main_controller.dart';

class HomepageBinding extends Bindings {
  @override
  void dependencies() {
    print('🔍 DEBUG: HomepageBinding dependencies() called');
    Get.lazyPut<HomepageController>(
      () {
        print('🔍 DEBUG: Creating HomepageController instance');
        return HomepageController();
      },
    );
    
    // Register CourseStoreMainController for recommendations
    Get.lazyPut<CourseStoreMainController>(
      () {
        print('🔍 DEBUG: Creating CourseStoreMainController instance for homepage');
        return CourseStoreMainController();
      },
    );
    
    print('🔍 DEBUG: HomepageBinding dependencies() completed');
  }
}
