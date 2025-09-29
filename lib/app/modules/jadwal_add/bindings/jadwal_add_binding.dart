import 'package:get/get.dart';

import '../controllers/jadwal_add_controller.dart';

class JadwalAddBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JadwalAddController>(
      () => JadwalAddController(),
    );
  }
}
