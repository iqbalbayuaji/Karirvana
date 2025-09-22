import 'package:get/get.dart';
import '../../../services/cloudinary_service.dart';
import '../controllers/cv_assistant_controller.dart';

class CvAssistantBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize CloudinaryService if not already initialized
    Get.put(CloudinaryService.instance, permanent: true);
    
    Get.lazyPut<CvAssistantController>(
      () => CvAssistantController(),
    );
  }
}
