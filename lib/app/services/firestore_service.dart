import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  static FirestoreService? _instance;
  static FirestoreService get instance => _instance ??= FirestoreService._();
  
  FirestoreService._();
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Collection references
  CollectionReference get _usersCollection => _firestore.collection('users');
  
  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;
  
  // Create initial user profile during registration
  Future<bool> createInitialUserProfile({
    required String name,
    required String email,
  }) async {
    try {
      if (currentUserId == null) {
        throw Exception('User not authenticated');
      }
      
      final userData = {
        'name': name,
        'email': email,
        'username': '',
        'gender': '',
        'birthDate': '',
        'bio': '',
        'profileImageUrl': null,
        'isProfileComplete': false,
        'hasSeenPersonalizationPopup': false,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };
      
      await _usersCollection.doc(currentUserId).set(userData);
      return true;
    } catch (e) {
      print('Error creating initial user profile: $e');
      return false;
    }
  }
  
  // Save user profile data (legacy method - kept for compatibility)
  Future<bool> saveUserProfile({
    required String username,
    required String gender,
    required String birthDate,
    required String bio,
    String? profileImageUrl,
  }) async {
    try {
      if (currentUserId == null) {
        throw Exception('User not authenticated');
      }
      
      final userData = {
        'username': username,
        'gender': gender,
        'birthDate': birthDate,
        'bio': bio,
        'profileImageUrl': profileImageUrl,
        'isProfileComplete': true,
        'updatedAt': FieldValue.serverTimestamp(),
      };
      
      await _usersCollection.doc(currentUserId).set(
        userData,
        SetOptions(merge: true),
      );
      
      return true;
    } catch (e) {
      print('Error saving user profile: $e');
      return false;
    }
  }
  
  // Save user profile Stage 1 data only
  Future<bool> saveUserProfileStage1({
    required String username,
    required String gender,
    required String birthDate,
    required String bio,
    String? profileImageUrl,
  }) async {
    try {
      if (currentUserId == null) {
        throw Exception('User not authenticated');
      }
      
      final userData = {
        'username': username,
        'gender': gender,
        'birthDate': birthDate,
        'bio': bio,
        'profileImageUrl': profileImageUrl,
        'isProfileComplete': false, // Still incomplete until stage 2
        'stage1Complete': true,
        'updatedAt': FieldValue.serverTimestamp(),
      };
      
      await _usersCollection.doc(currentUserId).set(
        userData,
        SetOptions(merge: true),
      );
      
      return true;
    } catch (e) {
      print('Error saving user profile stage 1: $e');
      return false;
    }
  }
  
  // Save complete user profile with Stage 2 data
  Future<bool> saveCompleteUserProfile({
    required String username,
    required String gender,
    required String birthDate,
    required String bio,
    String? profileImageUrl,
    required List<String> purposes,
    required String workReadiness,
    required String currentStatus,
    required List<String> interestFields,
  }) async {
    try {
      if (currentUserId == null) {
        throw Exception('User not authenticated');
      }
      
      final userData = {
        'username': username,
        'gender': gender,
        'birthDate': birthDate,
        'bio': bio,
        'profileImageUrl': profileImageUrl,
        'purposes': purposes,
        'workReadiness': workReadiness,
        'currentStatus': currentStatus,
        'interestFields': interestFields,
        'isProfileComplete': true,
        'stage1Complete': true,
        'stage2Complete': true,
        'updatedAt': FieldValue.serverTimestamp(),
      };
      
      await _usersCollection.doc(currentUserId).set(
        userData,
        SetOptions(merge: true),
      );
      
      return true;
    } catch (e) {
      print('Error saving complete user profile: $e');
      return false;
    }
  }
  
  // Get user profile data
  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      if (currentUserId == null) {
        throw Exception('User not authenticated');
      }
      
      final doc = await _usersCollection.doc(currentUserId).get();
      
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>?;
      }
      
      return null;
    } catch (e) {
      print('Error getting user profile: $e');
      return null;
    }
  }
  
  // Update profile image URL
  Future<bool> updateProfileImage(String imageUrl) async {
    try {
      if (currentUserId == null) {
        throw Exception('User not authenticated');
      }
      
      await _usersCollection.doc(currentUserId).update({
        'profileImageUrl': imageUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      return true;
    } catch (e) {
      print('Error updating profile image: $e');
      return false;
    }
  }
  
  // Check if user profile exists
  Future<bool> doesUserProfileExist() async {
    try {
      if (currentUserId == null) {
        return false;
      }
      
      final doc = await _usersCollection.doc(currentUserId).get();
      return doc.exists;
    } catch (e) {
      print('Error checking user profile existence: $e');
      return false;
    }
  }
  
  // Mark personalization popup as seen
  Future<bool> markPersonalizationPopupAsSeen() async {
    try {
      if (currentUserId == null) {
        throw Exception('User not authenticated');
      }
      
      await _usersCollection.doc(currentUserId).update({
        'hasSeenPersonalizationPopup': true,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      return true;
    } catch (e) {
      print('Error marking personalization popup as seen: $e');
      return false;
    }
  }
  
  // Stream user profile data for real-time updates
  Stream<Map<String, dynamic>?> getUserProfileStream() {
    if (currentUserId == null) {
      return Stream.value(null);
    }
    
    return _usersCollection.doc(currentUserId).snapshots().map((doc) {
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>?;
      }
      return null;
    });
  }

  // ==================== COURSE MANAGEMENT ====================
  
  // Get user's managed courses collection reference
  CollectionReference? get _userCoursesCollection {
    if (currentUserId == null) return null;
    return _usersCollection.doc(currentUserId).collection('managed_courses');
  }
  
  // Check if course is already enrolled
  Future<bool> isCourseAlreadyEnrolled(String courseId) async {
    try {
      if (_userCoursesCollection == null) {
        return false;
      }
      
      final doc = await _userCoursesCollection!.doc(courseId).get();
      return doc.exists;
    } catch (e) {
      print('Error checking course enrollment: $e');
      return false;
    }
  }

  // Save enrolled course to Firebase
  Future<bool> saveEnrolledCourse({
    required String courseId,
    required String title,
    required String provider,
    required String description,
    double progress = 0.0,
    bool isCompleted = false,
    DateTime? enrolledDate,
    DateTime? completedDate,
  }) async {
    try {
      if (_userCoursesCollection == null) {
        throw Exception('User not authenticated');
      }
      
      // Check if already enrolled
      final alreadyEnrolled = await isCourseAlreadyEnrolled(courseId);
      if (alreadyEnrolled) {
        print('Course already enrolled: $courseId');
        return false;
      }
      
      final courseData = {
        'id': courseId,
        'title': title,
        'provider': provider,
        'description': description,
        'progress': progress,
        'isCompleted': isCompleted,
        'enrolledDate': enrolledDate ?? DateTime.now(),
        'completedDate': completedDate,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };
      
      await _userCoursesCollection!.doc(courseId).set(courseData);
      return true;
    } catch (e) {
      print('Error saving enrolled course: $e');
      return false;
    }
  }

  // Save enrolled course with modules to Firebase (Enhanced version)
  Future<bool> saveEnrolledCourseWithModules(dynamic managedCourse) async {
    try {
      if (_userCoursesCollection == null) {
        throw Exception('User not authenticated');
      }
      
      // Check if already enrolled
      final alreadyEnrolled = await isCourseAlreadyEnrolled(managedCourse.id);
      if (alreadyEnrolled) {
        print('Course already enrolled: ${managedCourse.id}');
        return false;
      }
      
      // Convert ManagedCourse to Firebase data
      final courseData = managedCourse.toFirestore();
      courseData['createdAt'] = FieldValue.serverTimestamp();
      courseData['updatedAt'] = FieldValue.serverTimestamp();
      
      await _userCoursesCollection!.doc(managedCourse.id).set(courseData);
      return true;
    } catch (e) {
      print('Error saving enrolled course with modules: $e');
      return false;
    }
  }
  
  // Get all enrolled courses
  Future<List<Map<String, dynamic>>> getEnrolledCourses() async {
    try {
      if (_userCoursesCollection == null) {
        return [];
      }
      
      final querySnapshot = await _userCoursesCollection!
          .orderBy('enrolledDate', descending: true)
          .get();
      
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error getting enrolled courses: $e');
      return [];
    }
  }
  
  // Update course progress
  Future<bool> updateCourseProgress({
    required String courseId,
    required double progress,
    bool? isCompleted,
    DateTime? completedDate,
  }) async {
    try {
      if (_userCoursesCollection == null) {
        throw Exception('User not authenticated');
      }
      
      final updateData = {
        'progress': progress,
        'updatedAt': FieldValue.serverTimestamp(),
      };
      
      if (isCompleted != null) {
        updateData['isCompleted'] = isCompleted;
      }
      
      if (completedDate != null) {
        updateData['completedDate'] = completedDate;
      }
      
      await _userCoursesCollection!.doc(courseId).update(updateData);
      return true;
    } catch (e) {
      print('Error updating course progress: $e');
      return false;
    }
  }
  
  // Remove enrolled course
  Future<bool> removeEnrolledCourse(String courseId) async {
    try {
      if (_userCoursesCollection == null) {
        throw Exception('User not authenticated');
      }
      
      await _userCoursesCollection!.doc(courseId).delete();
      return true;
    } catch (e) {
      print('Error removing enrolled course: $e');
      return false;
    }
  }

  // ==================== CERTIFICATION MANAGEMENT ====================
  
  // Get user's managed certifications collection reference
  CollectionReference? get _userCertificationsCollection {
    if (currentUserId == null) return null;
    return _usersCollection.doc(currentUserId).collection('managed_certifications');
  }
  
  // Check if certification is already enrolled
  Future<bool> isCertificationAlreadyEnrolled(String certificationId) async {
    try {
      if (_userCertificationsCollection == null) {
        return false;
      }
      
      final doc = await _userCertificationsCollection!.doc(certificationId).get();
      return doc.exists;
    } catch (e) {
      print('Error checking certification enrollment: $e');
      return false;
    }
  }

  // Save enrolled certification to Firebase
  Future<bool> saveEnrolledCertification({
    required String certificationId,
    required String title,
    required String provider,
    required String description,
    bool isCompleted = false,
    DateTime? enrolledDate,
    DateTime? completedDate,
    String? certificateUrl,
  }) async {
    try {
      if (_userCertificationsCollection == null) {
        throw Exception('User not authenticated');
      }
      
      // Check if already enrolled
      final alreadyEnrolled = await isCertificationAlreadyEnrolled(certificationId);
      if (alreadyEnrolled) {
        print('Certification already enrolled: $certificationId');
        return false;
      }
      
      final certificationData = {
        'id': certificationId,
        'title': title,
        'provider': provider,
        'description': description,
        'isCompleted': isCompleted,
        'enrolledDate': enrolledDate ?? DateTime.now(),
        'completedDate': completedDate,
        'certificateUrl': certificateUrl,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };
      
      await _userCertificationsCollection!.doc(certificationId).set(certificationData);
      return true;
    } catch (e) {
      print('Error saving enrolled certification: $e');
      return false;
    }
  }
  
  // Get all enrolled certifications
  Future<List<Map<String, dynamic>>> getEnrolledCertifications() async {
    try {
      if (_userCertificationsCollection == null) {
        return [];
      }
      
      final querySnapshot = await _userCertificationsCollection!
          .orderBy('enrolledDate', descending: true)
          .get();
      
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error getting enrolled certifications: $e');
      return [];
    }
  }
  
  // Update certification completion
  Future<bool> updateCertificationCompletion({
    required String certificationId,
    required bool isCompleted,
    DateTime? completedDate,
    String? certificateUrl,
  }) async {
    try {
      if (_userCertificationsCollection == null) {
        throw Exception('User not authenticated');
      }
      
      final updateData = {
        'isCompleted': isCompleted,
        'updatedAt': FieldValue.serverTimestamp(),
      };
      
      if (completedDate != null) {
        updateData['completedDate'] = completedDate;
      }
      
      if (certificateUrl != null) {
        updateData['certificateUrl'] = certificateUrl;
      }
      
      await _userCertificationsCollection!.doc(certificationId).update(updateData);
      return true;
    } catch (e) {
      print('Error updating certification completion: $e');
      return false;
    }
  }
  
  // Remove enrolled certification
  Future<bool> removeEnrolledCertification(String certificationId) async {
    try {
      if (_userCertificationsCollection == null) {
        throw Exception('User not authenticated');
      }
      
      await _userCertificationsCollection!.doc(certificationId).delete();
      return true;
    } catch (e) {
      print('Error removing enrolled certification: $e');
      return false;
    }
  }

}
