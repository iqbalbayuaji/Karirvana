import 'package:get/get.dart';

import '../controllers/certification_manage_controller.dart';

class CertificationManageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<CertificationManageController>(
      CertificationManageController(),
      permanent: true, // Keep controller persistent across navigation
    );
  }
}
