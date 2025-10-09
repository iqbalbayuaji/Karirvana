import 'package:get/get.dart';
import '../../../data/models/certification_model.dart';
import '../../../routes/app_pages.dart';
import '../../certification_store_main/controllers/certification_store_main_controller.dart';
import '../../certification_manage/controllers/certification_manage_controller.dart';

class CertificationStoreController extends GetxController {
  final isLoading = false.obs;
  final selectedCertification = Rxn<Certification>();
  
  late CertificationStoreMainController _mainController;

  @override
  void onInit() {
    super.onInit();
    _initializeController();
  }

  @override
  void onReady() {
    super.onReady();
    _loadCertificationData();
  }

  void _initializeController() {
    try {
      _mainController = Get.find<CertificationStoreMainController>();
    } catch (e) {
      _mainController = Get.put(CertificationStoreMainController());
    }
  }

  Future<void> _loadCertificationData() async {
    isLoading.value = true;
    
    // Get certification ID from arguments
    final args = Get.arguments;
    String? certificationId;
    
    if (args is Map) {
      certificationId = args['certificationId']?.toString();
    } else if (args is String) {
      certificationId = args;
    }
    
    // Ensure certifications are loaded first
    if (_mainController.allCertifications.isEmpty) {
      await _mainController.loadCertifications();
      // Add small delay to ensure data is fully loaded
      await Future.delayed(Duration(milliseconds: 100));
    }
    
    // Find certification by ID or use first one (matching course store pattern)
    if (certificationId != null && _mainController.allCertifications.isNotEmpty) {
      // Try to find exact match
      var foundCert = _mainController.allCertifications.firstWhereOrNull(
        (cert) => cert.id == certificationId,
      );
      
      if (foundCert != null) {
        selectedCertification.value = foundCert;
      } else {
        selectedCertification.value = _mainController.allCertifications.first;
      }
    } else if (_mainController.allCertifications.isNotEmpty) {
      selectedCertification.value = _mainController.allCertifications.first;
    }
    isLoading.value = false;
  }

  // Method to reload certification data (can be called when needed)
  void reloadCertification() {
    _loadCertificationData();
  }

  // Enroll in certification (add to managed certifications)
  void enrollCertification() {
    print('🔥 enrollCertification() called');
    if (selectedCertification.value == null) {
      print('❌ No selected certification');
      return;
    }
    
    print('📋 Selected certification: ${selectedCertification.value!.title}');
    
    try {
      // Get or create CertificationManageController
      CertificationManageController manageController;
      try {
        manageController = Get.find<CertificationManageController>();
        print('✅ Found existing CertificationManageController - hashCode: ${manageController.hashCode}');
        print('📋 Current certifications in controller: ${manageController.certifications.length}');
      } catch (e) {
        print('⚠️ Creating new CertificationManageController');
        manageController = Get.put(CertificationManageController(), permanent: true);
        print('✅ Created CertificationManageController - hashCode: ${manageController.hashCode}');
      }
      
      // Enroll the certification (async call)
      manageController.enrollCertification(selectedCertification.value!).then((success) {
        if (success) {
          print('✅ Certification enrolled successfully: ${selectedCertification.value!.title}');
        } else {
          print('⚠️ Certification enrollment failed or already enrolled');
        }
      }).catchError((e) {
        print('❌ Error in enrollment: $e');
      });
      
    } catch (e) {
      print('❌ Error enrolling certification: $e');
    }

    Get.toNamed(Routes.CERTIFICATION_MANAGE);
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
