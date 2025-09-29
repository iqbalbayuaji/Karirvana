import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/task_firestore_service.dart';
import '../models/task_model.dart';

class JadwalManageController extends GetxController {
  // Services
  final TaskFirestoreService _taskService = TaskFirestoreService.instance;
  
  // Observable list of tasks
  final RxList<TaskModel> tasks = <TaskModel>[].obs;
  
  // Selected date for calendar view
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  
  // Current calendar month/year view
  final Rx<DateTime> currentCalendarDate = DateTime.now().obs;
  
  // Loading state
  final RxBool isLoading = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    _loadTasksFromFirebase();
  }

  /// Get tasks for specific date
  List<TaskModel> getTasksForDate(DateTime date) {
    return tasks.where((task) {
      return task.date.year == date.year &&
             task.date.month == date.month &&
             task.date.day == date.day;
    }).toList();
  }
  
  /// Update selected date
  void updateSelectedDate(DateTime date) {
    selectedDate.value = date;
  }
  
  /// Navigate to previous month
  void goToPreviousMonth() {
    final current = currentCalendarDate.value;
    currentCalendarDate.value = DateTime(current.year, current.month - 1, 1);
  }
  
  /// Navigate to next month
  void goToNextMonth() {
    final current = currentCalendarDate.value;
    currentCalendarDate.value = DateTime(current.year, current.month + 1, 1);
  }
  
  /// Get current month year string for display
  String getCurrentMonthYear() {
    final date = currentCalendarDate.value;
    final months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
  
  /// Load tasks from Firebase
  Future<void> _loadTasksFromFirebase() async {
    if (!_taskService.isAuthenticated) {
      print('User not authenticated, skipping task load');
      return;
    }

    try {
      isLoading.value = true;
      final userTasks = await _taskService.getUserTasks();
      tasks.assignAll(userTasks);
    } catch (e) {
      print('Error loading tasks: $e');
      Get.snackbar(
        'Error',
        'Gagal memuat jadwal: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[400]!,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh tasks from Firebase
  Future<void> refreshTasks() async {
    await _loadTasksFromFirebase();
  }

  /// Toggle task completion status
  Future<void> toggleTaskCompletion(String taskId) async {
    final taskIndex = tasks.indexWhere((task) => task.id == taskId);
    if (taskIndex == -1) return;

    final task = tasks[taskIndex];
    final newCompletionStatus = !task.isCompleted;

    try {
      // Update local state immediately for better UX
      final updatedTask = task.copyWith(
        isCompleted: newCompletionStatus,
        updatedAt: DateTime.now(),
      );
      tasks[taskIndex] = updatedTask;

      // Update in Firebase
      await _taskService.toggleTaskCompletion(taskId, newCompletionStatus);

      // Show success feedback
      Get.snackbar(
        newCompletionStatus ? 'Tugas Selesai' : 'Tugas Dibatalkan',
        newCompletionStatus 
            ? 'Tugas "${task.title}" telah diselesaikan'
            : 'Tugas "${task.title}" dibatalkan penyelesaiannya',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: newCompletionStatus 
            ? const Color(0xFF4CAF50) 
            : const Color(0xFFFF9800),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      // Revert local state on error
      tasks[taskIndex] = task;
      
      Get.snackbar(
        'Error',
        'Gagal mengupdate tugas: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[400]!,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }
  
  /// Delete a task
  Future<void> deleteTask(String taskId) async {
    final taskIndex = tasks.indexWhere((task) => task.id == taskId);
    if (taskIndex == -1) return;

    final task = tasks[taskIndex];

    try {
      // Remove from local state immediately for better UX
      tasks.removeAt(taskIndex);

      // Delete from Firebase
      await _taskService.deleteTask(taskId);

      Get.snackbar(
        'Tugas Dihapus',
        'Tugas "${task.title}" telah dihapus',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[400]!,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      // Restore task on error
      tasks.insert(taskIndex, task);
      
      Get.snackbar(
        'Error',
        'Gagal menghapus tugas: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[400]!,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  /// Add new task (called from JadwalAddController)
  void addTask(TaskModel task) {
    tasks.insert(0, task); // Add to beginning of list
  }
}
