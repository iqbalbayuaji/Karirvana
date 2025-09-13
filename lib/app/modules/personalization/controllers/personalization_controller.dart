import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../services/cloudinary_service.dart';
import '../../../services/firestore_service.dart';
import '../../../routes/app_pages.dart';
import '../../../services/user_preferences_service.dart';

class PersonalizationController extends GetxController {
  // Form controllers
  final usernameController = TextEditingController();
  final locationController = TextEditingController();
  final bioController = TextEditingController();
  
  // Gender selection
  final selectedGender = ''.obs;
  
  // Profile image
  final selectedImage = Rxn<File>();
  final profileImageUrl = RxnString();
  
  // Loading states
  final isLoading = false.obs;
  final isUploadingImage = false.obs;
  
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
    locationController.dispose();
    bioController.dispose();
    super.onClose();
  }

  void selectGender(String gender) {
    selectedGender.value = gender;
  }
  
  // Load existing user profile
  Future<void> _loadUserProfile() async {
    try {
      isLoading.value = true;
      final profileData = await _firestoreService.getUserProfile();
      
      if (profileData != null) {
        // Load existing profile data
        usernameController.text = profileData['username'] ?? '';
        selectedGender.value = profileData['gender'] ?? '';
        locationController.text = profileData['location'] ?? '';
        bioController.text = profileData['bio'] ?? '';
        profileImageUrl.value = profileData['profileImageUrl'];
        
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
    
    if (locationController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Lokasi tidak boleh kosong',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    
    return true;
  }
  
  // Save profile
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
      
      // Save to Firestore
      final success = await _firestoreService.saveUserProfile(
        username: usernameController.text.trim(),
        gender: selectedGender.value,
        location: locationController.text.trim(),
        bio: bioController.text.trim(),
        profileImageUrl: imageUrl,
      );
      
      if (success) {
        Get.snackbar(
          'Berhasil',
          'Profil berhasil disimpan',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        
        // Mark personalization as complete and navigate to Homepage
        await UserPreferencesService.markPersonalizationPopupAsShown();
        Get.offAllNamed(Routes.HOMEPAGE);
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
}
