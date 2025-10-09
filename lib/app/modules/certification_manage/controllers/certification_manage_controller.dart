import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../services/firestore_service.dart';

// Model for managed certification (user's enrolled certifications)
class ManagedCertification {
  final String id;
  final String title;
  final String provider;
  final String description;
  final DateTime? enrolledDate;
  final DateTime? completedDate;
  final String? certificateUrl;
  final bool isCompleted;

  ManagedCertification({
    required this.id,
    required this.title,
    required this.provider,
    required this.description,
    this.enrolledDate,
    this.completedDate,
    this.certificateUrl,
    this.isCompleted = false,
  });

  // Create from Firebase data
  factory ManagedCertification.fromFirestore(Map<String, dynamic> data) {
    return ManagedCertification(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      provider: data['provider'] ?? '',
      description: data['description'] ?? '',
      enrolledDate: data['enrolledDate']?.toDate(),
      completedDate: data['completedDate']?.toDate(),
      certificateUrl: data['certificateUrl'],
      isCompleted: data['isCompleted'] ?? false,
    );
  }

  // Convert to Firebase data
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'title': title,
      'provider': provider,
      'description': description,
      'enrolledDate': enrolledDate,
      'completedDate': completedDate,
      'certificateUrl': certificateUrl,
      'isCompleted': isCompleted,
    };
  }
}

class CertificationManageController extends GetxController {
  // Certification data
  final isLoading = false.obs;
  final certifications = <ManagedCertification>[].obs;
  final FirestoreService _firestoreService = FirestoreService.instance;

  @override
  void onInit() {
    super.onInit();
    print('🎯 CertificationManageController onInit() - hashCode: ${this.hashCode}');
    print('📋 Current certifications count: ${certifications.length}');
    _loadCertifications();
  }

  // Load certifications from Firebase
  Future<void> _loadCertifications() async {
    try {
      isLoading.value = true;
      
      // Load enrolled certifications from Firebase
      final certificationsData = await _firestoreService.getEnrolledCertifications();
      
      // Convert Firebase data to ManagedCertification objects
      final loadedCertifications = certificationsData
          .map((data) => ManagedCertification.fromFirestore(data))
          .toList();
      
      certifications.assignAll(loadedCertifications);
      print('✅ Loaded ${certifications.length} certifications from Firebase');
      
    } catch (e) {
      print('❌ Error loading certifications: $e');
      Get.snackbar(
        'Error',
        'Gagal memuat data sertifikat',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFEF4444),
        colorText: const Color(0xFFFFFFFF),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Check if has certifications
  bool get hasCertifications => certifications.isNotEmpty;

  // Add certification (placeholder)
  void addCertification() {
    // TODO: Navigate to add certification page
    Get.snackbar('Info', 'Fitur tambah sertifikat akan segera tersedia!');
  }

  // Enroll in a certification (add to managed certifications)
  Future<bool> enrollCertification(dynamic certificationData) async {
    print('🎯 CertificationManageController.enrollCertification() called');
    print('📋 Certification data: ${certificationData.title}');
    
    try {
      isLoading.value = true;
      
      // Check if certification is already enrolled in Firebase
      bool alreadyEnrolled = await _firestoreService.isCertificationAlreadyEnrolled(certificationData.id);
      if (alreadyEnrolled) {
        print('ℹ️ Certification already enrolled: ${certificationData.title}');
        Get.snackbar(
          'Info', 
          'Anda sudah terdaftar dalam sertifikat ini!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFFF59E0B),
          colorText: const Color(0xFFFFFFFF),
        );
        return false;
      }
      
      // Save to Firebase first
      final success = await _firestoreService.saveEnrolledCertification(
        certificationId: certificationData.id,
        title: certificationData.title,
        provider: certificationData.provider,
        description: certificationData.description,
        isCompleted: false,
        enrolledDate: DateTime.now(),
      );
      
      if (success) {
        // Instead of adding to local list, reload from Firebase to ensure consistency
        await _loadCertifications();
        
        print('✅ Certification saved to Firebase and data reloaded. Total certifications: ${certifications.length}');
        
        Get.snackbar(
          'Berhasil', 
          'Sertifikat berhasil ditambahkan!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFF10B981),
          colorText: const Color(0xFFFFFFFF),
        );
        
        return true;
      } else {
        Get.snackbar(
          'Error', 
          'Gagal menyimpan sertifikat',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFFEF4444),
          colorText: const Color(0xFFFFFFFF),
        );
        return false;
      }
      
    } catch (e) {
      print('❌ Error enrolling certification: $e');
      Get.snackbar(
        'Error', 
        'Terjadi kesalahan saat mendaftar sertifikat',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFEF4444),
        colorText: const Color(0xFFFFFFFF),
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Update certification completion
  Future<bool> updateCertificationCompletion(String certificationId, bool isCompleted, {String? certificateUrl}) async {
    try {
      isLoading.value = true;
      
      final completedDate = isCompleted ? DateTime.now() : null;
      
      // Update in Firebase
      final success = await _firestoreService.updateCertificationCompletion(
        certificationId: certificationId,
        isCompleted: isCompleted,
        completedDate: completedDate,
        certificateUrl: certificateUrl,
      );
      
      if (success) {
        // Update local data
        final certificationIndex = certifications.indexWhere((cert) => cert.id == certificationId);
        if (certificationIndex != -1) {
          final updatedCertification = ManagedCertification(
            id: certifications[certificationIndex].id,
            title: certifications[certificationIndex].title,
            provider: certifications[certificationIndex].provider,
            description: certifications[certificationIndex].description,
            enrolledDate: certifications[certificationIndex].enrolledDate,
            completedDate: completedDate,
            certificateUrl: certificateUrl ?? certifications[certificationIndex].certificateUrl,
            isCompleted: isCompleted,
          );
          certifications[certificationIndex] = updatedCertification;
        }
        
        Get.snackbar(
          'Berhasil', 
          isCompleted ? 'Sertifikat berhasil diselesaikan!' : 'Status sertifikat berhasil diupdate!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFF10B981),
          colorText: const Color(0xFFFFFFFF),
        );
        
        return true;
      } else {
        Get.snackbar(
          'Error', 
          'Gagal mengupdate status sertifikat',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFFEF4444),
          colorText: const Color(0xFFFFFFFF),
        );
        return false;
      }
      
    } catch (e) {
      print('❌ Error updating certification completion: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
  
  // Remove certification
  Future<bool> removeCertification(String certificationId) async {
    try {
      isLoading.value = true;
      
      // Remove from Firebase
      final success = await _firestoreService.removeEnrolledCertification(certificationId);
      
      if (success) {
        // Remove from local list
        certifications.removeWhere((cert) => cert.id == certificationId);
        
        Get.snackbar(
          'Berhasil', 
          'Sertifikat berhasil dihapus!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFF10B981),
          colorText: const Color(0xFFFFFFFF),
        );
        
        return true;
      } else {
        Get.snackbar(
          'Error', 
          'Gagal menghapus sertifikat',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFFEF4444),
          colorText: const Color(0xFFFFFFFF),
        );
        return false;
      }
      
    } catch (e) {
      print('❌ Error removing certification: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

}
