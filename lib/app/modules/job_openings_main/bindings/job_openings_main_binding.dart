import 'package:get/get.dart';

import '../controllers/job_openings_main_controller.dart';

class JobOpeningsMainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JobOpeningsMainController>(
      () => JobOpeningsMainController(),
    );
  }
}
