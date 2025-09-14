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
}
