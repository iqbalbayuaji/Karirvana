import 'package:get/get.dart';

import '../controllers/certification_store_controller.dart';

class CertificationStoreBinding extends Bindings {
  @override
  void dependencies() {
    // Use Get.put instead of Get.lazyPut to ensure fresh controller each time
    Get.put<CertificationStoreController>(
      CertificationStoreController(),
      permanent: false, // Allow controller to be disposed and recreated
    );
  }
}
