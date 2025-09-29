import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../modules/jadwal_manage/models/task_model.dart';

class TaskFirestoreService {
  static TaskFirestoreService? _instance;
  static TaskFirestoreService get instance {
    _instance ??= TaskFirestoreService._();
    return _instance!;
  }

  TaskFirestoreService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  /// Get user tasks collection reference
  CollectionReference get _tasksCollection {
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }
    return _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('tasks');
  }

  /// Add new task to Firestore
  Future<void> addTask(TaskModel task) async {
    try {
      await _tasksCollection.doc(task.id).set(task.toJson());
    } catch (e) {
      throw Exception('Failed to add task: ${e.toString()}');
    }
  }

  /// Get all tasks for current user
  Future<List<TaskModel>> getUserTasks() async {
    try {
      final querySnapshot = await _tasksCollection
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => TaskModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get tasks: ${e.toString()}');
    }
  }

  /// Get tasks for specific date
  Future<List<TaskModel>> getTasksForDate(DateTime date) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

      final querySnapshot = await _tasksCollection
          .where('date', isGreaterThanOrEqualTo: startOfDay.toIso8601String())
          .where('date', isLessThanOrEqualTo: endOfDay.toIso8601String())
          .orderBy('date')
          .get();

      return querySnapshot.docs
          .map((doc) => TaskModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get tasks for date: ${e.toString()}');
    }
  }

  /// Update existing task
  Future<void> updateTask(TaskModel task) async {
    try {
      await _tasksCollection.doc(task.id).update(task.toJson());
    } catch (e) {
      throw Exception('Failed to update task: ${e.toString()}');
    }
  }

  /// Delete task
  Future<void> deleteTask(String taskId) async {
    try {
      await _tasksCollection.doc(taskId).delete();
    } catch (e) {
      throw Exception('Failed to delete task: ${e.toString()}');
    }
  }

  /// Toggle task completion status
  Future<void> toggleTaskCompletion(String taskId, bool isCompleted) async {
    try {
      await _tasksCollection.doc(taskId).update({
        'isCompleted': isCompleted,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to toggle task completion: ${e.toString()}');
    }
  }

  /// Stream of user tasks (real-time updates)
  Stream<List<TaskModel>> getUserTasksStream() {
    if (currentUserId == null) {
      return Stream.error('User not authenticated');
    }

    return _tasksCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TaskModel.fromJson(doc.data() as Map<String, dynamic>))
            .toList());
  }

  /// Stream of tasks for specific date (real-time updates)
  Stream<List<TaskModel>> getTasksForDateStream(DateTime date) {
    if (currentUserId == null) {
      return Stream.error('User not authenticated');
    }

    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    return _tasksCollection
        .where('date', isGreaterThanOrEqualTo: startOfDay.toIso8601String())
        .where('date', isLessThanOrEqualTo: endOfDay.toIso8601String())
        .orderBy('date')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TaskModel.fromJson(doc.data() as Map<String, dynamic>))
            .toList());
  }

  /// Check if user is authenticated
  bool get isAuthenticated => currentUserId != null;

  /// Get task count for specific date (for calendar markers)
  Future<int> getTaskCountForDate(DateTime date) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

      final querySnapshot = await _tasksCollection
          .where('date', isGreaterThanOrEqualTo: startOfDay.toIso8601String())
          .where('date', isLessThanOrEqualTo: endOfDay.toIso8601String())
          .get();

      return querySnapshot.docs.length;
    } catch (e) {
      return 0; // Return 0 on error
    }
  }

  /// Batch update multiple tasks
  Future<void> batchUpdateTasks(List<TaskModel> tasks) async {
    try {
      final batch = _firestore.batch();

      for (final task in tasks) {
        final docRef = _tasksCollection.doc(task.id);
        batch.update(docRef, task.toJson());
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to batch update tasks: ${e.toString()}');
    }
  }
}
