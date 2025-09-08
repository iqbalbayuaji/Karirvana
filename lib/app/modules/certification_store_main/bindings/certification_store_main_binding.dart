import 'package:get/get.dart';

import '../controllers/certification_store_main_controller.dart';

class CertificationStoreMainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CertificationStoreMainController>(
      () => CertificationStoreMainController(),
    );
  }
}
