import 'package:get/get.dart';

import '../controllers/certification_manage_controller.dart';

class CertificationManageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CertificationManageController>(
      () => CertificationManageController(),
    );
  }
}
