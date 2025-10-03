import 'package:get/get.dart';
import '../../certification_store_main/controllers/certification_store_main_controller.dart';

class CertificationStoreController extends GetxController {
  final isLoading = false.obs;
  final selectedCertification = Rxn<Certification>();
  
  late CertificationStoreMainController _mainController;

  @override
  void onInit() {
    super.onInit();
    _initializeController();
    _loadCertificationData();
  }

  void _initializeController() {
    try {
      _mainController = Get.find<CertificationStoreMainController>();
    } catch (e) {
      _mainController = Get.put(CertificationStoreMainController());
    }
  }

  void _loadCertificationData() {
    isLoading.value = true;
    
    // Get certification ID from arguments
    final args = Get.arguments;
    String? certificationId;
    
    if (args is Map) {
      certificationId = args['certificationId']?.toString();
    } else if (args is String) {
      certificationId = args;
    }
    
    // Find certification by ID or use first one
    if (certificationId != null) {
      selectedCertification.value = _mainController.allCertifications
          .firstWhereOrNull((cert) => cert.id == certificationId);
    }
    
    // Fallback to first certification if not found
    if (selectedCertification.value == null && _mainController.allCertifications.isNotEmpty) {
      selectedCertification.value = _mainController.allCertifications.first;
    }
    
    isLoading.value = false;
  }

  String getCertificationImage(String category, String title) {
    // Map certification categories to images
    switch (category.toLowerCase()) {
      case 'it & programming':
      case 'programming':
        return 'assets/course/course-programming-1.jpg';
      case 'digital marketing':
      case 'marketing':
        return 'assets/course/course-marketing-1.png';
      case 'data analytics':
      case 'data science':
        return 'assets/course/course-python.jpg';
      case 'design':
      case 'ui/ux':
        return 'assets/course/course-uiux-1.jpg';
      case 'business':
        return 'assets/course/course-akuntansi-1.jpg';
      case 'finance':
        return 'assets/course/course-akuntansi-2.jpg';
      default:
        return 'assets/course/course-programming-1.jpg';
    }
  }

  String formatPrice(int price) {
    if (price == 0) return "Gratis";
    return "Rp ${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}";
  }

  String formatNumber(int number) {
    if (number >= 1000000) {
      return "${(number / 1000000).toStringAsFixed(1)}M";
    } else if (number >= 1000) {
      return "${(number / 1000).toStringAsFixed(1)}K";
    }
    return number.toString();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
