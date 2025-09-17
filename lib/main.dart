import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:karirvana/app/modules/Interview_Practice/views/interview_practice_setup_view.dart';

import 'app/routes/app_pages.dart';
import 'app/services/firebase_auth_service.dart';
import 'app/services/firestore_service.dart';
import 'app/services/cloudinary_service.dart';
import 'app/widgets/auth_wrapper.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dotenv
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print('Error loading .env file: $e');
  }
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // Firebase already initialized
    print('Firebase already initialized: $e');
  }
  
  // Register Firebase Auth Service
  Get.put(FirebaseAuthService());
  
  // Register Firestore Service
  Get.put(FirestoreService.instance);
  
  // Initialize Cloudinary Service
  try {
    CloudinaryService.instance.initialize();
  } catch (e) {
    print('Error initializing Cloudinary: $e');
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Karirvana',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AuthWrapper(),
      getPages: AppPages.routes,
    );
  }
}
