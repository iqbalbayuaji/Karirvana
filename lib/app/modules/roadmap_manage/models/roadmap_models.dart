// Data Models for Roadmap Management
class RoadmapMainStep {
  final String id;
  final String title;
  final String description;
  bool isCompleted;
  final String estimatedDuration;
  final List<RoadmapSubStep> subSteps;

  RoadmapMainStep({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.estimatedDuration,
    required this.subSteps,
  });
}

class RoadmapSubStep {
  final String id;
  final String title;
  final String description;
  bool isCompleted;
  final String estimatedDuration;
  final List<RoadmapResource> resources;

  RoadmapSubStep({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.estimatedDuration,
    required this.resources,
  });
}

// Status enum for resources
enum ResourceStatus {
  notAdded,     // Belum ditambahkan/normal
  added,        // Sudah ditambahkan tapi belum dimulai
  inProgress,   // Sedang dikerjakan/on progress
  completed,    // Sudah selesai
}

// Status enum khusus untuk job applications
enum JobApplicationStatus {
  notApplied,   // Belum apply
  applied,      // Sudah apply
  accepted,     // Sudah diterima
}

class RoadmapResource {
  final String type; // 'course', 'certificate', 'job', 'guide', 'tool'
  final String title;
  final String provider;
  final String? location; // For jobs
  final ResourceStatus status;
  final JobApplicationStatus? jobStatus; // Only for job type

  RoadmapResource({
    required this.type,
    required this.title,
    required this.provider,
    this.location,
    this.status = ResourceStatus.notAdded,
    this.jobStatus,
  });
}
