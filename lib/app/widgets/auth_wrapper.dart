import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:karirvana/app/modules/personalization/views/personalization_view.dart';
import '../services/firebase_auth_service.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/controllers/login_controller.dart';
import '../modules/login/views/login_view.dart';
import '../modules/homepage/bindings/homepage_binding.dart';
import '../modules/homepage/controllers/homepage_controller.dart';
import '../modules/homepage/views/homepage_view.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuthService authService = Get.find<FirebaseAuthService>();
    
    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        // Show loading while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        // If user is logged in, initialize homepage binding and show homepage
        if (snapshot.hasData && snapshot.data != null) {
          // Ensure homepage binding is initialized
          if (!Get.isRegistered<HomepageController>()) {
            HomepageBinding().dependencies();
          }
          return const HomepageView();
        }
        
        // If user is not logged in, initialize login binding and show login page
        if (!Get.isRegistered<LoginController>()) {
          LoginBinding().dependencies();
        }
        return const LoginView();
      },
    );
  }
}
