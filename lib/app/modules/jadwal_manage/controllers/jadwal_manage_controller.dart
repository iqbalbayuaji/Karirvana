import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/task_model.dart';

class JadwalManageController extends GetxController {
  // Observable list of tasks
  final RxList<TaskModel> tasks = <TaskModel>[].obs;
  
  // Filtered tasks for different views
  final RxList<TaskModel> todayTasks = <TaskModel>[].obs;
  final RxList<TaskModel> upcomingTasks = <TaskModel>[].obs;
  final RxList<TaskModel> completedTasks = <TaskModel>[].obs;
  
  // Loading state
  final RxBool isLoading = false.obs;
  
  // Selected date for calendar view
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  
  // Current calendar month/year view
  final Rx<DateTime> currentCalendarDate = DateTime.now().obs;
  
  @override
  void onInit() {
    super.onInit();
    loadTasks();
  }

  @override
  void onReady() {
    super.onReady();
    _updateFilteredTasks();
  }

  @override
  void onClose() {
    super.onClose();
  }

  /// Add new task
  void addTask(TaskModel task) {
    tasks.add(task);
    _updateFilteredTasks();
    _saveTasks();
  }
  
  /// Update existing task
  void updateTask(TaskModel updatedTask) {
    final index = tasks.indexWhere((task) => task.id == updatedTask.id);
    if (index != -1) {
      tasks[index] = updatedTask;
      _updateFilteredTasks();
      _saveTasks();
    }
  }
  
  /// Delete task
  void deleteTask(String taskId) {
    tasks.removeWhere((task) => task.id == taskId);
    _updateFilteredTasks();
    _saveTasks();
  }
  
  /// Toggle task completion
  void toggleTaskCompletion(String taskId) {
    final index = tasks.indexWhere((task) => task.id == taskId);
    if (index != -1) {
      final task = tasks[index];
      final updatedTask = task.copyWith(
        isCompleted: !task.isCompleted,
        updatedAt: DateTime.now(),
      );
      tasks[index] = updatedTask;
      _updateFilteredTasks();
      _saveTasks();
    }
  }
  
  /// Get tasks for specific date
  List<TaskModel> getTasksForDate(DateTime date) {
    return tasks.where((task) {
      return task.date.year == date.year &&
             task.date.month == date.month &&
             task.date.day == date.day;
    }).toList();
  }
  
  /// Get tasks by priority
  List<TaskModel> getTasksByPriority(TaskPriority priority) {
    return tasks.where((task) => task.priority == priority && !task.isCompleted).toList();
  }
  
  /// Get tasks by category
  List<TaskModel> getTasksByCategory(TaskCategory category) {
    return tasks.where((task) => task.category == category && !task.isCompleted).toList();
  }
  
  /// Update selected date
  void updateSelectedDate(DateTime date) {
    selectedDate.value = date;
    _updateFilteredTasks();
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
  
  /// Update filtered tasks based on current date and filters
  void _updateFilteredTasks() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    // Today's tasks
    todayTasks.value = tasks.where((task) {
      final taskDate = DateTime(task.date.year, task.date.month, task.date.day);
      return taskDate.isAtSameMomentAs(today) && !task.isCompleted;
    }).toList();
    
    // Upcoming tasks (future dates)
    upcomingTasks.value = tasks.where((task) {
      final taskDate = DateTime(task.date.year, task.date.month, task.date.day);
      return taskDate.isAfter(today) && !task.isCompleted;
    }).toList();
    
    // Completed tasks
    completedTasks.value = tasks.where((task) => task.isCompleted).toList();
    
    // Sort tasks by priority and time
    _sortTasks(todayTasks);
    _sortTasks(upcomingTasks);
    _sortTasks(completedTasks);
  }
  
  /// Sort tasks by priority and time
  void _sortTasks(RxList<TaskModel> taskList) {
    taskList.sort((a, b) {
      // First sort by priority (urgent -> high -> medium -> low)
      final priorityComparison = _getPriorityWeight(b.priority).compareTo(_getPriorityWeight(a.priority));
      if (priorityComparison != 0) return priorityComparison;
      
      // Then sort by time if available
      if (a.time != null && b.time != null) {
        return a.time!.compareTo(b.time!);
      } else if (a.time != null) {
        return -1; // Tasks with time come first
      } else if (b.time != null) {
        return 1;
      }
      
      // Finally sort by creation date
      return a.createdAt.compareTo(b.createdAt);
    });
  }
  
  /// Get priority weight for sorting
  int _getPriorityWeight(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.urgent:
        return 4;
      case TaskPriority.high:
        return 3;
      case TaskPriority.medium:
        return 2;
      case TaskPriority.low:
        return 1;
    }
  }
  
  /// Load tasks from SharedPreferences
  Future<void> loadTasks() async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final tasksJson = prefs.getString('tasks');
      
      if (tasksJson != null) {
        final List<dynamic> tasksList = json.decode(tasksJson);
        tasks.value = tasksList.map((taskJson) => TaskModel.fromJson(taskJson)).toList();
        _updateFilteredTasks();
      }
    } catch (e) {
      print('Error loading tasks: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  /// Save tasks to SharedPreferences
  Future<void> _saveTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksJson = json.encode(tasks.map((task) => task.toJson()).toList());
      await prefs.setString('tasks', tasksJson);
    } catch (e) {
      print('Error saving tasks: $e');
    }
  }
  
  /// Get task statistics
  Map<String, int> getTaskStatistics() {
    final total = tasks.length;
    final completed = tasks.where((task) => task.isCompleted).length;
    final pending = total - completed;
    final overdue = tasks.where((task) {
      final now = DateTime.now();
      final taskDate = DateTime(task.date.year, task.date.month, task.date.day);
      final today = DateTime(now.year, now.month, now.day);
      return taskDate.isBefore(today) && !task.isCompleted;
    }).length;
    
    return {
      'total': total,
      'completed': completed,
      'pending': pending,
      'overdue': overdue,
    };
  }
  
  /// Clear all completed tasks
  void clearCompletedTasks() {
    tasks.removeWhere((task) => task.isCompleted);
    _updateFilteredTasks();
    _saveTasks();
  }
  
  /// Search tasks by title or description
  List<TaskModel> searchTasks(String query) {
    if (query.isEmpty) return tasks.toList();
    
    final lowercaseQuery = query.toLowerCase();
    return tasks.where((task) {
      return task.title.toLowerCase().contains(lowercaseQuery) ||
             task.description.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }
}
