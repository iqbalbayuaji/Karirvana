import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karirvana/app/styles/app_colors.dart';
import '../controllers/edit_profile_controller.dart';
import '../../Interview_Practice/local_widgets/section_title_widget.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: 25,
                  right: 25,
                  bottom: MediaQuery.of(context).viewInsets.bottom ,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header section
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.outline),
                              ),
                              child: const Icon(
                                Icons.arrow_back,
                                color: AppColors.textPrimary,
                                size: 20,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Personalisasi Profil',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat',
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Lengkapi Personalisasi Profil Anda',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Montserrat',
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // const SizedBox(height: 20),
                    
                    // Profile Image Section
                    const SectionTitleWidget(title: 'Foto Profil'),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(() => GestureDetector(
                          onTap: controller.showImagePickerOptions,
                          child: Stack(
                            children: [
                              Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.textSecondary.withOpacity(0.1),
                                  border: Border.all(
                                    color: AppColors.outline,
                                    width: 2,
                                  ),
                                ),
                                child: ClipOval(
                                  child: _buildProfileImage(),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                              if (controller.isUploadingImage.value)
                                Container(
                                  width: 90,
                                  height: 90,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        )),
                      ],
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Username Section
                    const SectionTitleWidget(title: 'Username'),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: controller.usernameController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.surface,
                        hintText: "Username",
                        hintStyle: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          fontFamily: 'Montserrat',
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.outline),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.outline),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.primary),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Gender Section
                    const SectionTitleWidget(title: 'Jenis Kelamin'),
                    const SizedBox(height: 12),
                    Obx(() => Row(
                      children: [
                        GestureDetector(
                          onTap: () => controller.selectGender('Laki-laki'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                            decoration: BoxDecoration(
                              color: controller.selectedGender.value == 'Laki-laki' 
                                  ? AppColors.primary 
                                  : AppColors.surface,
                              border: Border.all(
                                color: controller.selectedGender.value == 'Laki-laki' 
                                    ? AppColors.primary 
                                    : AppColors.outline,
                                width: controller.selectedGender.value == 'Laki-laki' ? 2 : 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.male,
                                    color: controller.selectedGender.value == 'Laki-laki' 
                                        ? AppColors.textOnPrimary 
                                        : AppColors.textSecondary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Laki-laki',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Montserrat',
                                      color: controller.selectedGender.value == 'Laki-laki' 
                                          ? AppColors.textOnPrimary 
                                          : AppColors.textPrimary,
                                      fontWeight: controller.selectedGender.value == 'Laki-laki' 
                                          ? FontWeight.w600 
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () => controller.selectGender('Perempuan'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                            decoration: BoxDecoration(
                              color: controller.selectedGender.value == 'Perempuan' 
                                  ? AppColors.primary
                                  : AppColors.surface,
                              border: Border.all(
                                color: controller.selectedGender.value == 'Perempuan' 
                                    ? AppColors.primary 
                                    : AppColors.outline,
                                width: controller.selectedGender.value == 'Perempuan' ? 2 : 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.female,
                                    color: controller.selectedGender.value == 'Perempuan' 
                                        ? AppColors.textOnPrimary 
                                        : AppColors.textSecondary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Perempuan',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Montserrat',
                                      color: controller.selectedGender.value == 'Perempuan' 
                                          ? AppColors.textOnPrimary 
                                          : AppColors.textPrimary,
                                      fontWeight: controller.selectedGender.value == 'Perempuan' 
                                          ? FontWeight.w600 
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: screenWidth * 0.01,
                        )
                      ],
                    )),
                    
                    const SizedBox(height: 30),
                    
                    // Birth Date Section
                    const SectionTitleWidget(title: 'Tanggal Lahir'),
                    const SizedBox(height: 12),
                    TextFormField(
                      
                      controller: controller.birthDateController,
                      readOnly: true,
                      onTap: () => controller.selectBirthDate(context),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.surface,
                        hintText: "Tanggal Lahir (DD/MM/YY)",
                        hintStyle: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          fontFamily: 'Montserrat',
                        ),
                        suffixIcon: const Icon(
                          Icons.calendar_today,
                          color: AppColors.textSecondary,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.outline),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.outline),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.primary),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Bio Section
                    const SectionTitleWidget(title: 'Bio'),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: controller.bioController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.surface,
                        hintText: "Bio",
                        hintStyle: const TextStyle(
                          fontSize: 14,
                          color: AppColors.surface,
                          fontFamily: 'Montserrat',
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.outline),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.outline),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.primary),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            // Button at the bottom
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              child: SizedBox(
                width: double.infinity,
                child: Obx(() => ElevatedButton(
                  onPressed: controller.isLoading.value ? null : controller.saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: controller.isLoading.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Lanjutkan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Montserrat',
                            color: Colors.white,
                          ),
                        ),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Obx(() {
      if (controller.selectedImage.value != null) {
        // Show selected image
        return Image.file(
          controller.selectedImage.value!,
          width: 90,
          height: 90,
          fit: BoxFit.cover,
        );
      } else if (controller.profileImageUrl.value != null && controller.profileImageUrl.value!.isNotEmpty) {
        // Show existing profile image from URL
        return Image.network(
          controller.profileImageUrl.value!,
          width: 90,
          height: 90,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primary,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return const Icon(
              Icons.person,
              size: 45,
              color: AppColors.textSecondary,
            );
          },
        );
      } else {
        // Show default icon
        return const Icon(
          Icons.person,
          size: 45,
          color: AppColors.textSecondary,
        );
      }
    });
  }
}
