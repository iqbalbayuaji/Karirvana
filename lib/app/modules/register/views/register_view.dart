import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../../styles/app_colors.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Container(
            height: size.height * 0.45,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: AppColors.heroGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          
          SafeArea(
            child: SingleChildScrollView(
              // padding: EdgeInsets.only(bottom: keyboardHeight),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: size.height - MediaQuery.of(context).padding.top,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      Container(
                        height: size.height * 0.34,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Karirvana',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Bergabunglah dengan kami!',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      Flexible(
                        child: Container(
                          width: double.infinity,
                          constraints: BoxConstraints(
                            minHeight: size.height * 0.6,
                          ),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                            child: Container(
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Register',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textPrimary,
                                            fontFamily: 'Montserrat',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  
                                  // Nama field
                                  const Text(
                                    'Nama Lengkap',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: controller.nameController,
                                    keyboardType: TextInputType.name,
                                    decoration: InputDecoration(
                                      hintText: 'Masukkan nama lengkap Anda',
                                      hintStyle: const TextStyle(
                                        fontSize: 14,
                                        color: AppColors.textSecondary,
                                        fontFamily: 'Montserrat',
                                      ),
                                      prefixIcon: const Icon(
                                        Icons.person_outline,
                                        color: AppColors.primary,
                                        size: 20,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: AppColors.outline,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: AppColors.outline,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: AppColors.primary,
                                          width: 2,
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: AppColors.surfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  
                                  // Email field
                                  const Text(
                                    'Email',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: controller.emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      hintText: 'Masukkan email Anda',
                                      hintStyle: const TextStyle(
                                        fontSize: 14,
                                        color: AppColors.textSecondary,
                                        fontFamily: 'Montserrat',
                                      ),
                                      prefixIcon: const Icon(
                                        Icons.email_outlined,
                                        color: AppColors.primary,
                                        size: 20,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: AppColors.outline,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: AppColors.outline,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: AppColors.primary,
                                          width: 2,
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: AppColors.surfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  
                                  // Tanggal lahir field
                                  // const Text(
                                  //   'Tanggal Lahir',
                                  //   style: TextStyle(
                                  //     fontSize: 14,
                                  //     fontWeight: FontWeight.w600,
                                  //     color: AppColors.textPrimary,
                                  //     fontFamily: 'Montserrat',
                                  //   ),
                                  // ),
                                  // const SizedBox(height: 8),
                                  // TextFormField(
                                  //   controller: controller.birthDateController,
                                  //   readOnly: true,
                                  //   onTap: () => controller.selectBirthDate(context),
                                  //   decoration: InputDecoration(
                                  //     hintText: 'Pilih tanggal lahir Anda',
                                  //     hintStyle: const TextStyle(
                                  //       fontSize: 14,
                                  //       color: AppColors.textSecondary,
                                  //       fontFamily: 'Montserrat',
                                  //     ),
                                  //     prefixIcon: const Icon(
                                  //       Icons.calendar_today_outlined,
                                  //       color: AppColors.primary,
                                  //       size: 20,
                                  //     ),
                                  //     border: OutlineInputBorder(
                                  //       borderRadius: BorderRadius.circular(12),
                                  //       borderSide: const BorderSide(
                                  //         color: AppColors.outline,
                                  //       ),
                                  //     ),
                                  //     enabledBorder: OutlineInputBorder(
                                  //       borderRadius: BorderRadius.circular(12),
                                  //       borderSide: const BorderSide(
                                  //         color: AppColors.outline,
                                  //       ),
                                  //     ),
                                  //     focusedBorder: OutlineInputBorder(
                                  //       borderRadius: BorderRadius.circular(12),
                                  //       borderSide: const BorderSide(
                                  //         color: AppColors.primary,
                                  //         width: 2,
                                  //       ),
                                  //     ),
                                  //     filled: true,
                                  //     fillColor: AppColors.surfaceVariant,
                                  //   ),
                                  // ),
                                  // const SizedBox(height: 16),
                                  
                                  // Password field
                                  const Text(
                                    'Password',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Obx(() => TextFormField(
                                    controller: controller.passwordController,
                                    obscureText: controller.isPasswordHidden.value,
                                    decoration: InputDecoration(
                                      hintText: 'Masukkan password Anda',
                                      hintStyle: const TextStyle(
                                        fontSize: 14,
                                        color: AppColors.textSecondary,
                                        fontFamily: 'Montserrat',
                                      ),
                                      prefixIcon: const Icon(
                                        Icons.lock_outline,
                                        color: AppColors.primary,
                                        size: 20,
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          controller.isPasswordHidden.value
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: AppColors.textSecondary,
                                          size: 20,
                                        ),
                                        onPressed: controller.togglePasswordVisibility,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: AppColors.outline,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: AppColors.outline,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: AppColors.primary,
                                          width: 2,
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: AppColors.surfaceVariant,
                                    ),
                                  )),
                                  const SizedBox(height: 16),
                                  
                                  // Confirm Password field
                                  const Text(
                                    'Konfirmasi Password',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Obx(() => TextFormField(
                                    controller: controller.confirmPasswordController,
                                    obscureText: controller.isConfirmPasswordHidden.value,
                                    decoration: InputDecoration(
                                      hintText: 'Konfirmasi password Anda',
                                      hintStyle: const TextStyle(
                                        fontSize: 14,
                                        color: AppColors.textSecondary,
                                        fontFamily: 'Montserrat',
                                      ),
                                      prefixIcon: const Icon(
                                        Icons.lock_outline,
                                        color: AppColors.primary,
                                        size: 20,
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          controller.isConfirmPasswordHidden.value
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: AppColors.textSecondary,
                                          size: 20,
                                        ),
                                        onPressed: controller.toggleConfirmPasswordVisibility,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: AppColors.outline,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: AppColors.outline,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: AppColors.primary,
                                          width: 2,
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: AppColors.surfaceVariant,
                                    ),
                                  )),
                                  const SizedBox(height: 30),
                                  
                                  // Register button
                                  SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: Obx(() => ElevatedButton(
                                      onPressed: controller.isLoading.value 
                                          ? null 
                                          : () {
                                              controller.register();
                                            },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: controller.isLoading.value
                                          ? const SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor: AlwaysStoppedAnimation<Color>(
                                                  Colors.white,
                                                ),
                                              ),
                                            )
                                          : const Text(
                                              'Daftar',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'Montserrat',
                                              ),
                                            ),
                                    )),
                                  ),
                                  const SizedBox(height: 10),
                                  
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Sudah punya akun?',
                                        style: TextStyle(
                                          color: AppColors.textSecondary,
                                          fontFamily: 'Montserrat',
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Get.toNamed(Routes.LOGIN);
                                        },
                                        child: const Text(
                                          'Masuk',
                                          style: TextStyle(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Montserrat',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
