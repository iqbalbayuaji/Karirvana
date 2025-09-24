import 'package:get/get.dart';

import '../controllers/certification_store_controller.dart';

class CertificationStoreBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CertificationStoreController>(
      () => CertificationStoreController(),
    );
  }
}
