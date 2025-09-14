import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../services/cloudinary_service.dart';
import '../../../services/firestore_service.dart';
import '../../../routes/app_pages.dart';
import '../../../services/user_preferences_service.dart';
import '../../homepage/controllers/homepage_controller.dart';

class PersonalizationController extends GetxController {
  // Form controllers
  final usernameController = TextEditingController();
  final birthDateController = TextEditingController();
  final bioController = TextEditingController();
  
  // Birth date selection
  final selectedBirthDate = Rx<DateTime?>(null);
  
  // Gender selection
  final selectedGender = ''.obs;
  
  // Profile image
  final selectedImage = Rxn<File>();
  final profileImageUrl = RxnString();
  
  // Stage navigation
  final currentStage = 1.obs;
  
  // Stage 2 fields
  final selectedPurposes = <String>[].obs;
  final selectedReadiness = ''.obs;
  final selectedStatus = ''.obs;
  final selectedInterestFields = <String>[].obs;
  
  // Loading states
  final isLoading = false.obs;
  final isUploadingImage = false.obs;
  
  // Options for stage 2
  final List<String> purposeOptions = [
    'Mencari pekerjaan',
    'Mengembangkan skill',
    'Networking',
    'Belajar hal baru',
    'Meningkatkan karir',
    'Mencari mentor',
    'Berbagi pengalaman',
  ];
  
  final List<String> readinessOptions = [
    'Sangat siap',
    'Cukup siap',
    'Perlu persiapan',
    'Belum siap',
  ];
  
  final List<String> statusOptions = [
    'Pelajar',
    'Mahasiswa',
    'Pekerja',
    'Tidak bekerja',
  ];
  
  final List<String> interestFieldOptions = [
    'Teknologi Informasi',
    'Digital Marketing',
    'Data Analytics',
    'Desain Grafis',
    'UI/UX Design',
    'Keuangan',
    'Sumber Daya Manusia',
    'Penjualan',
    'Manajemen',
    'Pendidikan',
    'Kesehatan',
    'Hukum',
  ];
  
  // Services
  final _cloudinaryService = CloudinaryService.instance;
  final _firestoreService = FirestoreService.instance;
  final _imagePicker = ImagePicker();
  
  @override
  void onInit() {
    super.onInit();
    _loadUserProfile();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    usernameController.dispose();
    birthDateController.dispose();
    bioController.dispose();
    super.onClose();
  }

  void selectGender(String gender) {
    selectedGender.value = gender;
  }
  
