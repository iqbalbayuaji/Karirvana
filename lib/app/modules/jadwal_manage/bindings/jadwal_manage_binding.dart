import 'package:get/get.dart';

import '../controllers/jadwal_manage_controller.dart';

class JadwalManageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JadwalManageController>(
      () => JadwalManageController(),
    );
  }
}
