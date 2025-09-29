import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../../services/task_firestore_service.dart';
import '../../jadwal_manage/controllers/jadwal_manage_controller.dart';
import '../../jadwal_manage/models/task_model.dart';

class JadwalAddController extends GetxController {
  // Services
  final TaskFirestoreService _taskService = TaskFirestoreService.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Form Controllers
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  
  // Observable Variables
  final selectedDate = DateTime.now().obs;
  final startTime = TimeOfDay.now().obs;
  final endTime = TimeOfDay(hour: TimeOfDay.now().hour + 1, minute: TimeOfDay.now().minute).obs;
  final selectedPriority = TaskPriority.medium.obs;
  final selectedCategory = TaskCategory.personal.obs;
  final isLoading = false.obs;
  
  // Form Key
  final formKey = GlobalKey<FormState>();
  
  @override
  void onInit() {
    super.onInit();
    // Initialize locale data for Indonesian formatting
    _initializeLocaleData();
    // Get selected date from arguments if available
    if (Get.arguments != null && Get.arguments['selectedDate'] != null) {
      selectedDate.value = Get.arguments['selectedDate'];
    }
  }

  // Initialize locale data
  Future<void> _initializeLocaleData() async {
    try {
      await initializeDateFormatting('id_ID', null);
    } catch (e) {
      // Fallback to default locale if Indonesian locale fails
      print('Failed to initialize Indonesian locale: $e');
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  // Date Selection
  Future<void> selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: selectedDate.value,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      selectedDate.value = picked;
    }
  }

  // Start Time Selection
  Future<void> selectStartTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: Get.context!,
      initialTime: startTime.value,
    );
    if (picked != null) {
      startTime.value = picked;
      // Auto-adjust end time if it's before start time
      if (_timeToMinutes(endTime.value) <= _timeToMinutes(picked)) {
        final newEndHour = picked.hour + 1;
        endTime.value = TimeOfDay(
          hour: newEndHour > 23 ? 23 : newEndHour,
          minute: picked.minute,
        );
      }
    }
  }

  // End Time Selection
  Future<void> selectEndTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: Get.context!,
      initialTime: endTime.value,
    );
    if (picked != null) {
      // Validate that end time is after start time
      if (_timeToMinutes(picked) > _timeToMinutes(startTime.value)) {
        endTime.value = picked;
      } else {
        Get.snackbar(
          'Peringatan',
          'Waktu selesai harus lebih dari waktu mulai',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }
    }
  }

  // Helper method to convert TimeOfDay to minutes
  int _timeToMinutes(TimeOfDay time) {
    return time.hour * 60 + time.minute;
  }

  // Priority Selection
  void updatePriority(TaskPriority priority) {
    selectedPriority.value = priority;
  }

  // Category Selection
  void updateCategory(TaskCategory category) {
    selectedCategory.value = category;
  }

  // Get formatted date
  String get formattedDate {
    try {
      return DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(selectedDate.value);
    } catch (e) {
      // Fallback to simple Indonesian format without locale dependency
      final date = selectedDate.value;
      final dayNames = ['Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'];
      final monthNames = ['', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 
                         'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];
      
      final dayName = dayNames[date.weekday % 7];
      final monthName = monthNames[date.month];
      
      return '$dayName, ${date.day} $monthName ${date.year}';
    }
  }

  // Get formatted start time
  String get formattedStartTime {
    final hour = startTime.value.hour.toString().padLeft(2, '0');
    final minute = startTime.value.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  // Get formatted end time
  String get formattedEndTime {
    final hour = endTime.value.hour.toString().padLeft(2, '0');
    final minute = endTime.value.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  // Get duration in hours and minutes
  String get formattedDuration {
    final startMinutes = _timeToMinutes(startTime.value);
    final endMinutes = _timeToMinutes(endTime.value);
    final durationMinutes = endMinutes - startMinutes;
    
    final hours = durationMinutes ~/ 60;
    final minutes = durationMinutes % 60;
    
    if (hours > 0 && minutes > 0) {
      return '${hours} jam ${minutes} menit';
    } else if (hours > 0) {
      return '${hours} jam';
    } else {
      return '${minutes} menit';
    }
  }

  // Save Task
  Future<void> saveTask() async {
    if (!formKey.currentState!.validate()) return;
    
    // Check if user is authenticated
    if (_auth.currentUser == null) {
      Get.snackbar(
        'Error',
        'Anda harus login terlebih dahulu',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    
    isLoading.value = true;
    
    try {
      // Create DateTime from selected date and start time
      final taskDateTime = DateTime(
        selectedDate.value.year,
        selectedDate.value.month,
        selectedDate.value.day,
        startTime.value.hour,
        startTime.value.minute,
      );
      
      // Create DateTime from selected date and end time
      final taskEndDateTime = DateTime(
        selectedDate.value.year,
        selectedDate.value.month,
        selectedDate.value.day,
        endTime.value.hour,
        endTime.value.minute,
      );
      
      // Create new task
      final task = TaskModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: _auth.currentUser!.uid,
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        date: selectedDate.value,
        time: taskDateTime,
        endTime: taskEndDateTime,
        priority: selectedPriority.value,
        category: selectedCategory.value,
        isCompleted: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      // Save to Firebase
      await _taskService.addTask(task);
      
      // Add to jadwal manage controller (local state)
      final jadwalController = Get.find<JadwalManageController>();
      jadwalController.addTask(task);
      
      // Show success message
      Get.snackbar(
        'Berhasil',
        'Jadwal berhasil ditambahkan',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      
      // Navigate back
      Get.back();
      
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menambahkan jadwal: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Validation
  String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Judul jadwal tidak boleh kosong';
    }
    if (value.trim().length < 3) {
      return 'Judul jadwal minimal 3 karakter';
    }
    return null;
  }

  String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Deskripsi tidak boleh kosong';
    }
    return null;
  }
}
