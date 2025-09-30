import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../modules/roadmap_manage/models/roadmap_models.dart';

class FirebaseRoadmapService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Collection reference for roadmaps
  static CollectionReference get _roadmapsCollection => 
      _firestore.collection('roadmaps');

  // Get current user ID
  static String? get _currentUserId => _auth.currentUser?.uid;

  // Save roadmap to Firebase
  static Future<void> saveRoadmap({
    required String title,
    required String description,
    required List<RoadmapMainStep> steps,
  }) async {
    try {
      print('🔥 Starting Firebase roadmap save...');
      
      if (_currentUserId == null) {
        throw Exception('User not authenticated');
      }

      // Convert roadmap data to Map
      final roadmapData = {
        'title': title,
        'description': description,
        'steps': steps.map((step) => _stepToMap(step)).toList(),
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'userId': _currentUserId,
        'isActive': true,
      };

      print('📊 Roadmap data prepared for Firebase');
      print('📋 Title: $title');
      print('🪜 Steps count: ${steps.length}');

      // Save to Firebase (one roadmap per user)
      await _roadmapsCollection.doc(_currentUserId).set(roadmapData);
      
      print('✅ Roadmap saved to Firebase successfully');
    } catch (e) {
      print('❌ Firebase save error: $e');
      throw Exception('Failed to save roadmap to Firebase: $e');
    }
  }

  // Load roadmap from Firebase
  static Future<Map<String, dynamic>?> loadRoadmap() async {
    try {
      print('🔥 Loading roadmap from Firebase...');
      
      if (_currentUserId == null) {
        print('⚠️ User not authenticated');
        return null;
      }

      final doc = await _roadmapsCollection.doc(_currentUserId).get();
      
      if (!doc.exists) {
        print('📭 No roadmap found for user');
        return null;
      }

      final data = doc.data() as Map<String, dynamic>;
      print('✅ Roadmap loaded from Firebase');
      print('📋 Title: ${data['title']}');
      
      return data;
    } catch (e) {
      print('❌ Firebase load error: $e');
      throw Exception('Failed to load roadmap from Firebase: $e');
    }
  }

  // Convert roadmap data from Firebase to objects
  static List<RoadmapMainStep> parseRoadmapFromFirebase(Map<String, dynamic> data) {
    try {
      final stepsData = data['steps'] as List<dynamic>;
      
      return stepsData.map((stepData) {
        final stepMap = stepData as Map<String, dynamic>;
        return _mapToStep(stepMap);
      }).toList();
    } catch (e) {
      print('❌ Parse error: $e');
      return [];
    }
  }

  // Delete roadmap from Firebase
  static Future<void> deleteRoadmap() async {
    try {
      if (_currentUserId == null) {
        throw Exception('User not authenticated');
      }

      await _roadmapsCollection.doc(_currentUserId).delete();
      print('🗑️ Roadmap deleted from Firebase');
    } catch (e) {
      print('❌ Firebase delete error: $e');
      throw Exception('Failed to delete roadmap from Firebase: $e');
    }
  }

  // Convert RoadmapMainStep to Map
  static Map<String, dynamic> _stepToMap(RoadmapMainStep step) {
    return {
      'id': step.id,
      'title': step.title,
      'description': step.description,
      'isCompleted': step.isCompleted,
      'estimatedDuration': step.estimatedDuration,
      'subSteps': step.subSteps.map((subStep) => _subStepToMap(subStep)).toList(),
    };
  }

  // Convert RoadmapSubStep to Map
  static Map<String, dynamic> _subStepToMap(RoadmapSubStep subStep) {
    return {
      'id': subStep.id,
      'title': subStep.title,
      'description': subStep.description,
      'isCompleted': subStep.isCompleted,
      'estimatedDuration': subStep.estimatedDuration,
      'resources': subStep.resources.map((resource) => _resourceToMap(resource)).toList(),
    };
  }

  // Convert RoadmapResource to Map
  static Map<String, dynamic> _resourceToMap(RoadmapResource resource) {
    return {
      'type': resource.type,
      'title': resource.title,
      'provider': resource.provider,
      'location': resource.location,
      'status': resource.status.name,
      'jobStatus': resource.jobStatus?.name,
    };
  }

  // Convert Map to RoadmapMainStep
  static RoadmapMainStep _mapToStep(Map<String, dynamic> map) {
    final subStepsData = map['subSteps'] as List<dynamic>? ?? [];
    
    return RoadmapMainStep(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      isCompleted: map['isCompleted'] as bool? ?? false,
      estimatedDuration: map['estimatedDuration'] as String,
      subSteps: subStepsData.map((subStepData) => _mapToSubStep(subStepData as Map<String, dynamic>)).toList(),
    );
  }

  // Convert Map to RoadmapSubStep
  static RoadmapSubStep _mapToSubStep(Map<String, dynamic> map) {
    final resourcesData = map['resources'] as List<dynamic>? ?? [];
    
    return RoadmapSubStep(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      isCompleted: map['isCompleted'] as bool? ?? false,
      estimatedDuration: map['estimatedDuration'] as String,
      resources: resourcesData.map((resourceData) => _mapToResource(resourceData as Map<String, dynamic>)).toList(),
    );
  }

  // Convert Map to RoadmapResource
  static RoadmapResource _mapToResource(Map<String, dynamic> map) {
    return RoadmapResource(
      type: map['type'] as String,
      title: map['title'] as String,
      provider: map['provider'] as String,
      location: map['location'] as String?,
      status: _parseResourceStatus(map['status'] as String?),
      jobStatus: _parseJobStatus(map['jobStatus'] as String?),
    );
  }

  // Parse ResourceStatus from string
  static ResourceStatus _parseResourceStatus(String? status) {
    switch (status) {
      case 'added':
        return ResourceStatus.added;
      case 'inProgress':
        return ResourceStatus.inProgress;
      case 'completed':
        return ResourceStatus.completed;
      default:
        return ResourceStatus.notAdded;
    }
  }

  // Parse JobApplicationStatus from string
  static JobApplicationStatus? _parseJobStatus(String? status) {
    switch (status) {
      case 'applied':
        return JobApplicationStatus.applied;
      case 'accepted':
        return JobApplicationStatus.accepted;
      default:
        return JobApplicationStatus.notApplied;
    }
  }
}
