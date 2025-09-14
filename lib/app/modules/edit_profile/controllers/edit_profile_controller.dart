import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../services/firestore_service.dart';
import '../../../services/cloudinary_service.dart';

class EditProfileController extends GetxController {
  // Form controllers
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  
  // Services
  final FirestoreService _firestoreService = Get.find<FirestoreService>();
  
  // Observable variables
  final RxString selectedGender = ''.obs;
  final RxString selectedImagePath = ''.obs;
  final Rxn<String> profileImageUrl = Rxn<String>();
  final RxBool isLoading = false.obs;
  final RxBool isUploading = false.obs;
  final RxBool isUploadingImage = false.obs;
  final Rx<DateTime?> selectedBirthDate = Rx<DateTime?>(null);
  final Rxn<File> selectedImage = Rxn<File>();

  @override
  void onInit() {
    super.onInit();
    loadExistingData();
  }

  @override
  void onClose() {
    usernameController.dispose();
    birthDateController.dispose();
    bioController.dispose();
    super.onClose();
  }

  // Load existing user data
  Future<void> loadExistingData() async {
    try {
      isLoading.value = true;
      
      final userData = await _firestoreService.getUserProfile();
      if (userData != null) {
        usernameController.text = userData['username'] ?? '';
        selectedGender.value = userData['gender'] ?? '';
        bioController.text = userData['bio'] ?? '';
        profileImageUrl.value = userData['profileImageUrl'];
        
        if (userData['birthDate'] != null) {
          birthDateController.text = userData['birthDate'];
          try {
            final parts = userData['birthDate'].split('/');
            if (parts.length == 3) {
              final day = int.parse(parts[0]);
              final month = int.parse(parts[1]);
              final year = int.parse(parts[2]) + 2000; // Convert YY to YYYY
              selectedBirthDate.value = DateTime(year, month, day);
            }
          } catch (e) {
            print('Error parsing birth date: $e');
          }
        }
      }
    } catch (e) {
      print('Error loading existing data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Select gender
  void selectGender(String gender) {
    selectedGender.value = gender;
  }

  // Select birth date
  Future<void> selectBirthDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedBirthDate.value ?? DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    
    if (picked != null) {
      selectedBirthDate.value = picked;
      birthDateController.text = 
          '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year.toString().substring(2)}';
    }
  }

  // Pick image from camera or gallery
  Future<void> pickImage({required ImageSource source}) async {
    try {
      isUploadingImage.value = true;
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 80,
      );
      
      if (image != null) {
        selectedImage.value = File(image.path);
        selectedImagePath.value = image.path;
      }
    } catch (e) {
      print('Error selecting image: $e');
      Get.snackbar(
        'Error',
        'Gagal memilih gambar',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUploadingImage.value = false;
    }
  }

  // Remove profile image
  void _removeProfileImage() {
    selectedImage.value = null;
    selectedImagePath.value = '';
    profileImageUrl.value = null;
  }

  // Show image picker bottom sheet
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
                style: TextStyle(fontFamily: 'Montserrat',fontWeight: FontWeight.w500,),
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
                style: TextStyle(fontFamily: 'Montserrat',fontWeight: FontWeight.w500,),
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
                    fontWeight: FontWeight.w500,
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

  // Save profile data
  Future<void> saveProfile() async {
    if (!_validateForm()) return;

    try {
      isLoading.value = true;

      String? imageUrl = profileImageUrl.value;

      // Upload new image if selected
      if (selectedImagePath.value.isNotEmpty) {
        isUploading.value = true;
        imageUrl = await CloudinaryService.instance.uploadImage(File(selectedImagePath.value));
        isUploading.value = false;
      }

      // Save to Firestore
      final success = await _firestoreService.saveUserProfileStage1(
        username: usernameController.text.trim(),
        gender: selectedGender.value,
        birthDate: birthDateController.text.trim(),
        bio: bioController.text.trim(),
        profileImageUrl: imageUrl,
      );

      if (success) {
        Get.snackbar(
          'Berhasil',
          'Profil berhasil diperbarui',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.back(); // Go back to profile page
      } else {
        throw Exception('Failed to save profile');
      }
    } catch (e) {
      print('Error saving profile: $e');
      Get.snackbar(
        'Error',
        'Gagal menyimpan profil: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
      isUploading.value = false;
    }
  }

  // Form validation
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
        'Pilih tanggal lahir',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (bioController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Bio tidak boleh kosong',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    return true;
  }
}
