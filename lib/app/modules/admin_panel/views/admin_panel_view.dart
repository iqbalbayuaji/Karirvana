import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../styles/app_colors.dart';
import '../../../services/firebase_data_initializer.dart';
import '../controllers/admin_panel_controller.dart';

class AdminPanelView extends GetView<AdminPanelController> {
  const AdminPanelView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Admin Panel',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            color: AppColors.textOnPrimary,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textOnPrimary),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Firebase Data Management Section
            _buildSectionTitle('Firebase Data Management'),
            const SizedBox(height: 16),
            
            _buildActionCard(
              title: 'Initialize Firebase Data',
              description: 'Populate Firebase with default course and certification data',
              icon: Icons.cloud_upload,
              color: AppColors.primary,
              onTap: () async {
                final confirmed = await _showConfirmationDialog(
                  title: 'Initialize Firebase Data',
                  content: 'This will populate Firebase with default course and certification data. Continue?',
                );
                
                if (confirmed) {
                  await FirebaseDataInitializer.initializeAllData();
                }
              },
            ),
            
            const SizedBox(height: 16),
            
            _buildActionCard(
              title: 'Check Data Status',
              description: 'Check if Firebase data has been initialized',
              icon: Icons.info_outline,
              color: AppColors.secondary,
              onTap: () async {
                final isInitialized = await FirebaseDataInitializer.isDataInitialized();
                
                Get.dialog(
                  AlertDialog(
                    title: const Text('Data Status'),
                    content: Text(
                      isInitialized 
                        ? 'Firebase data has been initialized ✅'
                        : 'Firebase data not initialized ❌'
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
            ),
            
            const SizedBox(height: 16),
            
            _buildActionCard(
              title: 'Reset All Data',
              description: 'Delete all course and certification data from Firebase',
              icon: Icons.delete_forever,
              color: Colors.red,
              onTap: () async {
                final confirmed = await _showConfirmationDialog(
                  title: 'Reset All Data',
                  content: 'This will DELETE ALL course and certification data from Firebase. This action cannot be undone. Are you sure?',
                  confirmText: 'DELETE',
                  isDestructive: true,
                );
                
                if (confirmed) {
                  try {
                    Get.dialog(
                      const Center(
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(height: 16),
                                Text('Deleting all data...'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      barrierDismissible: false,
                    );
                    
                    await FirebaseDataInitializer.resetAllData();
                    
                    Get.back(); // Close loading dialog
                    
                    Get.snackbar(
                      'Success',
                      'All data has been deleted from Firebase',
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: Colors.green,
                      colorText: AppColors.textOnPrimary,
                    );
                    
                  } catch (e) {
                    Get.back(); // Close loading dialog
                    
                    Get.snackbar(
                      'Error',
                      'Failed to delete data: $e',
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: Colors.red,
                      colorText: AppColors.textOnPrimary,
                    );
                  }
                }
              },
            ),
            
            const SizedBox(height: 32),
            
            // App Management Section
            _buildSectionTitle('App Management'),
            const SizedBox(height: 16),
            
            _buildActionCard(
              title: 'View App Statistics',
              description: 'View app usage statistics and analytics',
              icon: Icons.analytics,
              color: AppColors.tertiary,
              onTap: () {
                Get.snackbar(
                  'Coming Soon',
                  'App statistics feature will be available soon',
                  snackPosition: SnackPosition.TOP,
                );
              },
            ),
            
            const SizedBox(height: 16),
            
            _buildActionCard(
              title: 'Manage Users',
              description: 'View and manage user accounts',
              icon: Icons.people,
              color: Colors.orange,
              onTap: () {
                Get.snackbar(
                  'Coming Soon',
                  'User management feature will be available soon',
                  snackPosition: SnackPosition.TOP,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildActionCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.textSecondary,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _showConfirmationDialog({
    required String title,
    required String content,
    String confirmText = 'Confirm',
    bool isDestructive = false,
  }) async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(
              foregroundColor: isDestructive ? Colors.red : AppColors.primary,
            ),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    
    return result ?? false;
  }
}