  // Select birth date
  Future<void> selectBirthDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedBirthDate.value ?? DateTime.now().subtract(const Duration(days: 6570)), // 18 years ago
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    
    if (picked != null && picked != selectedBirthDate.value) {
      selectedBirthDate.value = picked;
      birthDateController.text = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year.toString().substring(2)}";
    }
  }
  
  // Stage navigation methods
  void goToStage1() {
    currentStage.value = 1;
  }
  
  void goToStage2() {
    currentStage.value = 2;
  }
  
  // Stage 2 selection methods
  void selectReadiness(String readiness) {
    selectedReadiness.value = readiness;
  }
  
  void selectStatus(String status) {
    selectedStatus.value = status;
  }
  
  void togglePurpose(String purpose) {
    if (selectedPurposes.contains(purpose)) {
      selectedPurposes.remove(purpose);
    } else {
      selectedPurposes.add(purpose);
    }
  }
  
  void toggleInterestField(String field) {
    if (selectedInterestFields.contains(field)) {
      selectedInterestFields.remove(field);
    } else {
      selectedInterestFields.add(field);
    }
  }
  
  // Load existing user profile
  Future<void> _loadUserProfile() async {
    try {
      isLoading.value = true;
      final profileData = await _firestoreService.getUserProfile();
      
      if (profileData != null) {
        // Load existing profile data - Stage 1
        usernameController.text = profileData['username'] ?? '';
        selectedGender.value = profileData['gender'] ?? '';
        birthDateController.text = profileData['birthDate'] ?? '';
        bioController.text = profileData['bio'] ?? '';
        profileImageUrl.value = profileData['profileImageUrl'];
        
        // Load existing profile data - Stage 2
        selectedPurposes.value = List<String>.from(profileData['purposes'] ?? []);
        selectedReadiness.value = profileData['workReadiness'] ?? '';
        selectedStatus.value = profileData['currentStatus'] ?? '';
        selectedInterestFields.value = List<String>.from(profileData['interestFields'] ?? []);
        
        // Username is independent from name - don't auto-fill
        // User can choose their own unique username
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat profil: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  // Pick image from gallery or camera
  Future<void> pickImage({ImageSource source = ImageSource.gallery}) async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      
      if (pickedFile != null) {
        selectedImage.value = File(pickedFile.path);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memilih gambar: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
  
  // Show image picker options
  void showImagePickerOptions() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Pilih Foto Profil',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text(
                'Kamera',
                style: TextStyle(fontFamily: 'Montserrat'),
              ),
              onTap: () {
                Get.back();
                pickImage(source: ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text(
                'Galeri',
                style: TextStyle(fontFamily: 'Montserrat'),
              ),
              onTap: () {
                Get.back();
                pickImage(source: ImageSource.gallery);
              },
            ),
            if (profileImageUrl.value != null || selectedImage.value != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text(
                  'Hapus Foto',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.red,
                  ),
                ),
                onTap: () {
                  Get.back();
                  _removeProfileImage();
                },
              ),
          ],
        ),
      ),
    );
  }
  
  // Remove profile image
  void _removeProfileImage() {
    selectedImage.value = null;
    profileImageUrl.value = null;
  }
  
  // Upload image to Cloudinary
  Future<String?> _uploadImageToCloudinary() async {
    if (selectedImage.value == null) return profileImageUrl.value;
    
    try {
      isUploadingImage.value = true;
      final imageUrl = await _cloudinaryService.uploadImage(
        selectedImage.value!,
        publicId: 'user_${_firestoreService.currentUserId}',
      );
      return imageUrl;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mengunggah gambar: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return null;
    } finally {
      isUploadingImage.value = false;
    }
  }
  
  // Validate form
  bool _validateForm() {
    if (usernameController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Username tidak boleh kosong',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    
    if (selectedGender.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Pilih jenis kelamin',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    
    if (birthDateController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Tanggal lahir tidak boleh kosong',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    
    return true;
  }
  
  // Save profile (Stage 1) and proceed to Stage 2
  Future<void> saveProfile() async {
    if (!_validateForm()) return;
    
    try {
      isLoading.value = true;
      
      // Upload image if selected
      String? imageUrl;
      if (selectedImage.value != null) {
        imageUrl = await _uploadImageToCloudinary();
        if (imageUrl == null) {
          Get.snackbar(
            'Error',
            'Gagal mengunggah foto profil',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
        }
      } else {
        imageUrl = profileImageUrl.value;
      }
      
      // Save Stage 1 data to Firestore (without marking as complete)
      final success = await _firestoreService.saveUserProfileStage1(
        username: usernameController.text.trim(),
        gender: selectedGender.value,
        birthDate: birthDateController.text.trim(),
        bio: bioController.text.trim(),
        profileImageUrl: imageUrl,
      );
      
      if (success) {
        // Proceed to Stage 2
        goToStage2();
      } else {
        Get.snackbar(
          'Error',
          'Gagal menyimpan profil',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  // Complete personalization (Stage 2)
  Future<void> completePersonalization() async {
    if (!_validateStage2Form()) return;
    
    try {
      isLoading.value = true;
      
      // Save complete profile data to Firestore
      final success = await _firestoreService.saveCompleteUserProfile(
        username: usernameController.text.trim(),
        gender: selectedGender.value,
        birthDate: birthDateController.text.trim(),
        bio: bioController.text.trim(),
        profileImageUrl: profileImageUrl.value,
        purposes: selectedPurposes.toList(),
        workReadiness: selectedReadiness.value,
        currentStatus: selectedStatus.value,
        interestFields: selectedInterestFields.toList(),
      );
      
      if (success) {
        Get.snackbar(
          'Berhasil',
          'Personalisasi berhasil diselesaikan!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        
        // Mark personalization as complete and navigate to Homepage
        await UserPreferencesService.markPersonalizationPopupAsShown();
        
        // Reset popup session state so it won't show again in this session
        HomepageController.resetPopupSession();
        
        Get.offAllNamed(Routes.HOMEPAGE);
      } else {
        Get.snackbar(
          'Error',
          'Gagal menyelesaikan personalisasi',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  // Validate Stage 2 form
  bool _validateStage2Form() {
    if (selectedPurposes.isEmpty) {
      Get.snackbar(
        'Error',
        'Pilih minimal satu tujuan bergabung',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    
    if (selectedReadiness.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Pilih tingkat kesiapan kerja',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    
    if (selectedStatus.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Pilih status saat ini',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    
    if (selectedInterestFields.isEmpty) {
      Get.snackbar(
        'Error',
        'Pilih minimal satu bidang minat',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    
    return true;
  }
}
