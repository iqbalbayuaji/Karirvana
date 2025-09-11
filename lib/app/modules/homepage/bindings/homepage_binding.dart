import 'package:get/get.dart';

import '../controllers/homepage_controller.dart';

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
    print('🔍 DEBUG: HomepageBinding dependencies() completed');
  }
}
