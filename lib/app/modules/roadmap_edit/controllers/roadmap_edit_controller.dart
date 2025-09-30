import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../roadmap_manage/models/roadmap_models.dart';

class RoadmapEditController extends GetxController {
  // Roadmap data - same structure as roadmap_manage
  final isLoading = false.obs;
  final roadmapTitle = 'Frontend Developer Career Path'.obs;
  final roadmapSteps = <RoadmapMainStep>[].obs;
  final expandedSteps = <String>{}.obs;
  final expandedSubSteps = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeSampleData();
  }

  void _initializeSampleData() {
    isLoading.value = true;
    // Copy same data structure as roadmap_manage
    roadmapSteps.value = [
      RoadmapMainStep(
        id: '1',
        title: 'Mempelajari Frontend Development',
        description: 'Kuasai teknologi dasar untuk pengembangan web frontend',
        isCompleted: false,
        estimatedDuration: '3-4 bulan',
        subSteps: [
          RoadmapSubStep(
            id: '1-1',
            title: 'Belajar HTML & CSS',
            description: 'Pelajari struktur dan styling dasar website',
            isCompleted: true,
            estimatedDuration: '2-3 minggu',
            resources: [
              RoadmapResource(
                type: 'course',
                title: 'HTML & CSS Fundamentals',
                provider: 'Karirvana Academy',
                status: ResourceStatus.completed,
              ),
              RoadmapResource(
                type: 'certificate',
                title: 'Web Development Certificate',
                provider: 'Karirvana',
                status: ResourceStatus.inProgress,
              ),
              RoadmapResource(
                type: 'certificate',
                title: 'HTML5 & CSS3 Certificate',
                provider: 'TechCert',
                status: ResourceStatus.added,
              ),
              RoadmapResource(
                type: 'certificate',
                title: 'Web Design Fundamentals',
                provider: 'DesignPro',
                status: ResourceStatus.notAdded,
              ),
            ],
          ),
          RoadmapSubStep(
            id: '1-2',
            title: 'Belajar JavaScript',
            description: 'Kuasai bahasa pemrograman untuk interaktivitas web',
            isCompleted: false,
            estimatedDuration: '4-6 minggu',
            resources: [
              RoadmapResource(
                type: 'course', 
                title: 'JavaScript Essentials', 
                provider: 'CodeAcademy',
                status: ResourceStatus.notAdded,
              ),
              RoadmapResource(
                type: 'course', 
                title: 'Modern JavaScript ES6+', 
                provider: 'DevSkills',
                status: ResourceStatus.added,
              ),
            ],
          ),
          RoadmapSubStep(
            id: '1-3',
            title: 'Belajar React.js',
            description: 'Pelajari framework React untuk aplikasi web modern',
            isCompleted: false,
            estimatedDuration: '6-8 minggu',
            resources: [
              RoadmapResource(
                type: 'course', 
                title: 'React.js Complete Guide', 
                provider: 'ReactMasters',
                status: ResourceStatus.notAdded,
              ),
              RoadmapResource(
                type: 'certificate', 
                title: 'React Developer Certificate', 
                provider: 'ReactCert',
                status: ResourceStatus.notAdded,
              ),
            ],
          ),
        ],
      ),
      RoadmapMainStep(
        id: '2',
        title: 'Create Portfolio',
        description: 'Bangun portfolio yang menarik dan dapatkan sertifikasi',
        isCompleted: false,
        estimatedDuration: '1-2 bulan',
        subSteps: [
          RoadmapSubStep(
            id: '2-1',
            title: 'Mengikuti Sertifikasi',
            description: 'Dapatkan sertifikasi untuk meningkatkan kredibilitas',
            isCompleted: false,
            estimatedDuration: '2-3 minggu',
            resources: [
              RoadmapResource(
                type: 'certificate', 
                title: 'Frontend Developer Professional', 
                provider: 'TechCert',
                status: ResourceStatus.notAdded,
              ),
              RoadmapResource(
                type: 'certificate', 
                title: 'React.js Specialist', 
                provider: 'ReactCert',
                status: ResourceStatus.notAdded,
              ),
            ],
          ),
          RoadmapSubStep(
            id: '2-2',
            title: 'Membuat CV',
            description: 'Buat CV yang menarik dan profesional',
            isCompleted: false,
            estimatedDuration: '1 minggu',
            resources: [
              RoadmapResource(
                type: 'tool', 
                title: 'CV Assistant', 
                provider: 'Karirvana',
                status: ResourceStatus.notAdded,
              ),
            ],
          ),
          RoadmapSubStep(
            id: '2-3',
            title: 'Bangun Portfolio Website',
            description: 'Buat website portfolio untuk showcase project',
            isCompleted: false,
            estimatedDuration: '2-3 minggu',
            resources: [
              RoadmapResource(
                type: 'course', 
                title: 'Portfolio Website Development', 
                provider: 'WebAcademy',
                status: ResourceStatus.notAdded,
              ),
            ],
          ),
        ],
      ),
      RoadmapMainStep(
        id: '3',
        title: 'Melamar Pekerjaan',
        description: 'Mulai melamar pekerjaan sebagai Frontend Developer',
        isCompleted: false,
        estimatedDuration: '1-3 bulan',
        subSteps: [
          RoadmapSubStep(
            id: '3-1',
            title: 'Persiapan Interview',
            description: 'Siapkan diri untuk proses interview',
            isCompleted: false,
            estimatedDuration: '2-3 minggu',
            resources: [
              RoadmapResource(
                type: 'course', 
                title: 'Technical Interview Mastery', 
                provider: 'InterviewAce',
                status: ResourceStatus.notAdded,
              ),
              RoadmapResource(
                type: 'tool', 
                title: 'Interview Practice', 
                provider: 'Karirvana',
                status: ResourceStatus.notAdded,
              ),
            ],
          ),
          RoadmapSubStep(
            id: '3-2',
            title: 'Apply to Companies',
            description: 'Mulai melamar ke perusahaan target',
            isCompleted: false,
            estimatedDuration: '4-8 minggu',
            resources: [
              RoadmapResource(
                type: 'job', 
                title: 'Frontend Developer - Tokopedia', 
                provider: 'Tokopedia', 
                location: 'Jakarta',
                jobStatus: JobApplicationStatus.applied,
              ),
              RoadmapResource(
                type: 'job', 
                title: 'React Developer - Gojek', 
                provider: 'Gojek', 
                location: 'Jakarta',
                jobStatus: JobApplicationStatus.accepted,
              ),
              RoadmapResource(
                type: 'job', 
                title: 'Web Developer - Shopee', 
                provider: 'Shopee', 
                location: 'Jakarta',
                jobStatus: JobApplicationStatus.notApplied,
              ),
              RoadmapResource(
                type: 'job', 
                title: 'Frontend Engineer - Traveloka', 
                provider: 'Traveloka', 
                location: 'Jakarta',
                jobStatus: JobApplicationStatus.notApplied,
              ),
            ],
          ),
        ],
      ),
    ];
    
    isLoading.value = false;
  }

  // Toggle methods
  void toggleMainStep(String stepId) {
    if (expandedSteps.contains(stepId)) {
      expandedSteps.remove(stepId);
      // Also collapse all sub-steps when main step is collapsed
      final mainStep = roadmapSteps.firstWhere((step) => step.id == stepId);
      for (final subStep in mainStep.subSteps) {
        expandedSubSteps.remove(subStep.id);
      }
    } else {
      expandedSteps.add(stepId);
    }
    expandedSteps.refresh();
    expandedSubSteps.refresh();
  }

  void toggleSubStep(String subStepId) {
    if (expandedSubSteps.contains(subStepId)) {
      expandedSubSteps.remove(subStepId);
    } else {
      expandedSubSteps.add(subStepId);
    }
    expandedSubSteps.refresh();
  }

  // Edit methods
  void editRoadmapTitle() {
    Get.dialog(
      AlertDialog(
        title: const Text('Edit Roadmap Title'),
        content: TextFormField(
          initialValue: roadmapTitle.value,
          decoration: const InputDecoration(
            labelText: 'Roadmap Title',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            roadmapTitle.value = value;
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.snackbar(
                'Success',
                'Roadmap title updated',
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // Delete methods
  void deleteMainStep(String stepId) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Step'),
        content: const Text('Are you sure you want to delete this step? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              roadmapSteps.removeWhere((step) => step.id == stepId);
              expandedSteps.remove(stepId);
              Get.back();
              Get.snackbar(
                'Deleted',
                'Step has been deleted',
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void deleteSubStep(String mainStepId, String subStepId) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Sub-Step'),
        content: const Text('Are you sure you want to delete this sub-step?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final mainStepIndex = roadmapSteps.indexWhere((step) => step.id == mainStepId);
              if (mainStepIndex != -1) {
                roadmapSteps[mainStepIndex].subSteps.removeWhere((subStep) => subStep.id == subStepId);
                expandedSubSteps.remove(subStepId);
                roadmapSteps.refresh();
              }
              Get.back();
              Get.snackbar(
                'Deleted',
                'Sub-step has been deleted',
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void deleteResource(String mainStepId, String subStepId, RoadmapResource resource) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Resource'),
        content: Text('Are you sure you want to delete "${resource.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final mainStepIndex = roadmapSteps.indexWhere((step) => step.id == mainStepId);
              if (mainStepIndex != -1) {
                final subStepIndex = roadmapSteps[mainStepIndex].subSteps.indexWhere((subStep) => subStep.id == subStepId);
                if (subStepIndex != -1) {
                  roadmapSteps[mainStepIndex].subSteps[subStepIndex].resources.remove(resource);
                  roadmapSteps.refresh();
                }
              }
              Get.back();
              Get.snackbar(
                'Deleted',
                'Resource has been deleted',
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // Add methods
  void addSubStep(String mainStepId) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final durationController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('Add Sub-Step'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: durationController,
                decoration: const InputDecoration(
                  labelText: 'Estimated Duration',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                final mainStepIndex = roadmapSteps.indexWhere((step) => step.id == mainStepId);
                if (mainStepIndex != -1) {
                  final newSubStep = RoadmapSubStep(
                    id: '${mainStepId}-${DateTime.now().millisecondsSinceEpoch}',
                    title: titleController.text,
                    description: descriptionController.text,
                    isCompleted: false,
                    estimatedDuration: durationController.text.isEmpty ? '1 minggu' : durationController.text,
                    resources: [],
                  );
                  roadmapSteps[mainStepIndex].subSteps.add(newSubStep);
                  roadmapSteps.refresh();
                }
                Get.back();
                Get.snackbar(
                  'Added',
                  'Sub-step has been added',
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void addResource(String mainStepId, String subStepId) {
    final titleController = TextEditingController();
    final providerController = TextEditingController();
    final locationController = TextEditingController();
    String selectedType = 'course';
    ResourceStatus selectedStatus = ResourceStatus.notAdded;
    JobApplicationStatus selectedJobStatus = JobApplicationStatus.notApplied;

    Get.dialog(
      AlertDialog(
        title: const Text('Add Resource'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedType,
                decoration: const InputDecoration(
                  labelText: 'Type',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'course', child: Text('Course')),
                  DropdownMenuItem(value: 'certificate', child: Text('Certificate')),
                  DropdownMenuItem(value: 'job', child: Text('Job')),
                  DropdownMenuItem(value: 'tool', child: Text('Tool')),
                ],
                onChanged: (value) {
                  selectedType = value!;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: providerController,
                decoration: const InputDecoration(
                  labelText: 'Provider',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: locationController,
                decoration: const InputDecoration(
                  labelText: 'Location (for jobs)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty && providerController.text.isNotEmpty) {
                final mainStepIndex = roadmapSteps.indexWhere((step) => step.id == mainStepId);
                if (mainStepIndex != -1) {
                  final subStepIndex = roadmapSteps[mainStepIndex].subSteps.indexWhere((subStep) => subStep.id == subStepId);
                  if (subStepIndex != -1) {
                    final newResource = RoadmapResource(
                      type: selectedType,
                      title: titleController.text,
                      provider: providerController.text,
                      location: locationController.text.isEmpty ? null : locationController.text,
                      status: selectedStatus,
                      jobStatus: selectedType == 'job' ? selectedJobStatus : null,
                    );
                    roadmapSteps[mainStepIndex].subSteps[subStepIndex].resources.add(newResource);
                    roadmapSteps.refresh();
                  }
                }
                Get.back();
                Get.snackbar(
                  'Added',
                  'Resource has been added',
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void editResource(String mainStepId, String subStepId, RoadmapResource resource) {
    final titleController = TextEditingController(text: resource.title);
    final providerController = TextEditingController(text: resource.provider);
    final locationController = TextEditingController(text: resource.location ?? '');

    Get.dialog(
      AlertDialog(
        title: const Text('Edit Resource'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: providerController,
                decoration: const InputDecoration(
                  labelText: 'Provider',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              if (resource.type == 'job')
                TextFormField(
                  controller: locationController,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(),
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final mainStepIndex = roadmapSteps.indexWhere((step) => step.id == mainStepId);
              if (mainStepIndex != -1) {
                final subStepIndex = roadmapSteps[mainStepIndex].subSteps.indexWhere((subStep) => subStep.id == subStepId);
                if (subStepIndex != -1) {
                  final resourceIndex = roadmapSteps[mainStepIndex].subSteps[subStepIndex].resources.indexOf(resource);
                  if (resourceIndex != -1) {
                    // Update the resource
                    final updatedResource = RoadmapResource(
                      type: resource.type,
                      title: titleController.text,
                      provider: providerController.text,
                      location: locationController.text.isEmpty ? null : locationController.text,
                      status: resource.status,
                      jobStatus: resource.jobStatus,
                    );
                    roadmapSteps[mainStepIndex].subSteps[subStepIndex].resources[resourceIndex] = updatedResource;
                    roadmapSteps.refresh();
                  }
                }
              }
              Get.back();
              Get.snackbar(
                'Updated',
                'Resource has been updated',
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void saveRoadmap() {
    // TODO: Implement save to Firebase or local storage
    Get.snackbar(
      'Saved',
      'Roadmap has been saved successfully',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
    Get.back(); // Return to roadmap_manage
  }

  double get overallProgress {
    if (roadmapSteps.isEmpty) return 0.0;
    
    int totalSteps = 0;
    int completedSteps = 0;
    
    for (final mainStep in roadmapSteps) {
      totalSteps += 1 + mainStep.subSteps.length;
      if (mainStep.isCompleted) completedSteps++;
      for (final subStep in mainStep.subSteps) {
        if (subStep.isCompleted) completedSteps++;
      }
    }
    
    return totalSteps > 0 ? completedSteps / totalSteps : 0.0;
  }
}
